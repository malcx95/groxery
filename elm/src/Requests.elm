module Requests exposing (apiUrl, getGroceryLists, createGroceryList)

import Http
import GroxeryMsg exposing (Msg)
import Json.Decode exposing (Decoder, field, string, list, map2)
import Json.Encode
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

createGroceryList : String -> Cmd Msg
createGroceryList name =
  Http.post
    { url = apiUrl "grocerylist/new"
    , body = Http.stringBody "application/text" name
    , expect = Http.expectWhatever GroxeryMsg.GroceryListCreated
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
