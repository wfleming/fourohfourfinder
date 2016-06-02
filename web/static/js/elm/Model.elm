port module Model exposing (..)

import FormModel exposing (..)
import SiteAnalysis exposing (..)
import SiteMap exposing (..)

type alias Status =
  { message : Maybe String
  , messageClass : Maybe String
  }

type alias Model =
  { status : Status
  , form : FormModel
  , siteAnalysis: SiteAnalysis
  , siteMap : SiteMap
  }

emptyStatus : Status
emptyStatus = { message = Nothing, messageClass = Nothing }

emptySiteMap : SiteMap
emptySiteMap = { startUrl = "", pendingUrls = [], pageResults = [] }

emptyModel : Model
emptyModel =
  { status = emptyStatus
  , form = { url = "" }
  , siteAnalysis = []
  , siteMap = emptySiteMap
  }
