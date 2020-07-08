module Elements.GroceryListItem exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Grocery exposing (..)
import GroxeryMsg exposing (..)


groceryListItem : GroceryListEntry -> Html Msg
groceryListItem entry =
  let
      checkedClass = 
        if entry.checked then
          "grocery-check-list-item-checked"
        else
          "grocery-check-list-item-unchecked"
  in
    div 
      [ class <| "grocery-check-list-item " ++ checkedClass
      , onClick <| GroceryListEntryClicked entry
      ]
      [ text entry.grocery.name
      ]

