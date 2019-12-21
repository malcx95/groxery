module Grocery exposing (..)


type alias Grocery = 
  { name : String
  , id : String
  }


type alias GroceryList =
  { name: String
  , groceries: List Grocery
  }


