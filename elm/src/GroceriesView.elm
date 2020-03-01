module GroceriesView exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)
import Elements.Modal as Modal
import Style

view : Model -> Html Msg
view groceryModel =
  let
    modal = Modal.newGroceryModal groceryModel
  in
    div []
      [ button [ onClick (GroxeryMsg.OpenModal modal) ]
        [ text "New grocery" ] ]
