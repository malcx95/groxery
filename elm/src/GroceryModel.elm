module GroceryModel exposing ( Model
                             , SearchableInputState
                             , defaultSearchableInputState )

import Browser.Navigation as Nav
import Url
import Html.Styled exposing (..)
import Routes exposing (Route)
import Grocery exposing ( GroceryList
                        , GroceryCategory
                        , NewGrocery
                        , Grocery
                        , NewGroceryListEntry
                        , GroceryQuerySuggestion
                        )
import GroxeryMsg exposing (Msg)
import Requests
import Elements.ModalType exposing (..)

type alias SearchableInputState =
  { focus: Bool
  , selected: Int
  , selectedGrocery: Maybe Grocery
  , suggestions: Maybe (List GroceryQuerySuggestion)
  }

defaultSearchableInputState : SearchableInputState
defaultSearchableInputState =
  SearchableInputState False 0 Nothing Nothing

type alias Model =
  { key: Nav.Key
  , route: Maybe Route
  , groceryLists: List GroceryList
  , newGroceryList: String
  , newGrocery: NewGrocery
  , currentGroceryId: Maybe Int
  , visibleModals: VisibleModals
  , loadedGroceries: Maybe (List Grocery)
  , editingGroceryList: Maybe Int
  , newGroceryListEntry: Maybe NewGroceryListEntry
  , searchableInputState: SearchableInputState
  }
