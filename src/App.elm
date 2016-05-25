port module App exposing (..)

{-| A web app for finding broken links.
-}

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


type alias Model =
    { stuff : List String }


emptyModel : Model
emptyModel =
    { stuff = [ "thing" ] }


appInit : Maybe Model -> ( Model, Cmd Msg )
appInit _ =
    emptyModel ! []


type Msg
    = NoOp


appUpdate : Msg -> Model -> ( Model, Cmd Msg )
appUpdate _ model =
    model ! []


appView : Model -> Html Msg
appView _ =
    div [ class "container" ]
        [ Layout.header
        , Layout.form
        , Layout.footer
        ]
