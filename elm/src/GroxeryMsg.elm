module GroxeryMsg exposing (..)

import Http
import Grocery exposing (GroceryList)


type Msg
  = GotGroceryLists (Result Http.Error (List GroceryList))
  | CreateGroceryList
  | GroceryListFieldChanged String
  | GroceryListCreated (Result Http.Error ())

