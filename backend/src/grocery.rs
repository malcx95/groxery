use serde::{Deserialize, Serialize};
use std::vec::Vec;
use enum_primitive_derive::*;
use num_traits;


#[derive(Primitive, Serialize, Deserialize, Clone, Debug, PartialEq)]
pub enum GroceryCategory {
    Dairy = 0,
    Meat = 1,
    Seafood = 2,
    Colonial = 3,
    FruitOrVegetable = 4,
    Snacks = 5,
    Drinks = 6,
    Frozen = 7,
    Charcuterie = 8,
    Hygiene = 9,
    Other = 10
}


#[derive(Primitive, Serialize, Deserialize, Clone, Debug, PartialEq)]
pub enum Priority {
    Low = 0,
    Medium = 1,
    High = 2,
}


#[derive(Serialize, Deserialize, Clone)]
pub struct Grocery {
    pub id: i32,
    pub name: String,
    pub category: GroceryCategory,
    pub by_weight: bool,
}


#[derive(Serialize, Deserialize, Clone)]
pub struct GroceryListEntry {
    pub id: i32,
    pub priority: Priority,
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
        name: String, id: i32, category: GroceryCategory, by_weight: bool
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
