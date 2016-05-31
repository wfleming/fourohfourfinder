module URI exposing (..)

import Native.URI

type alias URI =
  { orig: String
  , protocol: String
  , hostname: String
  , hostPort: Int
  , path: String
  , query: String
  , hash: String
  }


parse: String -> URI
parse = Native.URI.parse
