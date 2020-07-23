module GroceryListView exposing (view)

import Dict exposing (Dict)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Button as Button

import GroceryModel exposing (Model)
import Grocery exposing (..)
import GroxeryMsg exposing (..)
import Elements.GroceryListItem exposing (..)


sortGroceryListEntries : GroceryList -> List GroceryListEntry
sortGroceryListEntries groceryList =
  let
    compFn a b = compare a.grocery.name b.grocery.name
  in
    List.sortWith compFn groceryList.entries

newGroceryListElement : Model -> Html Msg
newGroceryListElement model =
  p []
    [ input [ placeholder "New grocery list...", value model.newGroceryList
            , onInput GroxeryMsg.GroceryListFieldChanged ] [ ]
    , button [ onClick GroxeryMsg.CreateGroceryList ] [ text "Create" ]
    ]

viewGroceryListEntry : GroceryListEntry -> ListGroup.Item Msg
viewGroceryListEntry entry =
  ListGroup.li [ ListGroup.attrs [ class "grocery-check-list-item" ] ]
    [ Button.checkboxButton False 
      [ Button.attrs [ class "grocery-check-button" ] ]
      [ text entry.grocery.name ] ]

groceryListBlock : Model -> GroceryList -> Html Msg
groceryListBlock model groceryList =
  let
    extraItem =
      if groceryListIsInEditMode model groceryList.id then
        case model.newGroceryListEntry of
          Nothing ->
            [ newGroceryListItem groceryList.id ]
          Just newEntry ->
            [ editableGroceryListItem model newEntry ]
      else
        [ ]

  in
    div [ class "grocery-list-block" ]
      <| (List.map (\e -> groceryListItem model groceryList.id e) (sortGroceryListEntries groceryList))
      ++ extraItem

viewGroceryList : Model -> GroceryList -> Html Msg
viewGroceryList model groceryList =
  Card.config [ Card.attrs [ class "grocery-list-card" ] ]
    |> Card.headerH2 [] [ text groceryList.name ]
    |> Card.footer [] [ groceryListFooter model groceryList.id ]
    |> Card.block [ Block.attrs [ class "grocery-list-card-body" ] ] 
      [ Block.custom <| groceryListBlock model groceryList ]
    |> Card.view

groceryListFooter : Model -> Int -> Html Msg
groceryListFooter model id =
  let
    addOrEditButton =
      [ Button.button
        [ Button.primary, Button.onClick (GroceryListEditButtonClicked id)]
        [ text "Add or edit" ]
      ]
    doneButton =
      [ Button.button 
        [ Button.success, Button.onClick GroceryListDoneButtonClicked ]
        [ text "Done" ]
      ]
    contents =
      if groceryListIsInEditMode model id then
        doneButton
      else
        addOrEditButton
  in
    div [ class "grocery-list-footer" ] contents

viewGroceryLists : Model -> Html Msg
viewGroceryLists model =
  div [ class "list-container" ] 
    (List.map (\l -> viewGroceryList model l) model.groceryLists)

view : Model -> Html Msg
view groceryModel =
  div []
    [ h1 [ class "text" ] [ text "Grocery lists" ]
    , p [] [ text "Here are your grocery lists." ]
    , viewGroceryLists groceryModel
    , newGroceryListElement groceryModel
    ]
