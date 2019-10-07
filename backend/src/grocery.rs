use serde::{Deserialize, Serialize};
use uuid::Uuid;


#[derive(Serialize, Deserialize)]
pub struct Grocery {
    pub name: String,
    pub id: Uuid,
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

