module Msg exposing (..)

import Http

type Msg
  = NoOp
  | UpdateFormUrl String
  | StartScanning
  | PageFetched String
  | PageFailed Http.Error
