module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser
import Routes exposing (Route)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html.Styled exposing (toUnstyled)
import GroxeryMsg exposing (Msg)
import Grocery exposing (Grocery, GroceryList)
import GroceryModel exposing (Model)
import GroceryView
import Requests
import Http
import Style

sideBarColor =
  "#404040"

sideBarColorSelected =
  "#505050"

-- MAIN

main =
  Browser.application
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    , onUrlChange = GroxeryMsg.UrlChanged
    , onUrlRequest = GroxeryMsg.LinkClicked
    }


init : () -> Url.Url -> Nav.Key -> (Model, Cmd Msg)
init _ url key =
  ( Model key Nothing [] "", Cmd.none )


-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GroxeryMsg.LinkClicked urlRequest ->
      case urlRequest of
        Browser.Internal url ->
          ( model, Nav.pushUrl model.key (Url.toString url) )

        Browser.External href ->
          ( model, Nav.load href )

    GroxeryMsg.UrlChanged url ->
      ( { model | route = Url.Parser.parse Routes.routeParser url }
      , Cmd.none
      )
    GroxeryMsg.GotGroceryLists result ->
      case result of
        Ok groceryLists ->
          ({ model | groceryLists = groceryLists }, Cmd.none)

        Err _ ->
          ({ model | groceryLists = [] }, Cmd.none)

    GroxeryMsg.GroceryListFieldChanged newContent ->
      ({ model | newGroceryList = newContent }, Cmd.none)

    GroxeryMsg.CreateGroceryList ->
      (model, Requests.createGroceryList model.newGroceryList)

    GroxeryMsg.GroceryListCreated result ->
      case result of
        Ok _ ->
          (model, Cmd.none)
        Err _ ->
          ({ model | groceryLists = [] }, Cmd.none)


-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
  let
    currentView =
      case model.route of
        Just route ->
          case route of
            Routes.Groceries ->
              (\_ -> text "Groceries")
            Routes.GroceryLists ->
              (\m -> toUnstyled <| GroceryView.view m)
            Routes.Inventory ->
              (\_ -> text "Inventory")
        Nothing ->
          (\_ -> h1 [] [ text "Click something in the side bar" ])

    sidebar =
      div [ style "height" "100%"
          , style "width" "200px"
          , style "position" "fixed"
          , style "top" "0"
          , style "left" "0"
          , style "overflow-x" "hidden"
          , style "padding-top" "60px"
          , style "background-color" "#404040"
          ]
        [ viewLink "/grocerylists" "Grocery Lists" Routes.GroceryLists model.route
        , viewLink "/groceries" "All Groceries" Routes.Groceries model.route
        , viewLink "/inventory" "Inventory" Routes.Inventory model.route
        ]

    header =
      div [ style "margin-left" "200px"
          , style "text-align" "center"
        ] [ h1 [] [ text "Groxery" ] ]

  in
    { title = "Groxery"
    , body = [ header
             , sidebar
             , div [ style "height" "100%"
                   , style "margin-left" "200px"
                   ] [ currentView model ] ]
    }

viewLink : String -> String -> Routes.Route -> Maybe Routes.Route -> Html msg
viewLink path name route selectedRoute =
  let
    backgroundColor =
      case selectedRoute of
        Just r ->
          if route == r then
            sideBarColorSelected
          else
            sideBarColor
        Nothing ->
          sideBarColor
  in
    a [ style "padding" "8px"
      , style "text-decoration" "none"
      , style "font-size" "25px"
      , style "color" "#ffffff"
      , style "background-color" backgroundColor
      , style "display" "block"
      , href path ] [ text name ]
