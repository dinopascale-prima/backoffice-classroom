module Main exposing (..)

import Browser
import Http
import Html exposing (Html, img, table, tbody, td, text, th, thead, tr, button, div)
import Html.Attributes exposing (src)
import Html.Events exposing (onClick)


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
    { id : Int
    , name : String
    , image : String
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
    , expect = Http.expectJson GotPokemons
    }

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Something _ ->
            ( { model | pokemons = Initial }, Cmd.none )

        RequestPokemons -> ( {model | pokemons = Loading}, Cmd.none )

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
        Initial -> div [][button [onClick RequestPokemons][text "Click here"]]
        Loading -> div [][text "Loading..."]
        Done (Err e) -> div [][text "e"]


renderPokemonRows : Pokemon -> Html Msg
renderPokemonRows { id, name, image } =
    tr []
        [ td [] [ text <| String.fromInt id ]
        , td [] [ text name ]
        , td [] [ img [ src image ] [] ]
        ]
