module GroceryView exposing (view)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css)

import Grocery exposing (..)
import GroxeryMsg exposing (..)
import Style

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

viewGroceryLists : List GroceryList -> Html Msg
viewGroceryLists groceryLists =
  div [] (List.map viewGroceryList groceryLists)


view : List GroceryList -> Html Msg
view groceryLists =
  div [] 
    [ h1 [ css [ Style.textStyle ] ] [ text "Grocery lists" ]
    , p [] [ text "Here are your grocery lists." ]
    , viewGroceryLists groceryLists
    ]
