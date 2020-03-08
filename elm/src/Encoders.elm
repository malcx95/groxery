module Encoders exposing (..)

import Json.Encode as Encode
import Grocery exposing ( GroceryList
                        , GroceryListEntry
                        , Grocery
                        , GroceryCategory
                        , Priority
                        , NewGrocery
                        , groceryCategoryToInt
                        , priorityToInt
                        )


newGroceryEncoder : NewGrocery -> Encode.Value
newGroceryEncoder grocery =
  Encode.object
    [ ( "name", Encode.string grocery.name )
    , ( "category", Encode.int <| groceryCategoryToInt <| grocery.category )
    , ( "by_weight", Encode.bool grocery.byWeight )
    ]

