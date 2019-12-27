module GroxeryMsg exposing (..)

import Http
import Browser
import Url
import Grocery exposing (GroceryList)


type Msg
  = GotGroceryLists (Result Http.Error (List GroceryList))
  | LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | CreateGroceryList
  | GroceryListFieldChanged String
  | GroceryListCreated (Result Http.Error ())

