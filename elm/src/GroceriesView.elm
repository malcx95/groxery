module GroceriesView exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)
import Elements.Modal exposing (modal)
import Style

view : Model -> Html Msg
view groceryModel =
  div []
    [ modal (h3 [] [ text "Hejsan" ]) (text "Tjenamors") (h3 [] [text "ojdå"])
    ]
