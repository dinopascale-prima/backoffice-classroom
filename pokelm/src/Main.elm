module Main exposing (..)
import Browser
import Html exposing (text)
import Html exposing (Html)

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

type alias Model = {
    pokemons: List Pokemon
    }

type Msg = Something Pokemon | Other

initialModel : () -> (Model, Cmd Msg)
initialModel _= ({pokemons= [] }, Cmd.none)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Something _-> ({model | pokemons = []}, Cmd.none)
        Other -> (model,  Cmd.none)

subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none

main =
    Browser.element({ 
        init=initialModel, 
        view=view, 
        update=update, 
        subscriptions=subscriptions})



view : Model -> Html Msg
view model =
    Html.div [] [text "Hello Moon"]

