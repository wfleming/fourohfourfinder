module Layout exposing (..)

{-| Layout templates for the app.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Lazy exposing (lazy)


header : Html a
header =
    Html.header [ class "row" ]
        [ div [ class "twelve columns" ]
            [ h1 [] [ text "404finder" ]
            ]
        ]


form : Html a
form =
    div [ class "row" ]
        [ div [class "twelve columns"]
            [ label
                [ for "start-url"
                , class "u-inline margin-h"
                ]
                [ text "Start URL:" ]
            , input
                [ id "start-url"
                , class "margin-h"
                , placeholder "https://lost.found"
                , name "startUrl"
                , autofocus True
                , attribute "type" "url"
                ]
                []
            , button [ class "button-primary margin-h" ] [ text "Scan" ]
            ]
        ]


footer : Html a
footer =
    Html.footer [ class "row" ]
        [ p []
            [ text "By "
            , a [ href "https://github.com/wfleming" ] [ text "Will Fleming" ]
            ]
        ]
