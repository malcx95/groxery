module Decoders exposing (..)

import Json.Decode exposing ( Decoder
                            , field
                            , string
                            , bool
                            , int
                            , list
                            , nullable
                            , map
                            , map3
                            , map4
                            , map5)

import Grocery exposing ( GroceryList
                        , GroceryListEntry
                        , Grocery
                        , GroceryCategory
                        , Priority
                        , intToGroceryCategory
                        , intToPriority
                        )


groceryDecoder : Decoder Grocery
groceryDecoder =
  map4 Grocery
    (field "id" int)
    (field "name" string)
    (field "category" (map intToGroceryCategory int))
    (field "by_weight" bool)


groceryListEntryDecoder : Decoder GroceryListEntry
groceryListEntryDecoder =
  map5 GroceryListEntry
    (field "id" int)
    (field "priority" (map intToPriority int))
    (field "grocery" groceryDecoder)
    (field "amount" (nullable string))
    (field "checked" bool)


groceryListDecoder : Decoder GroceryList
groceryListDecoder =
  map3 GroceryList
    (field "id" int)
    (field "name" string)
    (field "entries" (list groceryListEntryDecoder))


groceryListsDecoder : Decoder (List GroceryList)
groceryListsDecoder =
  list groceryListDecoder


groceriesDecoder : Decoder (List Grocery)
groceriesDecoder =
  list groceryDecoder
