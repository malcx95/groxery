#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
use std::vec;
use rocket_contrib::json::Json;
use rocket_cors;

mod grocery;
mod groceryio;


#[get("/hello/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}

#[post("/api/grocery", data = "<name>")]
fn create_grocery(name: String) -> String {
    let g = grocery::Grocery::new(name);
    "".to_string()
}

#[post("/api/grocerylist/new", data = "<name>")]
fn create_grocery_list(name: String) {
    let mut data = groceryio::GroceryData::load();
    let grocery_list = grocery::GroceryList::new(name);
    data.add_grocery_list(grocery_list);
    data.save();
}

fn main() -> Result<(), rocket_cors::Error> {
    let allowed_origins = rocket_cors::AllowedOrigins::some_exact(&["http://localhost:3000"]);
    let cors = rocket_cors::CorsOptions {
        allowed_origins,
        ..Default::default()
    }.to_cors()?;
    rocket::ignite().mount("/", routes![hello, create_grocery])
        .attach(cors)
        .launch();
    Ok(())
}
