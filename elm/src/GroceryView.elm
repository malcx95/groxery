module GroceryView exposing (..)

import Grocery exposing (..)
import Html exposing (..)
import GroxeryMsg exposing (..)

viewGrocery : Grocery -> Html Msg
viewGrocery grocery =
  div []
    [ p [] [ text grocery.name ]
    ]

-- viewGroceryList : GroceryList -> List (Html Msg)
-- viewGroceryList groceryList =
--   map viewGrocery groceryList.groceries
