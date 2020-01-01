use crate::grocery;
use crate::schema::groceries;
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
    name: String,
    category: i32,
    by_weight: bool,
}

#[derive(Queryable)]
struct DbGrocery {
    id: i32,
    name: String,
    category: i32,
    by_weight: bool,
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
    ) -> Option<grocery::Grocery> {
    match diesel::insert_into(groceries::table)
        .values(new_grocery)
        .get_result::<DbGrocery>(conn) {
            Ok(grocery) => Some(grocery.to_grocery()),
            Err(_) => None
    }
}

