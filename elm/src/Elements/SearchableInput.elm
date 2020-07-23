module Elements.SearchableInput exposing ( searchableInput
                                         , searchableInputUpdate
                                         )



import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Grocery exposing (..)
import GroxeryMsg exposing (..)
import GroceryModel exposing (Model)
import Requests

import Json.Decode as Json
import Keyboard.Event exposing (decodeKey)
import Bootstrap.Form.Input as Input


searchableInputUpdate : Model -> SearchableInputMsg -> (Model, Cmd Msg)
searchableInputUpdate model msg =
  let
    oldState = model.searchableInputState
    suggestionsLength =
      case oldState.suggestions of
        Nothing -> 0
        Just suggestions ->
          List.length suggestions
  in
    case msg of
      FocusChanged state ->
        ( { model | 
          searchableInputState = { oldState | focus = state, selected = 0 } }
        , Cmd.none )

      ItemHover index ->
        ( { model | 
          searchableInputState = { oldState | selected = index } }
        , Cmd.none )

      KeyPressed maybeKey ->
        case maybeKey of
          Nothing -> (model, Cmd.none)
          Just key ->
            let
              oldSelected = oldState.selected
              newSelected =
                if key == "ArrowUp" then
                  modBy suggestionsLength (oldSelected - 1)
                else if key == "ArrowDown" then
                  modBy suggestionsLength (oldSelected + 1)
                else
                  oldSelected

              (newState, cmd) =
                if key == "Enter" && model.searchableInputState.focus then
                  ( { oldState | focus = False, selected = 0 }
                  , Cmd.none ) -- TODO hämta grocery
                else
                  ( { oldState | selected = newSelected }, Cmd.none )
            in
              ( { model | searchableInputState = newState }, cmd )

      TextEntered string ->
        (model, Requests.queryGrocery string)

      GotSuggestions maybeGroceryQuerySuggestions ->
        let
          newSuggestions =
            case maybeGroceryQuerySuggestions of
              Ok groceryQuerySuggestions -> Just groceryQuerySuggestions
              Err _ -> Nothing
        in
          ( { model | 
            searchableInputState = { oldState | suggestions = newSuggestions } }
          , Cmd.none )


searchableInput : Model -> Html Msg
searchableInput model =
  let
    state = model.searchableInputState

    selectedIndex = state.selected

    listItem index querySuggestion =
      let
        itemClass =
          if index == selectedIndex then
            "groceries-suggestions-item-selected"
          else
            "groceries-suggestions-item"
      in
        li [ class itemClass
           , onMouseOver <| SearchableInputEvent <| ItemHover index
           ]
           [ text querySuggestion.name ]
    
    suggestions =
      let
        listDiv =
          div [ class "groceries-suggestions-div" ]
      in
        case state.suggestions of
          Nothing ->
            listDiv [ text "No matches" ]
          Just options ->
            if state.focus then
              listDiv
                [ ul [ class "groceries-suggestions-list" ]
                  <| List.indexedMap listItem options ]
            else
              div [] []
  in
    div []
      [ Input.text
        [ Input.small
        , Input.placeholder "Search for groceries"
        , Input.attrs
          [ class "groceries-input-box"
          , onFocus <| SearchableInputEvent (FocusChanged True)
          , onBlur <| SearchableInputEvent (FocusChanged False)
          , on "keypress"
            <| Json.map (\k -> SearchableInputEvent (KeyPressed k)) decodeKey 
          , onInput <| (\t -> SearchableInputEvent (TextEntered t))
          ]
        ]
      , suggestions
      ]
