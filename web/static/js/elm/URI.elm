module URI exposing (..)

import Native.URI

type alias URI =
  { orig: String
  , protocol: String
  , host: String -- includes port, if any
  , hostname: String -- never includes port
  , path:  String
  , query: Maybe String
  , hash: Maybe String
  }


parse : String -> URI
parse = Native.URI.parse

toString : URI -> String
toString uri =
  let
    base = uri.protocol ++ "//" ++ uri.host
    query = Maybe.withDefault "" uri.query
    hash = Maybe.withDefault "" uri.hash
  in
    base ++ uri.path ++ query ++ hash

