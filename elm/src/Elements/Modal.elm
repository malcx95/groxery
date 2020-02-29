module Elements.Modal exposing (newGroceryModal)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import Css
import Css exposing (..)
import Style
import GroceryModel

import GroxeryMsg exposing (Msg)

modalStyle : Style
modalStyle =
  Css.batch
    [ position fixed
    , zIndex (int 1)
    , left (px 0)
    , right (px 0)
    , top (px 0)
    , Css.width (pct 100)
    , Css.height (pct 100)
    , overflow auto
    , backgroundColor (rgb 0 0 0)
    , backgroundColor (rgba 0 0 0 0.4)
    ]

contentStyle : Style
contentStyle =
  Css.batch
    [ backgroundColor (hex "#fefefe")
    , margin2 (pct 15) auto
    , padding (px 20)
    , border3 (px 1) solid (hex "#080808")
    , Css.width (pct 80)
    , boxShadow5 (px 0) (px 4) (px 8) (px 0) (rgba 0 0 0 0.2)
    ]

bodyStyle : Style
bodyStyle =
  Css.batch
    [ padding2 (px 2) (px 16)
    ]

headerStyle : Style
headerStyle =
  Css.batch
    [ padding2 (px 2) (px 16)
    ]

footerStyle : Style
footerStyle =
  Css.batch
    [ padding2 (px 2) (px 16)
    ]

xButtonStyle : Style
xButtonStyle =
  Css.batch
    [ fontFamilies ["Arial", "Helvetica", "sans-serif"]
    , fontSize (px 30)
    , padding (px 10)
    , float right
    , cursor pointer
    ]

hrStyle : Style
hrStyle =
  Css.batch
    [ border3 (px 1) solid (hex "#ccc")
    ]

xButton : Html Msg
xButton =
  div [ css [ xButtonStyle ], onClick <| GroxeryMsg.CloseModal <| Nothing ] [ text "x" ]

generalModal : Html Msg -> Html Msg -> Html Msg -> Html Msg
generalModal header body footer =
  div [ css [ modalStyle ] ]
    [ div [ css [ contentStyle ] ]
        [ xButton
        , div [ css [ headerStyle ] ] [ header, hr [ css [ hrStyle ] ] []]
        , div [ css [ bodyStyle ] ] [ body ]
        , div [ css [ footerStyle ] ] [ footer ]
        ]
    ]


modalWithTitle : String -> Html Msg -> Html Msg -> Html Msg
modalWithTitle title body footer =
  let
    header = h2 [ css [ Style.textStyle ] ] [ text title ]
  in
    generalModal header body footer


newGroceryModal : GroceryModel.Model -> Html Msg
newGroceryModal model =
  let
    name =
      input [ type_ "text", placeholder "Name", value model.newGrocery.name ]
    category =
      select []
        [ option [ value "0"  ] [ text "Dairy" ]
        , option [ value "1"  ] [ text "Meat" ]
        , option [ value "2"  ] [ text "Seafood" ]
        , option [ value "3"  ] [ text "Colonial" ]
        , option [ value "4"  ] [ text "FruitOrVegetable" ]
        , option [ value "5"  ] [ text "Snacks" ]
        , option [ value "6"  ] [ text "Drinks" ]
        , option [ value "7"  ] [ text "Frozen" ]
        , option [ value "8"  ] [ text "Charcuterie" ]
        , option [ value "9"  ] [ text "Hygiene" ]
        , option [ value "10" ] [ text "Other" ]
        ]
    body =
      div []
        [
        ]
  in
    modalWithTitle "New grocery" (text "body") (text "footer")
