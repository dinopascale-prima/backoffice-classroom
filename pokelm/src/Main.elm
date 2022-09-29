module Main exposing (..)

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

import Html


main : Html.Html msg
main =
    Html.text "Hello World"
