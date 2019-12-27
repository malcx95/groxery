module GroceryModel exposing (Model)

import Browser.Navigation as Nav
import Url
import Routes exposing (Route)
import Grocery exposing (GroceryList)

type alias Model =
  { key: Nav.Key
  , route: Maybe Route
  , groceryLists: List GroceryList
  , newGroceryList: String
  }
