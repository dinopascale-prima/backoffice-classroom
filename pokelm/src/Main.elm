module Main exposing (..)

import Browser
import Html exposing (Html, button, div, img, table, tbody, td, text, th, thead, tr)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)
import Http
import Json.Decode


{-|

    Vogliamo realizzare una piccola webapp che, all'avvio, recuperi da endpoint remoto
    [PokeApi](https://pokeapi.co/?ref=public-apis) i dati dei primi 150 Pokémon
    e li visualizzi in una tabella html in cui dovranno comparire:
    - index (no zero based)
    - nome del pokemon capitalizzato
    - immagine (recuperabile da questo indirizzo `https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/:index.png`)

    Bisognerà gestire gli errori da API e i tempi di loading nella view principale

    Se abbiamo tempo possiamo
    - rendere questa tabella sortabile (per nome?)
    - inserire un form in cui l'utente può inserire il nome del pokemon e che scatena una ricerca mirata

-}
type alias Pokemon =
    { -- id : Int,
      name : String

    -- , image : String
    }


type PokemonList
    = Initial
    | Loading
    | Done (Result Http.Error (List Pokemon))


type alias Model =
    { pokemons : PokemonList
    }


type Msg
    = Something Pokemon
    | RequestPokemons
    | Other
    | GotPokemons (Result Http.Error (List Pokemon))


initialModel : () -> ( Model, Cmd Msg )
initialModel _ =
    ( { pokemons = Initial }, Cmd.none )


getPokemons : Cmd Msg
getPokemons =
    Http.get
        { url = "http://localhost:5000/api/v2/pokemon?limit=150"
        , expect = Http.expectJson GotPokemons decoder
        }


decoder : Json.Decode.Decoder (List Pokemon)
decoder =
    Json.Decode.field "results" (Json.Decode.list decoderPokemon)


decoderPokemon : Json.Decode.Decoder Pokemon
decoderPokemon =
    Json.Decode.map Pokemon (Json.Decode.field "name" Json.Decode.string)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Something _ ->
            ( { model | pokemons = Initial }, Cmd.none )

        RequestPokemons ->
            ( { model | pokemons = Loading }, getPokemons )

        GotPokemons (Ok pokemons) ->
            ( { model | pokemons = Done (Ok pokemons) }, Cmd.none )

        GotPokemons (Err e) ->
            ( { model | pokemons = Done (Err e) }, Cmd.none )

        Other ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


main : Program () Model Msg
main =
    Browser.element
        { init = initialModel
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


view : Model -> Html Msg
view model =
    case model.pokemons of
        Done (Ok pokemons) ->
            div []
                [ table
                    []
                    [ thead
                        []
                        [ tr
                            []
                            [ th [] [ text "Index" ]
                            , th [] [ text "Nome" ]
                            , th [] [ text "Immagine" ]
                            ]
                        ]
                    , tbody [] (List.map renderPokemonRows pokemons)
                    ]
                ]

        Initial ->
            div [] [ button [ onClick RequestPokemons ] [ text "Click here" ] ]

        Loading ->
            div [] [ text "Loading..." ]

        Done (Err e) ->
            div [] [ text "e" ]


renderPokemonRows : Pokemon -> Html Msg
renderPokemonRows { name } =
    tr []
        [ td [] [ text "1" ]
        , td [] [ text name ]
        , td [] [ img [ src "" ] [] ]
        ]
