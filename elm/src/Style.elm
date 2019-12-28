module Style exposing (..)

import Css
import Css exposing (..)

headerHeight =
  px 80

sideBarColor =
  rgb 40 40 40

sideBarColorHover =
  rgb 60 60 60

sideBarColorSelected =
  rgb 100 100 100

sidebarLinkHeight =
  px 80

sidebarWidth =
  px 200

textStyle : Style
textStyle =
  Css.batch
    [ fontFamilies ["Arial", "Helvetica", "sans-serif"]
    ]


titleStyle : Style
titleStyle =
  Css.batch
    [ fontFamilies ["Arial", "Helvetica", "sans-serif"]
    , color (rgb 255 255 255)
    ]

headerStyle : Style
headerStyle =
  Css.batch
    [ marginLeft (px 200)
    , textAlign center
    , height headerHeight
    , property "width" "-moz-available"
    , position fixed
    , top (px 0)
    , left (px 0)
    , backgroundColor sideBarColor
    ]

sideBarStyle : Style
sideBarStyle =
  Css.batch
    [ height (pct 100)
    , width sidebarWidth
    , position fixed
    , top (px 0)
    , left (px 0)
    , overflowX hidden
    , paddingTop headerHeight
    , backgroundColor sideBarColor
    ]

sideBarLinkStyle : Color -> Style
sideBarLinkStyle linkColor =
  let
    hoverColor =
      if linkColor == sideBarColorSelected then
        sideBarColorSelected
      else
        sideBarColorHover
  in
    Css.batch
      [ padding (px 8)
      , fontFamilies ["Arial", "Helvetica", "sans-serif"]
      , textDecoration none
      , fontSize (px 25)
      , color (rgb 255 255 255)
      , backgroundColor linkColor
      , display block
      , hover [ backgroundColor hoverColor ]
      ]

contentContainerStyle : Style
contentContainerStyle =
  Css.batch
    [ height (pct 100)
    , marginLeft sidebarWidth
    , marginTop headerHeight
    , padding (px 10)
    ]
