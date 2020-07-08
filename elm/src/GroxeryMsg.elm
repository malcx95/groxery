module GroxeryMsg exposing (..)

import Http
import Html.Styled exposing (..)
import Browser
import Url
import Grocery exposing (GroceryList, Grocery, GroceryListEntry)
import Elements.ModalType exposing (..)


type ModalResult
  = CreateNewGrocery
  | UpdateGrocery Int


type Msg
  = GotGroceryLists (Result Http.Error (List GroceryList))
  | LinkClicked Browser.UrlRequest
  | UrlChanged Url.Url
  | CreateGroceryList
  | GroceryListFieldChanged String
  | GroceryListCreated (Result Http.Error (List GroceryList))
  | GroceryCreated (Result Http.Error ())
  | GroceryDropdownSelected String
  | GroceryNameInputChanged String
  | GroceryByWeightChanged Bool
  | InitView
  | OpenModal ModalType
  | CloseModal (Maybe ModalResult)
  | GroceriesLoaded (Result Http.Error (List Grocery))
  | EditGrocery Grocery
  | GroceryEdited (Result Http.Error ())
  | GroceryListEntryClicked GroceryListEntry
  | GroceryListEntryCheckedChanged (Result Http.Error (List GroceryList))
