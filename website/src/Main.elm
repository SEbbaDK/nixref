module Main exposing(main)

import Browser
import Html exposing (Html, button, div, text, input)
import Html.Attributes exposing (placeholder, value)
import Html.Events exposing (onClick, onInput)
import Http
import Json.Decode as D

main =
    Browser.document {
        init = init,
        update = update,
        view = view,
        subscriptions = subscriptions
        }

type alias Model =
    { search: String
    , results: List QueryResult
    , error: String
    }
type alias QueryResult =
    { resource_name: String
    , url: String
    , title: String
    , blurb: String
    }

queryResultDecoder =
    D.map4 QueryResult
        (D.field "resource_name" D.string)
        (D.field "url" D.string)
        (D.field "title" D.string)
        (D.field "blurb" D.string)

init : String -> (Model, Cmd Msg)
init _ = ({ search = "", results = [], error = "" }, Cmd.none)

type Msg = SearchChange String
         | GotResults (Result Http.Error (List QueryResult))

error2string error =
    case error of
        Http.Timeout -> "Timed out"
        Http.BadUrl _ -> "Bad url"
        Http.NetworkError -> "Network error"
        Http.BadStatus _ -> "Bad status"
        Http.BadBody _ -> "Bad body"

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        SearchChange newValue ->
            ( { model | search = newValue }
            , Http.get { url = "http://localhost:8080/search/" ++ newValue
                       , expect = Http.expectJson GotResults (D.list queryResultDecoder)
                       }
            )
        GotResults res ->
            case res of
                Ok results ->
                    ( { model | results = results }, Cmd.none )
                Err error ->
                    ( { model | error = error2string error }, Cmd.none )

subscriptions model =
    Sub.none

viewResult res = div [] [ text res.title ]
viewResults results = div [] (List.map viewResult results)

view model = {
    title = "Nixref",
    body = [
        div []
            [ div [] [ text model.error ]
            , input [
                placeholder "Search nixref...",
                value model.search, onInput SearchChange
                ] []
            , viewResults model.results
            ]
        ]
    }

