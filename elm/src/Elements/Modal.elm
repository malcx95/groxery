module Elements.Modal exposing (newGroceryModal, modalContainerClass)

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

contentStyle : Int -> Style
contentStyle width =
  Css.batch
    [ backgroundColor (hex "#fefefe")
    , margin2 (pct 15) auto
    , padding (px 20)
    , border3 (px 1) solid (hex "#080808")
    , maxWidth (pct <| toFloat <| width)
    , minWidth (px 100)
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

modalContainerClass : String
modalContainerClass = "modal-container"

xButton : Html Msg
xButton =
  div [ css [ xButtonStyle ], onClick <| GroxeryMsg.CloseModal <| Nothing ] [ text "x" ]

generalModal : Html Msg -> Html Msg -> Html Msg -> Int -> Html Msg
generalModal header body footer width =
  div [ class modalContainerClass, css [ modalStyle ] ]
    [ div [ css [ contentStyle width ] ]

        [ xButton
        , div [ css [ headerStyle ] ] [ header, hr [ css [ hrStyle ] ] []]
        , div [ css [ bodyStyle ] ] [ body ]
        , div [ css [ footerStyle ] ] [ footer ]
        ]
    ]


modalWithTitle : String -> Html Msg -> Html Msg -> Int -> Html Msg
modalWithTitle title body footer width =
  let
    header = h2 [ css [ Style.textStyle ] ] [ text title ]
  in
    generalModal header body footer width


textInputField : String -> (String -> GroxeryMsg.Msg) -> Html Msg
textInputField fieldText msgOnInput =
  div []
    [ div [ css [ Style.labelStyle ] ] [ text fieldText ]
    , input [ type_ "text"
            , placeholder fieldText
            , onInput msgOnInput ] []
    ]


inputField : String -> (String -> GroxeryMsg.Msg) -> Html Msg
inputField fieldText msgOnInput =
  div []
    [ div [ css [ Style.labelStyle ] ] [ text fieldText ]
    , input [ type_ "text"
            , placeholder fieldText
            , onInput msgOnInput ] []
    ]


newGroceryModal : GroceryModel.Model -> Html Msg
newGroceryModal model =
  let
    name = textInputField "Name" GroxeryMsg.GroceryNameInputChanged

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
      div []
        [ Html.Styled.fromUnstyled ( Dropdown.dropdown dropdownOptions [] ( Just "Dairy" ) )
        ]

    submitButton =
      div []
        [ button [ onClick GroxeryMsg.CreateGrocery ] [ text "Create" ]
        ]

    body =
      div []
        [ name
        , category
        ]
    footer =
      div []
        [ submitButton
        ]
  in
    modalWithTitle "New grocery" body footer 50

