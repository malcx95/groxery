module Elements.ModalType exposing (..)

import Bootstrap.Modal as Modal

type ModalType = NewGrocery
               | NewGroceryListEntry

type alias VisibleModals =
  { newGroceryVisibility: Modal.Visibility
  , newGroceryListEntryVisibility: Modal.Visibility
  }

allInvisible : VisibleModals
allInvisible =
  VisibleModals Modal.hidden Modal.hidden

setVisible : VisibleModals -> ModalType -> VisibleModals
setVisible visibleModals modalType =
  case modalType of
    NewGrocery ->
      { visibleModals | newGroceryVisibility = Modal.shown }
    NewGroceryListEntry ->
      { visibleModals | newGroceryListEntryVisibility = Modal.shown }
