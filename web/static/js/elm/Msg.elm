module Msg exposing (..)

import Http
import SiteMap exposing (PageResults)
import Task

type Msg
  = NoOp
  | UpdateFormUrl String
  | StartScanning
  | PageFetched PageResults
  | PageFailed Http.Error
  | StartAnalyzing
  | DoAnalyzing


buildCmd : Msg -> Cmd Msg
buildCmd msg = Task.perform identity identity (Task.succeed msg)
