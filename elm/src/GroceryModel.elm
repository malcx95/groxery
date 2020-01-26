module GroceryModel exposing (Model)

import Browser.Navigation as Nav
import Url
import Html.Styled exposing (..)
import Routes exposing (Route)
import Grocery exposing (GroceryList)
import GroxeryMsg exposing (Msg)

type alias Model =
  { key: Nav.Key
  , route: Maybe Route
  , groceryLists: List GroceryList
  , newGroceryList: String
  , currentModal: Maybe (Html Msg)
  }
