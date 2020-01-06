module GroceriesView exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)
import Style

view : Model -> Html Msg
view groceryModel =
  div []
    [ text "TJA!"
    ]
