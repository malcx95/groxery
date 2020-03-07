module Requests exposing (apiUrl, getGroceryLists, createGroceryList, createGrocery)

import Http
import GroxeryMsg exposing (Msg)
import Encoders exposing (..)
import Grocery exposing (GroceryList, Grocery)
import Decoders exposing (..)

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

createGrocery : Grocery -> Cmd Msg
createGrocery grocery =
  Http.post
    { url = apiUrl "grocery/new"
    , body = Http.jsonBody <| groceryEncoder <| grocery
    , expect = Http.expectWhatever GroxeryMsg.GroceryCreated
    }
