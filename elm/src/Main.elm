module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser
import Routes exposing (Route)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Html.Styled
import Html.Styled exposing (toUnstyled)
import GroxeryMsg exposing (Msg)
import Grocery exposing (Grocery, GroceryList)
import GroceryModel exposing (Model)
import GroceryListView
import Requests
import Http
import Style
import UI
import Task

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
  let
    route = Url.Parser.parse Routes.routeParser url
    model = Model key route [] ""
  in
    initView model


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
      initView { model | route = Url.Parser.parse Routes.routeParser url }
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

    GroxeryMsg.InitView ->
      initView model


initView : Model -> ( Model, Cmd Msg )
initView model =
  case model.route of
    Just route ->
      case route of
        Routes.GroceryLists ->
          ( model, Requests.getGroceryLists )
        Routes.Groceries ->
          ( model, Cmd.none )-- TODO init code here
        Routes.Inventory ->
          ( model, Cmd.none ) -- TODO init code here
    Nothing ->
      ( model, Cmd.none )


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
              (\_ -> Html.Styled.text "Groceries")
            Routes.GroceryLists ->
              (\m -> GroceryListView.view m)
            Routes.Inventory ->
              (\_ -> Html.Styled.text "Inventory")
        Nothing ->
          (\_ -> Html.Styled.h1 []
            [ Html.Styled.text "Click something in the side bar" ])

    sidebar = toUnstyled <| UI.sidebar model
    header = toUnstyled UI.header
    contentContainer = toUnstyled <| UI.contentContainer <| currentView model
  in
    { title = "Groxery"
    , body = [ header
             , sidebar
             , contentContainer ]
    }
