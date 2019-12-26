module GroceryView exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import GroceryModel exposing (Model)

import Grocery exposing (..)
import GroxeryMsg exposing (..)
import Style


newGroceryListElement : Model -> Html Msg
newGroceryListElement model =
  p []
    [ input [ placeholder "New grocery list...", value model.newGroceryList
            , onInput GroxeryMsg.GroceryListFieldChanged ] [ ]
    , button [ onClick GroxeryMsg.CreateGroceryList ] [ text "Create" ]
    ]

viewGrocery : Grocery -> Html Msg
viewGrocery grocery =
  div []
    [ p [ css [ Style.textStyle ] ] [ text grocery.name ]
    ]


viewGroceryList : GroceryList -> Html Msg
viewGroceryList groceryList =
  div []
    [ h3 [ css [ Style.textStyle ] ] [ text groceryList.name ]
    , div [] (List.map viewGrocery groceryList.groceries)
    ]

viewGroceryLists : Model -> Html Msg
viewGroceryLists model =
  div [] ((List.map viewGroceryList model.groceryLists) ++ [ newGroceryListElement model ])


view : Model -> Html Msg
view groceryModel =
  div [] 
    [ h1 [ css [ Style.textStyle ] ] [ text "Grocery lists" ]
    , p [] [ text "Here are your grocery lists." ]
    , viewGroceryLists groceryModel
    ]
