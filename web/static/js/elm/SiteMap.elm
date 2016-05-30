module SiteMap exposing (..)


type alias SiteMap =
  { pendingUrls: List String
  , pageResults: List PageResults
  }


type alias PageResults =
  { url: String
  , success: Bool
  , error: Maybe String
  , httpStatus: Maybe Int
  , outgoingLinks: Maybe (List LinkDesc)
  , ids: Maybe (List String)
  }


type alias LinkDesc =
  { href: String
  , text: String
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
