module View exposing (view)

import Types exposing (Model, Msg(..))
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ formInput model.query UpdateQuery
        , a
            [ class "f6 link br2 ba ph3 pv2 mr2 dib blue"
            , onClick Load
            ]
            [ text "Filter Silences" ]
        , text "hello"
        ]


formInput : String -> (String -> msg) -> Html msg
formInput inputValue msg =
    Html.input
        [ class "input-reset ba br1 b--black-20 pa2 mb2 mr2 dib w-40"
        , value inputValue
        , onInput msg
        ]
        []
