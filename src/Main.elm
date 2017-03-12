module Main exposing (..)

import Navigation
import Types exposing (..)
import Parsing exposing (urlParser)
import Api exposing (query)
import Html exposing (..)
import Html.Attributes exposing (..)


main : Program Never Model Msg
main =
    Navigation.program urlUpdate
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    ( { data = Loading, route = urlParser location }, Cmd.none )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model, Navigation.newUrl url )

        Show ->
            -- Parse url stuff and load data
            ( model, Cmd.none )

        Load q ->
            ( model, query q )


urlUpdate : Navigation.Location -> Msg
urlUpdate location =
    let
        route =
            urlParser location
    in
        case route of
            Graph ->
                Show

            TopLevel ->
                NewUrl graphUrl

            NotFound ->
                NewUrl graphUrl


graphUrl : String
graphUrl =
    "#/graphs"


view : Model -> Html Msg
view model =
    div [] [ text "hello" ]


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
