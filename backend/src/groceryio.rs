use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use crate::grocery;

const GROCERY_FILE_NAME: &str = "/home/malcolm/.groceries.json";


#[derive(Deserialize, Serialize)]
pub struct GroceryData {
    pub grocery_lists: HashMap<String, grocery::GroceryList>
}

impl GroceryData {

    pub fn new() -> GroceryData {
        GroceryData {
            grocery_lists: HashMap::new()
        }
    }

    pub fn save(&self) {
        let mut file: File;
        if Path::new(GROCERY_FILE_NAME).exists() {
            file = File::open(GROCERY_FILE_NAME).unwrap();
        } else {
            file = File::create(GROCERY_FILE_NAME).unwrap();
        }
        let json_string = serde_json::to_string(self).unwrap();
        file.write_all(&json_string.into_bytes()).unwrap();
    }

    pub fn load() -> GroceryData {
        if Path::new(GROCERY_FILE_NAME).exists() {
            return GroceryData::new();
        }
        let mut file = File::open(GROCERY_FILE_NAME).unwrap();
        let mut contents = String::new();
        file.read_to_string(&mut contents).unwrap();
        serde_json::from_str(&contents).unwrap()
    }

    pub fn add_grocery_list(&mut self, grocery_list: grocery::GroceryList) {
        self.grocery_lists.insert(grocery_list.name.clone(), grocery_list);
    }
}
