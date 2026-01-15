module Logica where

import Data.Char (toUpper)
import EstadoJogo

temLetra :: Char -> String -> Bool
temLetra letra palavra =
    letra `elem` palavra

mostrarPainel :: String -> [Char] -> String
mostrarPainel palavra letrasDescobertas =
    [ if x `elem` letrasDescobertas then x else '_' | x <- palavra ]

verificarVitoria :: EstadoJogo -> Bool
verificarVitoria estado =
    all (`elem` letrasUsadas estado) (palavraSecreta estado)

tratarEntrada :: String -> Maybe Char
tratarEntrada []    = Nothing
tratarEntrada (c:_) = Just (toUpper c)

processarJogada :: Char -> EstadoJogo -> EstadoJogo
processarJogada letra estado
    | letra `elem` letrasUsadas estado = estado
    | temLetra letra (palavraSecreta estado) =
        estado { letrasUsadas = letra : letrasUsadas estado }
    | otherwise =
        estado { letrasUsadas = letra : letrasUsadas estado
               , erros = erros estado + 1
               }

jogoPerdido :: EstadoJogo -> Bool
jogoPerdido estado =
    erros estado >= maxErros estado

desenhoForca :: Int -> String
desenhoForca erros = case erros of
    0 -> "\n  +---+\n      |\n      |\n========="
    1 -> "\n  +---+\n  O   |\n      |\n========="
    2 -> "\n  +---+\n  O   |\n  |   |\n========="
    3 -> "\n  +---+\n  O   |\n /|   |\n========="
    4 -> "\n  +---+\n  O   |\n /|\\  |\n========="
    5 -> "\n  +---+\n  O   |\n /|\\  |\n /    |\n========="
    _ -> "\n  +---+\n  O   |\n /|\\  |\n / \\  |\n========="