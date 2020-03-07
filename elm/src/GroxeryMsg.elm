module GroxeryMsg exposing (..)

import Http
import Html.Styled exposing (..)
import Browser
import Url
import Grocery exposing (GroceryList, Grocery)


type ModalResult
  = NewGrocery Grocery


type Msg
  = GotGroceryLists (Result Http.Error (List GroceryList))
  | LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | CreateGroceryList
  | CreateGrocery
  | GroceryListFieldChanged String
  | GroceryListCreated (Result Http.Error ())
  | GroceryCreated (Result Http.Error ())
  | GroceryDropdownSelected (Maybe String)
  | GroceryNameInputChanged String
  | InitView
  | OpenModal (Html Msg)
  | CloseModal (Maybe ModalResult)
