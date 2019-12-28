module UI exposing (..)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import Routes exposing (Route)
import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)
import Style

sidebar : Model -> Html Msg
sidebar model =
  div [ css [ Style.sideBarStyle ] ]
    [ viewLink "/grocerylists" "Grocery Lists" Routes.GroceryLists model.route
    , viewLink "/groceries" "All Groceries" Routes.Groceries model.route
    , viewLink "/inventory" "Inventory" Routes.Inventory model.route
    ]

header : Html Msg
header =
  div [ css [ Style.headerStyle ] ] [ h1 [ css [ Style.titleStyle ] ] [ text "Groxery" ] ]

contentContainer : Html Msg -> Html Msg
contentContainer view =
  div [ css [ Style.contentContainerStyle ] ] [ view ]

viewLink : String -> String -> Routes.Route -> Maybe Routes.Route -> Html Msg
viewLink path name route selectedRoute =
  let
    backgroundColor =
      case selectedRoute of
        Just r ->
          if route == r then
            Style.sideBarColorSelected
          else
            Style.sideBarColor
        Nothing ->
          Style.sideBarColor
  in
    a [ css [ Style.sideBarLinkStyle backgroundColor ], href path ] [ text name ]
