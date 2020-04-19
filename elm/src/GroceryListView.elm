module GroceryListView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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

viewGroceryListEntry : GroceryListEntry -> Html Msg
viewGroceryListEntry entry =
  div []
    [ p [ class "text" ] [ text entry.grocery.name ]
    ]

viewGroceryList : GroceryList -> Html Msg
viewGroceryList groceryList =
  div []
    [ h3 [ class "text" ] [ text groceryList.name ]
    , div [] (List.map viewGroceryListEntry groceryList.entries)
    ]

viewGroceryLists : Model -> Html Msg
viewGroceryLists model =
  div [] ((List.map viewGroceryList model.groceryLists) ++ [ newGroceryListElement model ])


view : Model -> Html Msg
view groceryModel =
  div [] 
    [ h1 [ class "text" ] [ text "Grocery lists" ]
    , p [] [ text "Here are your grocery lists." ]
    , viewGroceryLists groceryModel
    ]
