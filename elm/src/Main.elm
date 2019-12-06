module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput)

main =
  Browser.sandbox { init = init, update = update, view = view }

type Msg = Change String

type alias Model =
  { content: String
  }

init =
  Model ""

-- Update

update msg model =
  case msg of
    Change newContent ->
      { model | content = newContent }

view model =
  div []
    [ h1 [] [ text "WELCOME TO GROXERY" ]
    , p [] [ text "Create a new grocery list if you want :)" ]
    , input [ placeholder "Enter some text", value model.content, onInput Change ] [ ]
    , div [] [ text (String.reverse model.content) ]
    ]
