module Elements.NewGroceryListEntryModal exposing ( newGroceryListEntryModal )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg, ModalResult)

import Bootstrap.Modal as Modal
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select

import Elements.SearchableInput exposing ( searchableInput )

priorityItems : List (Select.Item Msg)
priorityItems =
  List.map (\x -> Select.item [ value x ] [ text x ])
    [ "Low"
    , "Medium"
    , "High"
    ]


newGroceryListEntryForm : Model -> Html Msg
newGroceryListEntryForm model =
  Form.form []
  [ Form.group []
    [ Form.label [] [ text "Grocery" ]
    , searchableInput model "groceries-input-box"
    ]
  , Form.group []
    [ Form.label [] [ text "Priority" ]
    , Select.select
      [ Select.attrs [ class "form-input" ]
      , Select.onChange GroxeryMsg.GroceryListEntryPrioritySelected
      ] priorityItems
    ]
  ]
-- TODO gör så att groceryID är en Maybe i den nya list entryn, så vi kan gråa ut/dölja
-- amount-fältet när den inte är vald än

newGroceryListEntryModal : Model -> Html Msg
newGroceryListEntryModal model =
  Modal.config (GroxeryMsg.CloseModal Nothing)
    |> Modal.small
    |> Modal.h5 [] [ text "New Entry" ]
    |> Modal.body []
      [ newGroceryListEntryForm model -- TODO body
      ]
    |> Modal.footer []
      [ Button.button
        [ Button.outlinePrimary
        , Button.attrs
          []
          --[ onClick (GroxeryMsg.CloseModal (Just modalResult)) ]
        ]
        [ text "Save" ]
      ]
    |> Modal.view model.visibleModals.newGroceryListEntryVisibility
