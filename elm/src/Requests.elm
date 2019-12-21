module Requests exposing (..)

import Http
import GroxeryMsg exposing (Msg)
import Json.Decode exposing (Decoder, field, string, list, map2)
import Grocery exposing (GroceryList, Grocery)

apiUrl : String -> String
apiUrl url =
  "http://localhost:8000/api/" ++ url

getGroceryLists : Cmd Msg
getGroceryLists =
  Http.get
    { url = apiUrl "grocerylist/all"
    , expect = Http.expectJson GroxeryMsg.GotGroceryLists groceryListsDecoder
    }


groceryDecoder : Decoder Grocery
groceryDecoder =
  map2 Grocery
    (field "name" string)
    (field "id" string)

groceryListDecoder : Decoder GroceryList
groceryListDecoder =
  map2 GroceryList
    (field "name" string)
    (field "groceries" (list groceryDecoder))

groceryListsDecoder : Decoder (List GroceryList)
groceryListsDecoder =
  list groceryListDecoder
