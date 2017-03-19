module Main exposing (..)

import Navigation
import Types exposing (..)
import Parsing exposing (urlParser)
import Api exposing (query)
import View exposing (view)
import Time


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
    ( { data = NotRequested
      , query = ""
      , route = urlParser location
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewUrl url ->
            ( model, Navigation.newUrl url )

        Show ->
            ( model, Cmd.none )

        UpdateQuery q ->
            ( { model | query = q }, Cmd.none )

        Load ->
            let
                start =
                    1489520402.806 * Time.millisecond

                end =
                    1489524002.806 * Time.millisecond
            in
                ( { model | data = Loading }, query model.query start end )

        Response apiData ->
            ( { model | data = apiData }, Cmd.none )


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
