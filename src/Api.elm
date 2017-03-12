module Api exposing (query)

import Types exposing (Msg)


query : String -> Cmd Msg
query q =
    Cmd.none
