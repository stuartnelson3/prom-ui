module Decoders exposing (queryRange)

import Types exposing (Data, MetricType(..), Result, Value)
import Json.Decode exposing (..)


queryRange : Decoder Data
queryRange =
    map2 Data
        (at [ "data", "resultType" ] metricType)
        (at [ "data", "result" ] (list result))


metricType : Decoder MetricType
metricType =
    string
        |> andThen
            (\x ->
                case x of
                    "matrix" ->
                        succeed Matrix

                    "vector" ->
                        succeed Vector

                    mt ->
                        fail <|
                            "Unrecognized type: "
                                ++ mt
            )


result : Decoder Types.Result
result =
    map2 Types.Result
        (at [ "metric" ] (keyValuePairs string))
        (at [ "values" ] (list value))


value : Decoder Types.Value
value =
    map2 Types.Value
        (index 0 float)
        (index 1 string
            |> andThen
                (\x ->
                    succeed <| Result.toMaybe <| String.toFloat x
                )
        )
