use serde::{Deserialize, Serialize};


#[derive(Serialize, Deserialize)]
pub struct Grocery<'a> {
    pub name: &'a str,
}


impl<'a> Grocery<'a> {

}

