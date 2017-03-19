module View exposing (view)

import Svg
import Types exposing (Model, Msg(..), ApiResponse(..), Data)
import Html exposing (..)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput, onClick)
import Http exposing (Error(..))
import Plot exposing (..)
import Plot.Line as Line
import Plot.Axis as Axis
import Settings exposing (..)


view : Model -> Html Msg
view model =
    let
        graphHtml =
            case model.data of
                Success data ->
                    graph data

                Failure err ->
                    error err

                Loading ->
                    loading

                NotRequested ->
                    span [] []
    in
        div []
            [ formInput model.query UpdateQuery
            , a
                [ class "f6 link br2 ba ph3 pv2 mr2 dib blue"
                , onClick Load
                ]
                [ text "Graph" ]
            , graphHtml
            ]


graph : Data -> Svg.Svg a
graph data =
    let
        lines =
            List.map
                (\r ->
                    line
                        [ Line.stroke blueStroke
                        , Line.strokeWidth 2
                        ]
                    <|
                        List.map
                            (\{ x, y } ->
                                ( x, Maybe.withDefault 0 y )
                            )
                            r.value
                )
                data.result
    in
        plot
            [ size plotSize
            , margin ( 10, 20, 40, 20 )
            , domainLowest (min 0)
            ]
            lines


formInput : String -> (String -> msg) -> Html msg
formInput inputValue msg =
    Html.input
        [ class "input-reset ba br1 b--black-20 pa2 mb2 mr2 dib w-40"
        , value inputValue
        , onInput msg
        ]
        []


loading : Html msg
loading =
    div []
        [ i [ class "fa fa-cog fa-spin fa-3x fa-fw" ] []
        , span [ class "sr-only" ] [ text "Loading..." ]
        ]


error : Http.Error -> Html msg
error err =
    let
        msg =
            case err of
                Timeout ->
                    "timeout exceeded"

                NetworkError ->
                    "network error"

                BadStatus resp ->
                    resp.status.message ++ " " ++ resp.body

                BadPayload err resp ->
                    -- OK status, unexpected payload
                    "unexpected response from api"

                BadUrl url ->
                    "malformed url: " ++ url
    in
        div []
            [ p [] [ text <| "Error: " ++ msg ]
            ]
