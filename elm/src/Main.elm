module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)
import Requests
import Http

-- MAIN

main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }



-- MODEL


type Model
  = Failure
  | Loading
  | Success String


init : () -> (Model, Cmd Msg)
init _ =
  ( Loading
  , Http.get
      { url = Requests.apiUrl "grocerylist/all"
      , expect = Http.expectString GotText
      }
  )



-- UPDATE


type Msg
  = GotText (Result Http.Error String)


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GotText result ->
      case result of
        Ok fullText ->
          (Success fullText, Cmd.none)

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

    Success fullText ->
      pre [] [ text fullText ]


-- view model =
--   div []
--     [ h1 [] [ text "WELCOME TO GROXERY" ]
--     , p [] [ text "Create a new grocery list if you want :)" ]
--     , input [ placeholder "Enter some text", value model.content, onInput Change ] [ ]
--     , div [] [ text (String.reverse model.content) ]
--     ]
