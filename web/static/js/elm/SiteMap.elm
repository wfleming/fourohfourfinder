module SiteMap exposing (..)

import String


type alias SiteMap =
  List PageInfo


type alias PageInfo =
  { url : String
  , outgoingLinks : List LinkInfo
  }


type alias LinkInfo =
  { target : String
  , reachable : Bool
  }



{-
   When part of the model I get a compile error about "Your `main` is demanding an unsupported type as a flag."
   Kind of a bummer if you can't use a real type in an app model
   type LinkStatus
     = Unknown
     | Reachable
     | Unreachable Int -- integer should be a status code
     | MissingAnchor
-}
