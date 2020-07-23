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


#[derive(Serialize, Deserialize, Insertable, Debug, Clone)]
#[table_name="grocery_list_entries"]
pub struct NewGroceryListEntry {
    pub list_id: i32,
    pub priority: i32,
    pub grocery_id: i32,
    pub amount: String,
    pub checked: bool,
}


#[derive(Associations, Queryable)]
#[table_name="grocery_list_entries"]
struct DbGroceryListEntry {
    id: i32,
    list_id: i32,
    priority: i32,
    grocery_id: i32,
    amount: String,
    checked: bool,
}

#[derive(Queryable)]
struct DbGroceryList {
    id: i32,
    name: String,
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


impl DbGroceryListEntry {

    fn to_grocery_list_entry(&self, grocery: grocery::Grocery)
        -> grocery::GroceryListEntry {
        let amount: Option<grocery::Amount>;
        if self.amount == "".to_string() {
            amount = None;
        } else if grocery.by_weight {
            amount = Some(grocery::Amount::Weight(self.amount.clone()));
        } else {
            amount = Some(grocery::Amount::Number(
                self.amount.parse::<u32>().unwrap()
            ));
        }
        grocery::GroceryListEntry {
            id: self.id,
            priority: self.priority,
            grocery: grocery,
            amount: amount,
            checked: self.checked
        }
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
    diesel::insert_into(groceries::table)
        .values(new_grocery)
        .get_result::<grocery::Grocery>(conn).or(Err(()))
}


pub fn update_grocery(
        conn: &PgConnection,
        id: i32,
        new_grocery: &NewGrocery
    ) -> Result<grocery::Grocery, ()> {
    diesel::update(groceries::table.filter(groceries::id.eq(id)))
        .set((
            groceries::name.eq(new_grocery.name.clone()),
            groceries::category.eq(new_grocery.category),
            groceries::by_weight.eq(new_grocery.by_weight),
            ))
        .get_result::<grocery::Grocery>(conn).or(Err(()))
}


pub fn get_all_groceries(conn: &PgConnection)
        -> Result<Vec<grocery::Grocery>, ()> {
    groceries::table.load::<grocery::Grocery>(conn).or(Err(()))
}


pub fn get_grocery_by_id(conn: &PgConnection, id: i32)
    -> Result<Option<grocery::Grocery>, ()> {
    let result = match groceries::table
        .filter(groceries::id.eq(id))
        .load::<grocery::Grocery>(conn) {
        Ok(result) => result,
        Err(_) => return Err(()),
    };
    if result.is_empty() {
        Ok(None)
    } else {
        Ok(Some(result[0].clone()))
    }
}


pub fn create_grocery_list(
    conn: &PgConnection, new_grocery_list: &NewGroceryList
    ) -> Result<Vec<grocery::GroceryList>, ()> {
    match diesel::insert_into(grocery_lists::table)
        .values(new_grocery_list)
        .execute(conn) {
        Ok(_) => get_all_grocery_lists(conn),
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


pub fn add_grocery_to_list(
    conn: &PgConnection, new_grocery_list_entry: &NewGroceryListEntry)
    -> Result<(), ()> {
    match diesel::insert_into(grocery_list_entries::table)
        .values(new_grocery_list_entry)
        .execute(conn) {
        Ok(_) => Ok(()),
        Err(_) => Err(())
    }
}


pub fn set_grocery_list_entry_checked(
    conn: &PgConnection, id: i32, check: bool)
    -> Result<Vec<grocery::GroceryList>, ()> {

    match diesel::update(grocery_list_entries::table.filter(
            grocery_list_entries::id.eq(id)))
        .set(grocery_list_entries::checked.eq(check))
        .execute(conn) {
        Ok(_) => get_all_grocery_lists(conn),
        Err(_) => Err(())
    }
}


pub fn query_groceries(conn: &PgConnection, query_str: &str, limit: i64)
    -> Result<Vec<grocery::Grocery>, ()> {
    match groceries::table
        .filter(groceries::name.ilike(String::from("%") + query_str + "%"))
        .limit(limit)
        .load::<grocery::Grocery>(conn) {
            Ok(groceries) => Ok(groceries),
            Err(_) => Err(())
    }
}
