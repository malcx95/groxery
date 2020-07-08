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
import Elements.GroceryListItem exposing (groceryListItem)

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

groceryListBlock : GroceryList -> Html Msg
groceryListBlock groceryList =
  div [ class "grocery-list-block" ]
    (List.map groceryListItem (sortGroceryListEntries groceryList))


viewGroceryList : GroceryList -> Html Msg
viewGroceryList groceryList =
  Card.config [ Card.attrs [ class "grocery-list-card" ] ]
    |> Card.headerH2 [] [ text groceryList.name ]
    |> Card.footer [] [ text "dis is foot" ]
    |> Card.block [ Block.attrs [ class "grocery-list-card-body" ] ] 
      [ Block.custom <| groceryListBlock <| groceryList ]
    --|> Card.block (List.map viewGroceryListEntry groceryList.entries)
    |> Card.view

viewGroceryLists : Model -> Html Msg
viewGroceryLists model =
  div [ class "list-container" ] 
    (List.map viewGroceryList model.groceryLists)

view : Model -> Html Msg
view groceryModel =
  div []
    [ h1 [ class "text" ] [ text "Grocery lists" ]
    , p [] [ text "Here are your grocery lists." ]
    , viewGroceryLists groceryModel
    , newGroceryListElement groceryModel
    ]
