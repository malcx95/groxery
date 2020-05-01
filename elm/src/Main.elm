module Main exposing (..)

import Browser
import Browser.Navigation as Nav
import Url
import Url.Parser
import Routes exposing (Route)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, on)
import GroxeryMsg exposing (Msg)
import Grocery exposing ( Grocery
                        , GroceryList
                        , stringToGroceryCategory
                        , emptyNewGrocery
                        , groceryToNewGrocery
                        )
import Elements.ModalType as ModalType
import GroceryModel exposing (Model)
import GroceryListView
import GroceriesView
import Requests
import Http
import UI
import Task
import Json.Decode as Decode
import Elements.ModalType as ModalType
import Bootstrap.CDN as CDN

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
    model = Model
              key
              route
              []
              ""
              emptyNewGrocery
              Nothing
              ModalType.allInvisible
              Nothing
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

    GroxeryMsg.OpenModal modalType ->
      (openModal model modalType, Cmd.none)

    GroxeryMsg.CloseModal maybeModalResult ->
      let
        newModel = { model | visibleModals = ModalType.allInvisible }
      in
        case maybeModalResult of
          Nothing ->
            (newModel, Cmd.none)
          Just modalResult ->
            case modalResult of
              GroxeryMsg.CreateNewGrocery ->
                (newModel, Requests.createGrocery model.newGrocery)
              GroxeryMsg.UpdateGrocery id ->
                (newModel, Requests.editGrocery id model.newGrocery)

    GroxeryMsg.GroceryCreated result ->
      case result of
        Ok _ ->
          let
            command =
              case model.route of
                Just r ->
                  case r of
                    Routes.Groceries ->
                      Requests.getAllGroceries
                    _ -> Cmd.none
                _ -> Cmd.none
          in
            ({ model | newGrocery = emptyNewGrocery }, command)
        Err _ ->
          (model, Cmd.none)

    GroxeryMsg.GroceryDropdownSelected selection ->
      let
        newGrocery = model.newGrocery
        newCategory = stringToGroceryCategory selection
      in
        ({ model | newGrocery = { newGrocery | category = newCategory } }, Cmd.none)

    GroxeryMsg.GroceryNameInputChanged name ->
      let
        newGrocery = model.newGrocery
      in
        ({ model | newGrocery = { newGrocery | name = name } }, Cmd.none)

    GroxeryMsg.GroceryByWeightChanged newByWeight ->
      let
        newGrocery = model.newGrocery

        newNewGrocery =
            { newGrocery | byWeight = newByWeight}
      in
        ({ model | newGrocery = newNewGrocery }, Cmd.none)

    GroxeryMsg.GroceriesLoaded result ->
      case result of
        Ok groceries ->
          ({ model | loadedGroceries = Just groceries }, Cmd.none)

        Err _ ->
          ({ model | loadedGroceries = Nothing }, Cmd.none)

    GroxeryMsg.EditGrocery grocery ->
      let
        newModel =
          { model | newGrocery = groceryToNewGrocery grocery
                  , currentGroceryId = Just grocery.id }
      in
        (openModal newModel ModalType.NewGrocery, Cmd.none)

    GroxeryMsg.GroceryEdited result ->
      let
        newModel = { model | currentGroceryId = Nothing }
      in
        case result of
          Ok _ ->
            (newModel, Requests.getAllGroceries)
          Err _ ->
            (newModel, Cmd.none)


openModal : Model -> ModalType.ModalType -> Model
openModal model modalType =
  let
    newVisibleModals = ModalType.setVisible model.visibleModals modalType
  in
    { model | visibleModals = newVisibleModals }


initView : Model -> ( Model, Cmd Msg )
initView model =
  case model.route of
    Just route ->
      case route of
        Routes.GroceryLists ->
          ( model, Requests.getGroceryLists )
        Routes.Groceries ->
          ( model, Requests.getAllGroceries )
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
              (\m -> GroceriesView.view m)
            Routes.GroceryLists ->
              (\m -> GroceryListView.view m)
            Routes.Inventory ->
              (\_ -> text "Inventory")
        Nothing ->
          (\_ -> h1 []
            [ text "Click something in the side bar" ])

    sidebar = UI.sidebar model
    header = UI.header
    contentContainer = UI.contentContainer <| currentView model
  in
    { title = "Groxery"
    , body = [ CDN.stylesheet
             , header
             , sidebar
             , contentContainer ]
    }
