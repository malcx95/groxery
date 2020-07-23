module Requests exposing ( apiUrl
                         , getGroceryLists
                         , createGroceryList
                         , createGrocery
                         , getAllGroceries
                         , editGrocery
                         , setGroceryListEntryChecked
                         , queryGrocery
                         , getGroceryById
                         )

import Http
import GroxeryMsg exposing (Msg)
import Encoders exposing (..)
import Grocery exposing (GroceryList, Grocery, NewGrocery)
import Decoders exposing (..)


boolToString : Bool -> String
boolToString b = if b then "true" else "false"


apiUrl : String -> String
apiUrl url =
  "http://localhost:8000/api/" ++ url

getGroceryLists : Cmd Msg
getGroceryLists =
  Http.get
    { url = apiUrl "grocerylist/all"
    , expect = Http.expectJson GroxeryMsg.GotGroceryLists groceryListsDecoder
    }

getAllGroceries : Cmd Msg
getAllGroceries =
  Http.get
    { url = apiUrl "grocery/all"
    , expect = Http.expectJson GroxeryMsg.GroceriesLoaded groceriesDecoder
    }

createGroceryList : String -> Cmd Msg
createGroceryList name =
  Http.post
    { url = apiUrl "grocerylist/new"
    , body = Http.stringBody "application/text" name
    , expect = Http.expectJson GroxeryMsg.GroceryListCreated groceryListsDecoder
    }

createGrocery : NewGrocery -> Cmd Msg
createGrocery grocery =
  Http.post
    { url = apiUrl "grocery/new"
    , body = Http.jsonBody <| newGroceryEncoder <| grocery
    , expect = Http.expectWhatever GroxeryMsg.GroceryCreated
    }

editGrocery : Int -> NewGrocery -> Cmd Msg
editGrocery id grocery =
  Http.request
    { method = "PUT"
    , headers = []
    , url = apiUrl "grocery/" ++ (String.fromInt id) ++ "/edit"
    , body = Http.jsonBody <| newGroceryEncoder <| grocery
    , expect = Http.expectWhatever GroxeryMsg.GroceryCreated
    , timeout = Nothing
    , tracker = Nothing
    }

setGroceryListEntryChecked : Int -> Bool -> Cmd Msg
setGroceryListEntryChecked id checked =
  Http.request
    { method = "PUT"
    , headers = []
    , url = apiUrl "grocerylist/check/"
                    ++ (String.fromInt id)
                    ++ "/" 
                    ++ (boolToString checked)
    , body = Http.emptyBody
    , expect = Http.expectJson GroxeryMsg.GroceryListEntryCheckedChanged groceryListsDecoder
    , timeout = Nothing
    , tracker = Nothing
    }


queryGrocery : String -> Cmd Msg
queryGrocery queryString =
  Http.get
    { url = apiUrl "grocery/query?query_str=" ++ queryString
    , expect =
        Http.expectJson
          (\r -> GroxeryMsg.SearchableInputEvent (GroxeryMsg.GotSuggestions r))
          groceryQuerySuggestionsDecoder
    }


getGroceryById : Int -> (Result Http.Error Grocery -> Msg) -> Cmd Msg
getGroceryById id msg =
  Http.get
    { url = apiUrl "grocery/id" ++ String.fromInt id
    , expect = Http.expectJson msg groceryDecoder
    }


