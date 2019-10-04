use serde::{Deserialize, Serialize};


#[derive(Serialize, Deserialize, FromForm)]
pub struct Grocery {
    pub name: String,
}


impl Grocery {

}

