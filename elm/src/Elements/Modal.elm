module Elements.Modal exposing (modal)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import Css
import Css exposing (..)

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

xButton : Html Msg
xButton =
  div [ css [ xButtonStyle ], onClick <| GroxeryMsg.CloseModal <| Nothing ] [ text "x" ]


modal : Html Msg -> Html Msg -> Html Msg -> Html Msg
modal header body footer =
  div [ css [ modalStyle ] ]
    [ div [ css [ contentStyle ] ]
        [ xButton
        , div [ css [ headerStyle ] ] [ header ]
        , div [ css [ bodyStyle ] ] [ body ]
        , div [ css [ footerStyle ] ] [ footer ]
        ]
    ]

