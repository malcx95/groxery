module Elements.NewGroceryModal exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg, ModalResult)

import Bootstrap.Modal as Modal
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Form as Form
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select


groceryCategoryItems : List (Select.Item Msg)
groceryCategoryItems =
  List.map (\x -> Select.item [ value x ] [ text x ])
    [ "Dairy"
    , "Meat"
    , "Seafood"
    , "Colonial"
    , "Fruit or vegetable"
    , "Snacks"
    , "Drinks"
    , "Frozen"
    , "Charcuterie"
    , "Hygiene"
    , "Other"
    ]


newGroceryForm : Model -> Html Msg
newGroceryForm groceryModel =
  Form.form []
  [ Input.text
    [ Input.id "new-grocery-name"
    , Input.attrs [ class "form-input" ]
    , Input.value groceryModel.newGrocery.name
    , Input.small
    , Input.placeholder "Name"
    , Input.onInput GroxeryMsg.GroceryNameInputChanged
    ]
  , Select.select
    [ Select.id "new-grocery-category"
    , Select.attrs [ class "form-input" ]
    , Select.onChange GroxeryMsg.GroceryDropdownSelected
    ]
    groceryCategoryItems
  , Checkbox.checkbox
    [ Checkbox.id "new-grocery-by-weight"
    , Checkbox.attrs [ class "form-input" ]
    , Checkbox.checked groceryModel.newGrocery.byWeight
    , Checkbox.onCheck GroxeryMsg.GroceryByWeightChanged
    ] "By weight"
  ]


newGroceryModal : Model -> Html Msg
newGroceryModal groceryModel =
  let
    modalResult =
      case groceryModel.currentGroceryId of
        Nothing ->
          GroxeryMsg.CreateNewGrocery
        Just id ->
          GroxeryMsg.UpdateGrocery id

    titleText =
      case groceryModel.currentGroceryId of
        Nothing ->
          "New Grocery"
        Just _ ->
          "Edit Grocery"
  in
    Modal.config (GroxeryMsg.CloseModal Nothing)
      |> Modal.small
      |> Modal.h5 [] [ text titleText ]
      |> Modal.body []
        [ newGroceryForm groceryModel
        ]
      |> Modal.footer []
        [ Button.button
          [ Button.outlinePrimary
          , Button.attrs
            [ onClick 
              (GroxeryMsg.CloseModal (Just modalResult)) ]
          ]
          [ text "Save" ]
        ]
      |> Modal.view groceryModel.visibleModals.newGroceryVisibility

