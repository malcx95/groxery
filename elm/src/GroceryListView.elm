module GroceryListView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Bootstrap.Card as Card
import Bootstrap.ListGroup as ListGroup

import GroceryModel exposing (Model)
import Grocery exposing (..)
import GroxeryMsg exposing (..)


newGroceryListElement : Model -> Html Msg
newGroceryListElement model =
  p []
    [ input [ placeholder "New grocery list...", value model.newGroceryList
            , onInput GroxeryMsg.GroceryListFieldChanged ] [ ]
    , button [ onClick GroxeryMsg.CreateGroceryList ] [ text "Create" ]
    ]

viewGroceryListEntry : GroceryListEntry -> ListGroup.Item Msg
viewGroceryListEntry entry =
  ListGroup.li [] [ text entry.grocery.name ]
  -- div []
  --   [ p [ class "text" ] [ text entry.grocery.name ]
  --   ]

viewGroceryList : GroceryList -> Html Msg
viewGroceryList groceryList =
  -- div []
  --   [ h3 [ class "text" ] [ text groceryList.name ]
  --   , div [] (List.map viewGroceryListEntry groceryList.entries)
  --   ]
  Card.config [ Card.attrs [ class "grocery-list-card" ] ]
    |> Card.headerH2 [] [ text groceryList.name ]
    |> Card.footer [] [ text "dis is foot" ]
    |> Card.listGroup (List.map viewGroceryListEntry groceryList.entries)
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
