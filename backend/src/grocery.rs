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


#[derive(Serialize, Deserialize, Clone)]
pub struct Grocery {
    pub id: i32,
    pub name: String,
    pub category: GroceryCategory,
    pub by_weight: bool,
}


#[derive(Serialize, Deserialize, Clone)]
pub struct GroceryList {
    pub name: String,
    pub groceries: Vec<Grocery>,
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

    pub fn new(name: String) -> GroceryList {
        GroceryList {
            name: name,
            groceries: Vec::new()
        }
    }

}
