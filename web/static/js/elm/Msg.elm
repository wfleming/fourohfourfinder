module Msg exposing (..)

import Http
import SiteMap exposing (PageResults)

type Msg
  = NoOp
  | UpdateFormUrl String
  | StartScanning
  | PageFetched PageResults
  | PageFailed Http.Error
