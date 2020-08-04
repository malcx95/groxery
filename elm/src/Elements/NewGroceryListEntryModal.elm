module Elements.NewGroceryListEntryModal exposing (..)

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


newGroceryListEntryModal : Model -> Html Msg
newGroceryListEntryModal model =
  Modal.config (GroxeryMsg.CloseModal Nothing)
    |> Modal.small
    |> Modal.h5 [] [ text "New Grocery List Entry" ]
    |> Modal.body []
      [ text "wat"-- TODO body
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
