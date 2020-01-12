module Elements.Modal exposing (modal)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import Css
import Css exposing (..)

import GroxeryMsg exposing (Msg)

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
    , backgroundColor (hex "#5cb85c")
    , color (hex "#ffffff")
    ]

footerStyle : Style
footerStyle =
  Css.batch
    [ padding2 (px 2) (px 16)
    , backgroundColor (hex "#5cb85c")
    , color (hex "#ffffff")
    ]

modal : Html Msg -> Html Msg -> Html Msg -> Html Msg
modal header body footer =
  div []
    [ div [ css [ contentStyle ] ]
        [ div [ css [ headerStyle ] ] [ header ]
        , div [ css [ bodyStyle ] ] [ body ]
        , div [ css [ footerStyle ] ] [ footer ]
        ]
    ]
