module Routes exposing (..)

import Url.Parser exposing (Parser, oneOf, string, s, map)

type Route = Groceries
           | GroceryLists 
           | Inventory


routeParser : Parser (Route -> a) a
routeParser =
  oneOf
    [ map Groceries (s "groceries")
    , map GroceryLists (s "grocerylists")
    , map Inventory (s "inventory")
    ]
