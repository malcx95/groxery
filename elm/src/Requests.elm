module Requests exposing (..)

apiUrl : String -> String
apiUrl url =
    "http://localhost:8000/api/" ++ url

