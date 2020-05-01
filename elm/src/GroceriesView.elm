module GroceriesView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import GroceryModel exposing (Model)
import GroxeryMsg exposing (Msg)
import Grocery exposing (groceryCategoryToString)
import Elements.ModalType as ModalType
import Elements.NewGroceryModal as NewGroceryModal

import Bootstrap.Modal as Modal
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Table as Table

view : Model -> Html Msg
view groceryModel =
  div []
    [ Button.button
      [ Button.primary
      , Button.attrs
        [ class "new-grocery-button"
        , onClick (GroxeryMsg.OpenModal ModalType.NewGrocery) ] ]
      [ text "New grocery" ]
    , groceryTable groceryModel
    , NewGroceryModal.newGroceryModal groceryModel
    ]

groceryTable : Model -> Html Msg
groceryTable groceryModel =
  case groceryModel.loadedGroceries of
    Nothing ->
      text "No groceries exist yet!"
    Just groceries ->
      let
        makeRow = \g ->
          let
            byWeightText =
              if g.byWeight then
                "Yes"
              else
                "No"
          in
            Table.tr
              [ Table.rowAttr <| onClick <| ( GroxeryMsg.EditGrocery g ) ]
              [ Table.td [] [ text g.name ]
              , Table.td [] [ text <| groceryCategoryToString <| g.category ]
              , Table.td [] [ text byWeightText ]
              ]

        rows =
          List.map makeRow groceries

        head = Table.simpleThead
          [ Table.th [] [ text "Name" ]
          , Table.th [] [ text "Category" ]
          , Table.th [] [ text "By weight" ]
          ]
      in
        Table.table
          { options = [ Table.hover ]
          , tbody = Table.tbody [] rows
          , thead = head
          }
