module Api exposing (query)

import Types exposing (Msg)
import Types exposing (ApiResponse(..), ApiData)
import Http
import Time
import Decoders exposing (queryRange)
import Json.Decode as Json


query : String -> Time.Time -> Time.Time -> Cmd Msg
query q start end =
    let
        url =
            String.join "/" [ baseUrl, "query_range" ]

        qs =
            String.join "&"
                [ toQueryStringPair ( "query", q )
                , toQueryStringPair ( "start", toString <| round <| Time.inMilliseconds start )
                , toQueryStringPair ( "end", toString <| round <| Time.inMilliseconds end )
                , toQueryStringPair ( "step", "15" )
                ]

        fullUrl =
            url ++ "?" ++ qs
    in
        -- query:job:promoted_ad_event_total:rate2m:sum
        -- start:1489516551.259
        -- end:1489520151.259
        -- step:14
        send (get fullUrl queryRange)
            |> Cmd.map (Types.Response)


toQueryStringPair : ( String, String ) -> String
toQueryStringPair ( key, value ) =
    key ++ "=" ++ (Http.encodeUri value)


fromResult : Result e a -> ApiResponse e a
fromResult result =
    case result of
        Err e ->
            Failure e

        Ok x ->
            Success x


send : Http.Request a -> Cmd (ApiData a)
send =
    Http.send fromResult


get : String -> Json.Decoder a -> Http.Request a
get url decoder =
    request "GET" [] url Http.emptyBody decoder


post : String -> Http.Body -> Json.Decoder a -> Http.Request a
post url body decoder =
    request "POST" [] url body decoder


delete : String -> Json.Decoder a -> Http.Request a
delete url decoder =
    request "DELETE" [] url Http.emptyBody decoder


request : String -> List Http.Header -> String -> Http.Body -> Json.Decoder a -> Http.Request a
request method headers url body decoder =
    Http.request
        { method = method
        , headers = headers
        , url = url
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Just defaultTimeout
        , withCredentials = False
        }


baseUrl : String
baseUrl =
    "derp"


defaultTimeout : Time.Time
defaultTimeout =
    1000 * Time.millisecond



-- "http://localhost:9093/api/v1"
