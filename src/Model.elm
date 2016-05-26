port module Model exposing (..)

import FormModel exposing (..)
import SiteMap exposing (..)


type alias Model =
  { isScanning : Bool
  , form : FormModel
  , siteMap : SiteMap
  }


emptyModel : Model
emptyModel =
  { isScanning = False
  , form = { url = "" }
  , siteMap = []
  }
