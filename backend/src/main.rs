#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
#[macro_use] extern crate diesel;
use std::vec;
use std::io::Cursor;
use std::fs::File;
use std::io::prelude::*;

use rocket_contrib::json::Json;
use rocket::http::ContentType;
use rocket::Response;
use rocket::response::status;
use rocket::response;
use rocket::http::Status;
use rocket_cors;

mod grocery;
mod db;
mod schema;

#[get("/grocerylist/all")]
fn get_grocery_lists()
    -> Result<Json<Vec<grocery::GroceryList>>,
        status::BadRequest<String>> {
    let conn = db::establish_connection();

    match db::get_all_grocery_lists(&conn) {
        Ok(grocery_lists) => Ok(Json(grocery_lists)),
        Err(()) => Err(status::BadRequest(None))
    }
}


#[post("/grocery/new", format = "json", data = "<grocery>")]
fn create_grocery(grocery: Json<db::NewGrocery>)
    -> Result<Json<grocery::Grocery>, status::BadRequest<String>> {
    let new_grocery = grocery.into_inner();
    let conn = db::establish_connection();
    match db::create_grocery(&conn, &new_grocery) {
        Ok(grocery) => Ok(Json(grocery)),
        Err(()) => Err(status::BadRequest(None)),
    }
}


#[get("/grocery/all")]
fn get_all_groceries()
    -> Result<Json<Vec<grocery::Grocery>>, status::BadRequest<String>> {
    let conn = db::establish_connection();
    match db::get_all_groceries(&conn) {
        Ok(groceries) => Ok(Json(groceries)),
        Err(()) => Err(status::BadRequest(None)),
    }
}


#[post("/grocerylist/new", data = "<name>")]
fn create_grocery_list(name: String)
    -> Result<Json<grocery::GroceryList>, status::BadRequest<String>> {
    let new_grocery_list = db::NewGroceryList { name };
    let conn = db::establish_connection();
    match db::create_grocery_list(&conn, &new_grocery_list) {
        Ok(grocery_list) => Ok(Json(grocery_list)),
        Err(()) => Err(status::BadRequest(None)),
    }
}


#[post("/grocerylist/add", format = "json", data = "<new_entry>")]
fn add_grocery_to_list(new_entry: Json<db::NewGroceryListEntry>)
    -> Result<(), status::BadRequest<String>> {
    let entry = new_entry.into_inner();
    let conn = db::establish_connection();
    db::add_grocery_to_list(&conn, &entry)
        .or(Err(status::BadRequest(None)))
}


#[get("/groceries")]
fn get_groceries_page<'r>() -> response::Result<'r> {
    get_page()
}


#[get("/grocerylists")]
fn get_grocery_lists_page<'r>() -> response::Result<'r> {
    get_page()
}


#[get("/inventory")]
fn get_inventory_page<'r>() -> response::Result<'r> {
    get_page()
}


#[get("/")]
fn get_page<'r>() -> response::Result<'r> {
    let mut file = match File::open("../elm/public/index.html") {
        Ok(f) => f,
        Err(_) => {
            return Response::build()
                .status(Status::NotFound)
                .header(ContentType::Plain)
                .sized_body(Cursor::new("Could not find index.html"))
                .ok()
        }
    };
    let mut contents = String::new();
    file.read_to_string(&mut contents).unwrap();
    return Response::build()
        .status(Status::Ok)
        .header(ContentType::HTML)
        .sized_body(Cursor::new(contents))
        .ok()
}


fn main() -> Result<(), rocket_cors::Error> {
    rocket::ignite()
        .mount("/api", routes![
            get_grocery_lists,
            create_grocery,
            create_grocery_list,
            get_all_groceries,
            add_grocery_to_list,
        ])
        .mount("/", routes![
            get_page, get_inventory_page, get_grocery_lists_page, get_groceries_page
        ])
        .launch();
    Ok(())
}
