module Api exposing (pageFetch)

import Json.Decode as Json
import Json.Decode exposing ((:=))
import Http
import Msg
import Task
import SiteMap exposing (LinkDesc, PageResults)
import String

pageFetch : String -> Cmd Msg.Msg
pageFetch url =
  Task.perform Msg.PageFailed Msg.PageFetched (pageFetchReq url)

pageFetchReq : String -> Task.Task Http.Error PageResults
pageFetchReq url =  Http.post pageInfoDecoder pageFetchUrl (pageFetchBody url)

pageInfoDecoder : Json.Decoder PageResults
pageInfoDecoder =
  Json.object6 PageResults
    ("url" := Json.string)
    ("success" := Json.bool)
    ("error" := Json.maybe Json.string)
    ("http_status" := Json.maybe Json.int)
    ("outgoingLinks" := Json.maybe (Json.list linkDescDecoder))
    ("ids" := Json.maybe (Json.list Json.string))

linkDescDecoder : Json.Decoder LinkDesc
linkDescDecoder =
  Json.object2 LinkDesc
    ("href" := Json.string)
    ("text" := Json.string)


pageFetchBody : String -> Http.Body
pageFetchBody url =
  Http.multipart [
    Http.stringData "url" (normalizeUrl url)
  ]

pageFetchUrl : String
pageFetchUrl = "/api/page/fetch"


normalizeUrl : String -> String
normalizeUrl s =
  if String.startsWith "http" s then
    s
  else
    "http://" ++ s
