module Layout exposing (..)

{-| Layout templates for the app.
-}

import Model exposing (..)
import Msg exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy exposing (lazy)
import Json.Decode as Json
import Set
import SiteMap exposing (..)


header : Html a
header =
  Html.header [ class "row" ]
    [ div [ class "twelve columns" ]
      [ h1 [] [ text "404finder" ]
      ]
    ]



-- Helper to generate event helper for enter key press


onEnter : msg -> msg -> Attribute msg
onEnter fail success =
  let
    tagger code =
      if code == 13 then
        success
      else
        fail
  in
    on "keyup" (Json.map tagger keyCode)


form : Model -> Html Msg
form model =
  div [ class "row" ]
    [ div [ class "eight columns" ]
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
        , on "input" (Json.map UpdateFormUrl targetValue)
        , onEnter NoOp StartScanning
        ]
        []
      , button
        [ class "button-primary margin-h"
        , onClick StartScanning
        ]
        [ text "Scan" ]
      ]
    , div [ class "four columns" ]
        (statusContent model.status)
    ]

statusContent : Status -> List (Html Msg)
statusContent status =
  case status.message of
    Just txt ->
      let
        maybeStyle = Maybe.map (\c -> [class c]) status.messageClass
        style = Maybe.withDefault [] maybeStyle
      in
        [ p style [ text txt ] ]
    Nothing ->
      []

progressList : Model -> List (Html f)
progressList  model =
  let
    pendingUrlsHtml =
      case List.length model.siteMap.pendingUrls of
        0 -> []
        _ ->
          [ h3 [] [ text "Pending URLs" ]
          , ul []
              (List.map (\url -> li [] [ text url ]) model.siteMap.pendingUrls)
          ]
    fetchedUrlsHtml =
      case List.length model.siteMap.pageResults of
        0 -> []
        _ ->
          [ h3 [] [ text "Fetched URls" ]
          , ul []
              (List.map (\pr -> li [] [ text pr.url ]) model.siteMap.pageResults)
          ]
  in
    [ div [ class "row" ]
        [ div [ class "twelve columns" ]
            (pendingUrlsHtml ++ fetchedUrlsHtml)
        ]
    ]


results : Model -> List (Html b)
results model = List.map pageResults model.siteMap.pageResults

pageResults : PageResults -> Html b
pageResults page =
  div [ class "row" ]
    [ div [ class "twelve columns" ]
        [ h3 [] [ text page.url ]
        , p [] [ text "Put details here" ]
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
