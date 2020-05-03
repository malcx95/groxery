use serde::{Deserialize, Serialize};
use std::vec::Vec;

use crate::schema::*;


#[derive(Identifiable, Queryable, Serialize, Deserialize, Clone)]
#[table_name="groceries"]
pub struct Grocery {
    pub id: i32,
    pub name: String,
    pub category: i32,
    pub by_weight: bool,
}


// TODO: Add "amount", which is a string in the database
// to handle both by weight and not. Create an enum for amount.
// Also add "checked" property
#[derive(Serialize, Deserialize, Clone)]
pub struct GroceryListEntry {
    pub id: i32,
    pub priority: i32,
    pub grocery: Grocery,
}


#[derive(Serialize, Deserialize, Clone)]
pub struct GroceryList {
    pub id: i32,
    pub name: String,
    pub entries: Vec<GroceryListEntry>,
}


impl Grocery {

    pub fn new(
        name: String, id: i32, category: i32, by_weight: bool
        ) -> Grocery {
        Grocery {
            name,
            id,
            category,
            by_weight,
        }
    }

}

impl GroceryList {

    pub fn new(id: i32, name: String) -> GroceryList {
        GroceryList {
            id: id,
            name: name,
            entries: vec!()
        }
    }

}
