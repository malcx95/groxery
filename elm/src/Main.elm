module Main exposing (..)

import Browser
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (onInput)
import GroxeryMsg exposing (Msg)
import Grocery exposing (Grocery, GroceryList)
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



-- MODEL


type Model
  = Failure
  | Loading
  | Success (List GroceryList)


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Requests.getGroceryLists
  )



-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GroxeryMsg.GotGroceryLists result ->
      case result of
        Ok groceryLists ->
          (Success groceryLists, Cmd.none)

        Err _ ->
          (Failure, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none



-- VIEW


view : Model -> Html Msg
view model =
  case model of
    Failure ->
      text ":("

    Loading ->
      text "Loading..."

    Success groceryLists ->
      GroceryView.view groceryLists


-- view model =
--   div []
--     [ h1 [] [ text "WELCOME TO GROXERY" ]
--     , p [] [ text "Create a new grocery list if you want :)" ]
--     , input [ placeholder "Enter some text", value model.content, onInput Change ] [ ]
--     , div [] [ text (String.reverse model.content) ]
--     ]
