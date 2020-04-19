module UI exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Routes exposing (Route)
import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)

sidebar : Model -> Html Msg
sidebar model =
  div [ class "side-bar" ]
    [ viewLink "/grocerylists" "Grocery Lists" Routes.GroceryLists model.route
    , viewLink "/groceries" "All Groceries" Routes.Groceries model.route
    , viewLink "/inventory" "Inventory" Routes.Inventory model.route
    ]

header : Html Msg
header =
  div [ class "header" ] [ h1 [ class "title" ] [ text "Groxery" ] ]

contentContainer : Html Msg -> Html Msg
contentContainer view =
  div [ class "content-container" ] [ view ]

viewLink : String -> String -> Routes.Route -> Maybe Routes.Route -> Html Msg
viewLink path name route selectedRoute =
  let
    classNames =
      case selectedRoute of
        Just r ->
          if r == route then
            "side-bar-link side-bar-color-selected"
          else
            "side-bar-link side-bar-color-unselected"
        Nothing ->
            "side-bar-link side-bar-color-unselected"
  in
    a [ class classNames, href path ] [ text name ]
