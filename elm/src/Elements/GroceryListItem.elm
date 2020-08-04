module Elements.GroceryListItem exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Elements.SearchableInput exposing (searchableInput)
import Grocery exposing (..)
import GroxeryMsg exposing (..)
import GroceryModel exposing (Model)

import Bootstrap.Form.Input as Input


groceryListIsInEditMode : Model -> Int -> Bool
groceryListIsInEditMode model id =
  case model.editingGroceryList of
    Nothing ->
      False
    Just editingId ->
      editingId == id


groceryListItem : Model -> Int -> GroceryListEntry -> Html Msg
groceryListItem model groceryListId entry =
  let
    checkedClass =
      if entry.checked && (not (groceryListIsInEditMode model groceryListId)) then
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


-- TODO istället för detta, lägg till en "Edit/Add"-knapp i footern,
-- som gör att man hamnar i redigeringsläge. Då ska det finnas en Add-knapp
-- i footern, som lägger till en tom entry. Man ska också kunna redigera de
-- som redan finns där. Om det får plats, checkrutor som man kan använda för
-- att radera items.


editableGroceryListItem : Model -> NewGroceryListEntry -> Html Msg
editableGroceryListItem model entry =
  div [ class "grocery-list-editable-item" ]
    [ searchableInput model "groceries-input-box"
    ]


newGroceryListItem : Html Msg
newGroceryListItem =
  div
    [ class "new-grocery-check-list-item"
    , onClick GroceryListAddItemButtonClicked
    ]
    [ text "+"
    ]


