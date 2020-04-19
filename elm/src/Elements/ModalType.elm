module Elements.ModalType exposing (..)

import Bootstrap.Modal as Modal

type ModalType = NewGrocery

type alias VisibleModals =
  { newGroceryVisibility: Modal.Visibility
  }

allInvisible : VisibleModals
allInvisible =
  VisibleModals Modal.hidden

setVisible : VisibleModals -> ModalType -> VisibleModals
setVisible visibleModals modalType =
  case modalType of
    NewGrocery ->
      { visibleModals | newGroceryVisibility = Modal.shown }
