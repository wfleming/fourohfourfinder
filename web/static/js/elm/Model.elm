port module Model exposing (..)

import FormModel exposing (..)
import SiteMap exposing (..)

type alias Status =
  { message : Maybe String
  , messageClass : Maybe String
  }

type alias Model =
  { status : Status
  , form : FormModel
  , siteMap : SiteMap
  }


emptyModel : Model
emptyModel =
  { status = { message = Nothing, messageClass = Nothing }
  , form = { url = "" }
  , siteMap = { pendingUrls = [], pageResults = [] }
  }
