module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onInput)
import GroxeryMsg exposing (Msg)
import Grocery exposing (Grocery, GroceryList)
import GroceryModel exposing (Model)
import GroceryView
import Requests
import Http
import Style

-- MAIN

main =
  Browser.document
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = (\model -> Browser.Document "Groxery" [toUnstyled <| view model])
    }



init : () -> (Model, Cmd Msg)
init _ =
  ( Model [] ""
  , Requests.getGroceryLists
  )



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
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


view : Model -> Html Msg
view model =
  GroceryView.view model


-- view model =
--   div []
--     [ h1 [] [ text "WELCOME TO GROXERY" ]
--     , p [] [ text "Create a new grocery list if you want :)" ]
--     , input [ placeholder "Enter some text", value model.content, onInput Change ] [ ]
--     , div [] [ text (String.reverse model.content) ]
--     ]
