module SiteMap exposing (..)

import URI
import String


type alias SiteMap =
  { startUrl: String
  , pendingUrls: List String
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


urlOnSite : SiteMap -> String -> Bool
urlOnSite sitemap url =
  let
    siteUrl = URI.parse sitemap.startUrl
    targetUrl = URI.parse url
  in
    siteUrl.hostname == targetUrl.hostname

siteUrls : SiteMap -> List String
siteUrls sitemap = sitemap.pendingUrls ++ (List.map (\p -> p.url) sitemap.pageResults)


pageHrefs : PageResults -> List String
pageHrefs page = case page.outgoingLinks of
  Just linkList -> List.map (\l -> l.href) linkList
  Nothing -> []

dropHash : String -> String
dropHash s =
  let
    origURI = URI.parse s
    uri = { origURI
          | hash = Nothing }
  in
    URI.toString uri


normalizeUrl : String -> String
normalizeUrl s =
  if String.startsWith "http" s then
    s
  else
    "http://" ++ s
{-
   When part of the model I get a compile error about "Your `main` is demanding an unsupported type as a flag."
   Kind of a bummer if you can't use a real type in an app model
   type LinkStatus
     = Unknown
     | Reachable
     | Unreachable Int -- integer should be a status code
     | MissingAnchor
-}
