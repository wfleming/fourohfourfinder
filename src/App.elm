port module App exposing (..)

{-| A web app for finding broken links.
-}

import Model exposing (..)
import Msg
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Http
import Layout
import String
import Task


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
        url = Debug.log ("going to scan " ++ model.form.url) model.form.url
        newModel = { model
                   | status = { message = Just "Scanning..."
                              , messageClass = Nothing }
                   , siteMap = [ { url = url, outgoingLinks = [] } ]
                   }
        task = Task.perform Msg.PageFailed Msg.PageFetched (Http.getString url)
      in
        newModel ! [task]

    Msg.PageFetched pageSource ->
      model ! []

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
      Layout.results model ++
      [ Layout.footer ]
    )
