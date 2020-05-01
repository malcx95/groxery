module GroceryModel exposing (Model)

import Browser.Navigation as Nav
import Url
import Html.Styled exposing (..)
import Routes exposing (Route)
import Grocery exposing (GroceryList, GroceryCategory, NewGrocery, Grocery)
import GroxeryMsg exposing (Msg)
import Requests
import Elements.ModalType exposing (..)

type alias Model =
  { key: Nav.Key
  , route: Maybe Route
  , groceryLists: List GroceryList
  , newGroceryList: String
  , newGrocery: NewGrocery
  , currentGroceryId: Maybe Int
  , visibleModals: VisibleModals
  , loadedGroceries: Maybe (List Grocery)
  }
