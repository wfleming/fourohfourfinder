module SiteAnalysis exposing (..)

import URI
import SiteMap exposing (..)
import String


type alias SiteAnalysis = List PageAnalysis

type alias PageAnalysis =
  { url: String
  , goodLinksCount: Int
  , badLinks: List LinkError
  }

type alias LinkError =
  { link: LinkDesc
  , reason: String
  }

build: SiteMap -> SiteAnalysis
build sitemap =
  let
    sitePageRes = List.filter
                    (\p -> p.success && urlOnSite sitemap p.url)
                    sitemap.pageResults
  in
    List.map (buildPageAnalysis sitemap) sitePageRes

buildPageAnalysis : SiteMap -> PageResults -> PageAnalysis
buildPageAnalysis sitemap page =
  let
    (goodLinks, badLinks) = List.partition
                              (isLinkGood sitemap)
                              <| Maybe.withDefault [] page.outgoingLinks
    badLinkErrs = List.map (buildLinkErr sitemap) badLinks
  in
    { url = page.url
    , goodLinksCount = List.length goodLinks
    , badLinks = badLinkErrs
    }

buildLinkErr : SiteMap -> LinkDesc -> LinkError
buildLinkErr sitemap link =
  let
    reason =
      case (findPage sitemap link.href) of
        Nothing -> "it doesn't look like we fetched that page? This might be our bug."
        Just page ->
          case page.httpStatus of
            Nothing -> "an error occurred: " ++ Maybe.withDefault "UNKNOWN" page.error
            Just status ->
              if status >= 200 && status <= 400 then
                case (URI.parse link.href).hash of
                  Nothing -> "This shouldn't happen."
                  Just id -> "the page didn't contain the anchor " ++ id
              else
                "the page failed with status: " ++ toString status
  in
    { link = link
    , reason = reason
    }

isLinkGood : SiteMap -> LinkDesc -> Bool
isLinkGood sitemap link =
  case (findPage sitemap link.href) of
    Nothing -> False
    Just page ->
      if page.success == False then
        False
      else
        case (URI.parse link.href).hash of
          Nothing -> True
          Just id ->
              -- parsed id has # in front, so we need to drop that
              List.member (String.dropLeft 1 id) <| Maybe.withDefault [] page.ids

findPage : SiteMap -> String -> Maybe PageResults
findPage sitemap url = List.head <| List.filter (\p -> p.url == dropHash url) sitemap.pageResults
