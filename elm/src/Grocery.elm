import Html exposing (..)

type alias Grocery = 
  { name : String
  , id : String
  }


type alias GroceryList =
  { name: String
  , groceries: List Grocery
  }


renderGrocery : Grocery -> Html
renderGrocery grocery =
  div []
    [ p [] [ text grocery.name ]
    ]

renderGroceryList : GroceryList -> List Html
renderGroceryList groceryList =
  map renderGrocery groceryList
