#![feature(proc_macro_hygiene, decl_macro)]

#[macro_use] extern crate rocket;
use std::vec;
use std::collections::HashMap;
use std::io::Cursor;
use std::fs::File;
use std::io::prelude::*;

use rocket_contrib::json::Json;
use rocket_contrib::serve::StaticFiles;
use rocket::http::ContentType;
use rocket::Response;
use rocket::response::status;
use rocket::response;
use rocket::http::Status;
use rocket_cors;

mod grocery;
mod groceryio;

use crate::groceryio::GroceryDataError;

#[get("/grocerylist/all")]
fn get_grocery_lists()
    -> Result<Json<Vec<grocery::GroceryList>>,
        status::BadRequest<String>> {
    match groceryio::GroceryData::load() {
        Ok(data) => Ok(Json(data.grocery_lists.values().cloned().collect())),
        Err(GroceryDataError::FileCorrupted) => {
            Err(status::BadRequest(Some(String::from("fileCorrupted"))))
        }
        Err(_) => {
            Err(status::BadRequest(Some(String::from("unknownLoadError"))))
        }
    }
}

#[post("/grocery", data = "<name>")]
fn create_grocery(name: String) -> String {
    let g = grocery::Grocery::new(name);
    "".to_string()
}

#[post("/grocerylist/new", data = "<name>")]
fn create_grocery_list<'r>(name: String) -> response::Result<'r> {
    println!("{}", name);
    let mut data = match groceryio::GroceryData::load() {
        Ok(data) => data,
        Err(GroceryDataError::FileCorrupted) => return Response::build()
            .status(Status::BadRequest)
            .header(ContentType::Plain)
            .sized_body(Cursor::new("fileCorrupted"))
            .ok(),
        _ => return Response::build()
            .status(Status::BadRequest)
            .header(ContentType::Plain)
            .sized_body(Cursor::new("unknownLoadError"))
            .ok()
    };
    let grocery_list = grocery::GroceryList::new(name);
    match data.add_grocery_list(grocery_list) {
        Ok(()) => (),
        Err(GroceryDataError::ListAlreadyExists) => return Response::build()
            .status(Status::BadRequest)
            .header(ContentType::Plain)
            .sized_body(Cursor::new("listAlreadyExists"))
            .ok(),
        _ => panic!("This should not happen!")
    };
    match data.save() {
        Ok(()) => (),
        Err(_) => return Response::build()
            .status(Status::BadRequest)
            .header(ContentType::Plain)
            .sized_body(Cursor::new("unknownSaveError"))
            .ok()
    }
    Response::build().status(Status::Ok).ok()
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
        .status(Status::BadRequest)
        .header(ContentType::HTML)
        .sized_body(Cursor::new(contents))
        .ok()
}


fn main() -> Result<(), rocket_cors::Error> {
    rocket::ignite()
        .mount("/api", routes![
            get_grocery_lists, create_grocery, create_grocery_list
        ])
        .mount("/", routes![
            get_page, get_inventory_page, get_grocery_lists_page, get_groceries_page
        ])
        .launch();
    Ok(())
}
