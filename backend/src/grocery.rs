use serde::{Deserialize, Serialize};
use uuid::Uuid;
use std::vec::Vec;


#[derive(Serialize, Deserialize, Clone)]
pub struct Grocery {
    pub name: String,
    pub id: Uuid,
}


#[derive(Serialize, Deserialize, Clone)]
pub struct GroceryList {
    pub name: String,
    pub groceries: Vec<Grocery>,
}


impl Grocery {

    pub fn new(name: String) -> Grocery {
        let uuid = Uuid::new_v4();
        Grocery {
            name: name,
            id: uuid
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
