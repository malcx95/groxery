module Elements.Modal exposing (newGroceryModal)

import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)

import Css
import Css exposing (..)
import Style
import GroceryModel
import Dropdown

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
      input [ type_ "text"
            , placeholder "Name"
            , onInput GroxeryMsg.GroceryNameInputChanged ] []

    dropdownOptions = 
      Dropdown.Options
        (List.map
         (\x -> Dropdown.Item x x True)
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
         ])
        Nothing
        GroxeryMsg.GroceryDropdownSelected

    category =
      Dropdown.dropdown dropdownOptions [] ( Just "Dairy" )

    submitButton =
      button [ onClick GroxeryMsg.CreateGrocery ]

    body =
      div []
        [ name
        , Html.Styled.fromUnstyled category
        ]
  in
    modalWithTitle "New grocery" body (text "footer")
