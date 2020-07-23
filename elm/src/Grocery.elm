module Grocery exposing (..)


type alias Grocery = 
  { id : Int
  , name : String
  , category : GroceryCategory
  , byWeight : Bool
  }


type alias GroceryQuerySuggestion =
  { id: Int
  , name : String
  }


type alias NewGrocery =
  { name: String
  , category: GroceryCategory
  , byWeight: Bool
  }


type alias GroceryListEntry =
  { id : Int
  , priority : Priority
  , grocery : Grocery
  , amount: Maybe String
  , checked: Bool
  }


type alias NewGroceryListEntry =
  { priority : Priority
  , groceryId : Int
  , amount: Maybe String
  }


type alias GroceryList =
  { id: Int
  , name: String
  , entries: List GroceryListEntry
  }


type GroceryCategory = Dairy
                     | Meat
                     | Seafood
                     | Colonial
                     | FruitOrVegetable
                     | Snacks
                     | Drinks
                     | Frozen
                     | Charcuterie
                     | Hygiene
                     | Other


type Priority = Low
              | Medium
              | High

groceryToNewGrocery : Grocery -> NewGrocery
groceryToNewGrocery grocery =
  NewGrocery grocery.name grocery.category grocery.byWeight

emptyNewGroceryListEntry : NewGroceryListEntry
emptyNewGroceryListEntry =
  NewGroceryListEntry Low -1 Nothing

emptyNewGrocery : NewGrocery
emptyNewGrocery =
  { name = ""
  , category = Dairy
  , byWeight = False }

intToGroceryCategory : Int -> GroceryCategory
intToGroceryCategory num =
  case num of
    0  -> Dairy
    1  -> Meat
    2  -> Seafood
    3  -> Colonial
    4  -> FruitOrVegetable
    5  -> Snacks
    6  -> Drinks
    7  -> Frozen
    8  -> Charcuterie
    9  -> Hygiene
    10 -> Other
    _  -> Other


stringToGroceryCategory : String -> GroceryCategory
stringToGroceryCategory str =
  case str of
    "Dairy"               -> Dairy
    "Meat"                -> Meat
    "Seafood"             -> Seafood
    "Colonial"            -> Colonial
    "Fruit or vegetable"  -> FruitOrVegetable
    "Snacks"              -> Snacks
    "Drinks"              -> Drinks
    "Frozen"              -> Frozen
    "Charcuterie"         -> Charcuterie
    "Hygiene"             -> Hygiene
    _                     -> Other


groceryCategoryToString : GroceryCategory -> String
groceryCategoryToString cat =
  case cat of
    Dairy            -> "Dairy"               
    Meat             -> "Meat"                
    Seafood          -> "Seafood"             
    Colonial         -> "Colonial"            
    FruitOrVegetable -> "Fruit or vegetable"  
    Snacks           -> "Snacks"              
    Drinks           -> "Drinks"              
    Frozen           -> "Frozen"              
    Charcuterie      -> "Charcuterie"         
    Hygiene          -> "Hygiene"             
    Other            -> "Other"


groceryCategoryToInt : GroceryCategory -> Int
groceryCategoryToInt cat =
  case cat of
    Dairy            -> 0
    Meat             -> 1
    Seafood          -> 2
    Colonial         -> 3
    FruitOrVegetable -> 4
    Snacks           -> 5
    Drinks           -> 6
    Frozen           -> 7
    Charcuterie      -> 8
    Hygiene          -> 9
    Other            -> 10


intToPriority : Int -> Priority
intToPriority num =
  case num of
    0 -> Low
    1 -> Medium
    2 -> High
    _ -> Low


priorityToInt : Priority -> Int
priorityToInt p =
  case p of
    Low -> 0
    Medium -> 1
    High -> 2

