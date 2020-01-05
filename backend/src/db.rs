use crate::grocery;
use crate::schema::*;
use serde::{Deserialize, Serialize};

use diesel;
use diesel::prelude::*;
use diesel::pg::PgConnection;
use dotenv::dotenv;
use std::env;
use num_traits::{FromPrimitive, ToPrimitive};


#[derive(Serialize, Deserialize, Insertable, Debug, Clone)]
#[table_name="groceries"]
pub struct NewGrocery {
    pub name: String,
    pub category: i32,
    pub by_weight: bool,
}


#[derive(Serialize, Deserialize, Insertable, Debug, Clone)]
#[table_name="grocery_lists"]
pub struct NewGroceryList {
    pub name: String,
}


#[derive(Queryable)]
struct DbGrocery {
    id: i32,
    name: String,
    category: i32,
    by_weight: bool,
}


#[derive(Queryable)]
struct DbGroceryList {
    id: i32,
    name: String,
}


#[derive(Queryable)]
struct DbGroceryListEntry {
    id: i32,
    list_id: i32,
    priority: i32,
    grocery_id: i32,
}


impl DbGrocery {

    fn to_grocery(&self) -> grocery::Grocery {
        let category = match grocery::GroceryCategory::from_i32(
            self.category
            ) {
            Some(c) => c,
            None => panic!("Category was invalid!")
        };
        grocery::Grocery {
            id: self.id,
            name: self.name.clone(),
            category: category,
            by_weight: self.by_weight
        }
    }

    fn from_grocery(grocery: grocery::Grocery) -> Self {
        let category = match grocery.category.to_i32() {
            Some(c) => c,
            None => panic!("Could not convert category to int! Maybe more than one category has the same value?")
        };
        Self {
            id: grocery.id,
            name: grocery.name.clone(),
            category: category,
            by_weight: grocery.by_weight,
        }
    }
}


impl DbGroceryListEntry {

    fn to_grocery_list_entry(&self, grocery: grocery::Grocery)
        -> grocery::GroceryListEntry {
        let priority = match grocery::Priority::from_i32(self.priority) {
            Some(p) => p,
            None => panic!("Priority was invalid!"),
        };
        grocery::GroceryListEntry {
            id: self.id,
            priority: priority,
            grocery: grocery,
        }
    }
}


impl DbGroceryList {

    fn to_grocery_list(&self, entries: Vec<grocery::GroceryListEntry>)
        -> grocery::GroceryList {
        grocery::GroceryList {
            id: self.id,
            name: self.name.clone(),
            entries: entries,
        }
    }

    fn to_empty_grocery_list(&self) -> grocery::GroceryList {
        grocery::GroceryList::new(self.id, self.name.clone())
    }
}


pub fn establish_connection() -> PgConnection {
    dotenv().ok();

    let database_url = env::var("DATABASE_URL")
        .expect("DATABASE_URL must be set");
    PgConnection::establish(&database_url)
        .expect(&format!("Error connecting to {}", database_url))
}


pub fn create_grocery(
        conn: &PgConnection,
        new_grocery: &NewGrocery
    ) -> Result<grocery::Grocery, ()> {
    match diesel::insert_into(groceries::table)
        .values(new_grocery)
        .get_result::<DbGrocery>(conn) {
        Ok(grocery) => Ok(grocery.to_grocery()),
        Err(_) => Err(())
    }
}


pub fn get_all_groceries(conn: &PgConnection)
        -> Result<Vec<grocery::Grocery>, ()> {
    match groceries::table.load::<DbGrocery>(conn) {
        Ok(result) => Ok(result.iter().map(|g| g.to_grocery()).collect()),
        Err(_) => Err(()),
    }
}


pub fn get_grocery_by_id(conn: &PgConnection, id: i32)
    -> Result<Option<grocery::Grocery>, ()> {
    let result = match groceries::table
        .filter(groceries::id.eq(id))
        .load::<DbGrocery>(conn) {
        Ok(result) => result,
        Err(_) => return Err(()),
    };
    if result.is_empty() {
        Ok(None)
    } else {
        Ok(Some(result[0].to_grocery()))
    }
}


pub fn create_grocery_list(
    conn: &PgConnection, new_grocery_list: &NewGroceryList
    ) -> Result<grocery::GroceryList, ()> {
    match diesel::insert_into(grocery_lists::table)
        .values(new_grocery_list)
        .get_result::<DbGroceryList>(conn) {
        Ok(list) => Ok(list.to_empty_grocery_list()),
        Err(_) => Err(()),
    }
}


pub fn get_all_grocery_lists(conn: &PgConnection)
    -> Result<Vec<grocery::GroceryList>, ()> {
    let db_grocery_lists = 
        match grocery_lists::table.load::<DbGroceryList>(conn) {
        Ok(lists) => lists,
        Err(_) => return Err(()),
    };
    let mut grocery_lists = vec!();
    for list in db_grocery_lists {
        let entries = match grocery_list_entries::table
            .filter(grocery_list_entries::list_id.eq(list.id))
            .load::<DbGroceryListEntry>(conn) {
            Ok(e) => e,
            Err(_) => return Err(())
        };
        let mut grocery_list_entries = vec!();
        for entry in entries {
            let grocery = match get_grocery_by_id(conn, entry.grocery_id) {
                Ok(Some(g)) => g,
                _ => return Err(())
            };
            grocery_list_entries.push(entry.to_grocery_list_entry(grocery));
        }

        grocery_lists.push(list.to_grocery_list(grocery_list_entries));
    }
    Ok(grocery_lists)
}
