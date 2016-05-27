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
        newModel = { model
                   | isScanning = True
                   , siteMap = [ { url = model.form.url, outgoingLinks = [] } ]
                   }
        task = Task.perform Msg.PageFetched Msg.PageFailed (Http.getString  model.form.url)
      in
        newModel ! [task]

    Msg.PageFetched pageSource ->
      model ! []

    Msg.PageFailed Http.Error ->
      model ! []


appView : Model -> Html Msg.Msg
appView model =
  div [ class "container" ]
    ( [ Layout.header
       , Layout.form model
      ] ++
      Layout.results model ++
      [ Layout.footer ]
    )
