module Api exposing (pageFetch)

import Json.Decode as Json
import Json.Decode exposing ((:=))
import Http
import Msg
import Task
import SiteMap exposing (LinkDesc, PageResults)

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
    (Json.maybe ("error" := Json.string))
    (Json.maybe ("http_status" := Json.int))
    (Json.maybe ("outgoing_hrefs" := Json.list linkDescDecoder))
    (Json.maybe ("ids" := Json.list Json.string))

linkDescDecoder : Json.Decoder LinkDesc
linkDescDecoder =
  Json.object2 LinkDesc
    ("href" := Json.string)
    ("text" := Json.string)


pageFetchBody : String -> Http.Body
pageFetchBody url =
  Http.multipart [
    Http.stringData "url" url
  ]

pageFetchUrl : String
pageFetchUrl = "/api/page/fetch"


