module Types exposing (..)

import Time exposing (Time)
import Http


type Route
    = Graph
    | TopLevel
    | NotFound


type Msg
    = Load
    | Show
    | NewUrl String
    | UpdateQuery String
    | Response (ApiData Data)


type alias Model =
    { data : ApiData Data
    , query : String
    , route : Route
    }


type alias Data =
    { resultType : MetricType
    , result : List Result
    }


type alias Result =
    { metric : List ( String, String )
    , value : List Value
    }


type alias Value =
    { x : Float
    , y : Maybe Float
    }


type alias Metric =
    { name : String
    , labels : List Label
    }


type alias Label =
    { name : String
    , value : String
    }


type MetricType
    = Vector
    | Matrix


type alias ApiData a =
    ApiResponse Http.Error a


type ApiResponse e a
    = Loading
    | Failure e
    | Success a
