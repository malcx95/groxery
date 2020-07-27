module Elements.SearchableInput exposing ( searchableInput
                                         , searchableInputUpdate
                                         )



import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser.Dom as Dom
import Task
import Grocery exposing (..)
import GroxeryMsg exposing (..)
import GroceryModel exposing (Model, SearchableInputState)
import Requests
import Array

import Json.Decode as Json
import Keyboard.Event exposing (decodeKey)
import Bootstrap.Form.Input as Input
import Debug exposing (log)


getSelectedGroceryId : SearchableInputState -> Int
getSelectedGroceryId state =
  let
    maybeArray =
      case state.suggestions of
        Nothing -> Nothing
        Just suggestions ->
          Just <| Array.fromList suggestions
    maybeSuggestion =
      case maybeArray of
        Nothing -> Nothing
        Just array ->
          Array.get state.selected array
  in
    case maybeSuggestion of
      Nothing -> -1 -- should never happen
      Just suggestion -> suggestion.id


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
                  , Requests.getGroceryById
                    (getSelectedGroceryId oldState)
                    (\g -> SearchableInputEvent <| GotGrocery g) )
                else
                  ( { oldState | selected = newSelected }, Cmd.none )
            in
              ( { model | searchableInputState = newState }, cmd )

      TextEntered string ->
        ( model, Requests.queryGrocery string )

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

      GotGrocery result ->
        let
          newModel =
            case result of
              Ok grocery ->
                ( { model |
                  searchableInputState = { oldState | selectedGrocery = Just grocery } } )
              Err _ -> model
        in
          ( newModel, Cmd.none )

      ItemClicked id ->
        ( model, Requests.getGroceryById id (\g -> SearchableInputEvent <| GotGrocery g ) )

      ItemReset ->
        ( { model | searchableInputState = { oldState | selectedGrocery = Nothing } }
        , Task.attempt (\_ -> NoOp) <| Dom.focus "seachable-input-box" )


searchableInput : Model -> String -> Html Msg
searchableInput model className =
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
           , onMouseDown <| SearchableInputEvent <| ItemClicked querySuggestion.id
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

    textInput =
      Input.text
      [ Input.small
      , Input.placeholder "Search for groceries"
      , Input.attrs
        [ class className
        , id "seachable-input-box"
        , onFocus <| SearchableInputEvent (FocusChanged True)
        , onBlur <| SearchableInputEvent (FocusChanged False)
        , on "keydown"
          <| Json.map (\k -> SearchableInputEvent (KeyPressed k)) decodeKey
        , onInput <| (\t -> SearchableInputEvent (TextEntered t))
        ]
      ]

    selectedGroceryElement grocery =
      div [ class "searchable-input-selected"
          , onClick <| SearchableInputEvent ItemReset
          ] [ text grocery.name ]

    groceryInput =
      case state.selectedGrocery of
        Nothing -> textInput
        Just grocery -> selectedGroceryElement grocery
  in
    div [] [ groceryInput, suggestions ]
