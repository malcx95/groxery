#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
use std::vec;
use rocket_contrib::json::Json;
use rocket_cors;

mod grocery;

#[get("/hello/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}

#[get("/api/groceries")]
fn get_groceries() -> String {
    "kebab".to_string()
}

#[post("/api/grocery", format = "json", data = "<grocery>")]
fn save_grocery(grocery: Json<grocery::Grocery>) -> String {
    println!("{}", grocery.name);
    "det gick bra".to_string()
}


fn main() -> Result<(), rocket_cors::Error> {
    let allowed_origins = rocket_cors::AllowedOrigins::some_exact(&["http://localhost:3000"]);
    let cors = rocket_cors::CorsOptions {
        allowed_origins,
        ..Default::default()
    }.to_cors()?;
    rocket::ignite().mount("/", routes![hello, get_groceries, save_grocery])
        .attach(cors)
        .launch();
    Ok(())
}
