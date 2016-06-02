module Layout exposing (..)

{-| Layout templates for the app.
-}

import Model exposing (..)
import Msg exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
--import Html.Lazy exposing (lazy)
import Json.Decode as Json
import SiteAnalysis exposing (..)


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
          [ h3 [] [ text "Fetched URLs" ]
          , ul []
              (List.map (\pr -> li [] [ text pr.url ]) model.siteMap.pageResults)
          ]
  in
    if List.length pendingUrlsHtml > 0 || List.length fetchedUrlsHtml > 0 then
      [ div [ class "row" ]
          [ div [ class "twelve columns" ]
              (pendingUrlsHtml ++ fetchedUrlsHtml)
          ]
      ]
    else
      []


analysisResults : Model -> List (Html a)
analysisResults model =
  let
    goodLinksCount = List.sum <| List.map (\pa -> pa.goodLinksCount) model.siteAnalysis
    badLinksCount = List.sum <| List.map (\pa -> List.length pa.badLinks) model.siteAnalysis
    pagesCount = List.length model.siteAnalysis
    resultsHtml = List.map pageAnalysis model.siteAnalysis
  in
    if List.length resultsHtml > 0 then
      ( div [ class "row" ]
          [ div [ class "twelve columns" ]
              [ h3 [] [ text "Site Results" ]
              , p []
                  [ text "Found "
                  , span [ class "t-red" ] [ text <| (toString badLinksCount) ++ " broken links" ]
                  , text " and "
                  , span [ class "t-green" ] [ text <| (toString goodLinksCount) ++ " good links" ]
                  , text <| " on " ++ (toString pagesCount) ++ " pages."
                  ]
              ]
          ]
      ) :: resultsHtml
    else
      []

pageAnalysis : PageAnalysis -> Html b
pageAnalysis page =
  let
    badLinkLis =
      List.map
        (\bl -> li [ class "t-red" ]
                  [ code [] [ text bl.link.text ]
                  , text " (linking to "
                  , code [] [ text bl.link.href ]
                  , text <| ") failed because " ++ bl.reason
                  ]
        )
        page.badLinks
  in
    div [ class "row" ]
      [ div [ class "twelve columns" ]
          [ h4 [] [ code [] [ text page.url ] ]
          , ul []
              (li [ class "t-green" ]
                  [ text <| (toString page.goodLinksCount) ++ " perfectly good links." ]
              :: badLinkLis)
          ]
      ]


footer : Html a
footer =
  Html.footer [ class "row" ]
    [
      a [ href "https://github.com/wfleming/fourohfourfinder" ]
        [ text "Source on GitHub" ]
    ]
