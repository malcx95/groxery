module Style exposing (..)

import Css
import Css exposing (..)


textStyle : Style
textStyle =
  Css.batch
    [ fontFamilies ["Arial", "Helvetica", "sans-serif"]
    ]

