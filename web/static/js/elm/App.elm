port module App exposing (..)

{-| A web app for finding broken links.
-}

import Api
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Http
import Layout
import Model exposing (..)
import Msg
import SiteMap exposing ( normalizeUrl, pageHrefs, siteUrls )


main : Program Never
main =
  App.program
  { init = appInit
  , view = appView
  , update = appUpdate
  , subscriptions = \_ -> Sub.none
  }


appInit : ( Model, Cmd Msg.Msg )
appInit = Model.emptyModel ! []


appUpdate : Msg.Msg -> Model -> ( Model, Cmd Msg.Msg )
appUpdate msg model =
  case msg of
    Msg.NoOp ->
      model ! []

    Msg.UpdateFormUrl url ->
      { model
      | form = { url = url } -- NOTE: elm parser barfs on { model.form | url = url }
      } ! []

    Msg.StartScanning ->
      let
        normalizedUrl = normalizeUrl model.form.url
        newModel = { model
                   | status = { message = Just "Scanning..."
                              , messageClass = Nothing }
                   , siteMap =
                       { startUrl = normalizedUrl
                       , pendingUrls = [ normalizedUrl ]
                       , pageResults = []
                       }
                   }
        task = Api.pageFetch normalizedUrl
      in
        newModel ! [task]

    Msg.PageFetched pageRes ->
      let
        curPendingUrls = model.siteMap.pendingUrls
        curPageResults = model.siteMap.pageResults
        allUrls = Debug.log "allUrls" <| siteUrls model.siteMap
        _ = Debug.log "pageRes" <| pageRes
        newUrls = Debug.log "newUrls" <| List.filter (\href -> not (List.member href allUrls)) (pageHrefs pageRes)
        --TODO: also filter these by domain: don't crawl the whole web!
        newPendingUrls =
          (List.filter (\u -> u /= pageRes.url) curPendingUrls) ++
          newUrls
        newModel = { model
                   | siteMap =
                     { startUrl = model.siteMap.startUrl
                     , pendingUrls = newPendingUrls
                     , pageResults = curPageResults ++ [ pageRes ]
                     }
                   }
        nextTask =
          case List.head newPendingUrls of
            Just url -> Api.pageFetch url
            Nothing -> Cmd.none --TODO: analyze all the collected results for broken links
      in
        newModel ! [nextTask]

    Msg.PageFailed err ->
      let
        errMsg = case err of
          Http.Timeout -> "Fetch timed out"
          Http.NetworkError -> "Network error occurred"
          Http.UnexpectedPayload str -> "Unexpected Payload: " ++ str
          Http.BadResponse code str -> "Bad Response: " ++ (toString code) ++ " (" ++ str ++ ")"

        newModel = { model
                   | status = { message = Just errMsg
                              , messageClass = Just "error" }
                   }
      in
        newModel ! []

appView : Model -> Html Msg.Msg
appView model =
  div [ class "container" ]
    ( [ Layout.header
       , Layout.form model
      ] ++
      Layout.progressList model ++
      [ Layout.footer ]
    )
