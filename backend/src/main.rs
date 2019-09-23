#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;

mod grocery;

#[get("/hello/<name>/<age>")]
fn hello(name: String, age: u8) -> String {
    format!("Hello, {} year old named {}!", age, name)
}

#[get("/groceries")]
fn get_groceries() -> String {
    "kebab".to_string()
}

fn main() {
    rocket::ignite().mount("/", routes![hello, get_groceries]).launch();
}
