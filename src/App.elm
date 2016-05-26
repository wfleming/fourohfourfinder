port module App exposing (..)

{-| A web app for finding broken links.
-}

import Model exposing (..)
import Msg exposing (..)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Layout exposing (..)
import String


main : Program (Maybe Model)
main =
    App.programWithFlags
        { init = appInit
        , view = appView
        , update = appUpdate
        , subscriptions = \_ -> Sub.none
        }


appInit : Maybe Model -> ( Model, Cmd Msg )
appInit _ =
    emptyModel ! []


appUpdate : Msg -> Model -> ( Model, Cmd Msg )
appUpdate msg model =
    case msg of
        NoOp ->
            model ! []

        UpdateFormUrl url ->
            { model
                | form =
                    { url = url }
                    -- NOTE: elm parser barfs on { model.form | url = url }
            }
                ! []

        StartScanning ->
            -- TODO do stuff
            { model
                | isScanning = True
            }
                ! []


appView : Model -> Html Msg
appView model =
    div [ class "container" ]
        [ Layout.header
        , Layout.form model
        , Layout.footer
        ]
