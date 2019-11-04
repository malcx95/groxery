use serde::{Deserialize, Serialize};
use std::collections::HashMap;
use std::fs::File;
use std::io::prelude::*;
use std::path::Path;

use crate::grocery;

const GROCERY_FILE_NAME: &str = "/home/malcolm/.groceries.json";

pub enum GroceryDataError {
    ListAlreadyExists,
    FileCorrupted,
    UnknownError(String)
}

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

    pub fn save(&self) -> Result<(), GroceryDataError> {
        let mut file = File::create(GROCERY_FILE_NAME)
            .or(Err(GroceryDataError::UnknownError(
                        String::from("Could not open file!"))))?;
        let json_string = serde_json::to_string(self).unwrap();
        match file.write_all(&json_string.into_bytes()) {
            Ok(_) => Ok(()),
            Err(_) => Err(GroceryDataError::UnknownError(
                    String::from("Could not write to grocery data file!")))
        }
    }

    pub fn load() -> Result<GroceryData, GroceryDataError> {
        if !Path::new(GROCERY_FILE_NAME).exists() {
            return Ok(GroceryData::new());
        }
        let mut file = File::open(GROCERY_FILE_NAME)
            .or(Err(GroceryDataError::UnknownError(
                        String::from("Could not open file!"))))?;
        let mut contents = String::new();
        file.read_to_string(&mut contents)
            .or(Err(GroceryDataError::UnknownError(
                    String::from("Could not read grocery data"))))?;
        match serde_json::from_str(&contents) {
            Ok(data) => Ok(data),
            Err(_) => Err(GroceryDataError::FileCorrupted)
        }
    }

    pub fn add_grocery_list(&mut self,
        grocery_list: grocery::GroceryList) -> Result<(), GroceryDataError> {
        if !self.grocery_lists.contains_key(&grocery_list.name) {
            self.grocery_lists.insert(grocery_list.name.clone(), grocery_list);
            Ok(())
        } else {
            Err(GroceryDataError::ListAlreadyExists)
        }
    }
}
