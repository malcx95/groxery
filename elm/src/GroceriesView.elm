module GroceriesView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)
import Elements.ModalType as ModalType
import Elements.NewGroceryModal as NewGroceryModal

import Bootstrap.Modal as Modal
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col

view : Model -> Html Msg
view groceryModel =
  div []
    [ Button.button
      [ Button.attrs [ onClick (GroxeryMsg.OpenModal ModalType.NewGrocery) ] ]
      [ text "New grocery" ]
    , NewGroceryModal.newGroceryModal groceryModel
    ]
