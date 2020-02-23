module Encoders exposing (..)

import Json.Encode as Encode
import Grocery exposing ( GroceryList
                        , GroceryListEntry
                        , Grocery
                        , GroceryCategory
                        , Priority
                        , groceryCategoryToInt
                        , priorityToInt
                        )


groceryEncoder : Grocery -> Encode.Value
groceryEncoder grocery =
  Encode.object
    [ ( "id", Encode.int grocery.id )
    , ( "name", Encode.string grocery.name )
    , ( "category", Encode.int <| groceryCategoryToInt <| grocery.category )
    , ( "by_weight", Encode.bool grocery.byWeight )
    ]


