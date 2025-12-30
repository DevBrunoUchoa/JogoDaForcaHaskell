module Logica where

import Data.Char (toUpper, isLetter)

-- Verifica se a letra existe na palavra
temLetra :: Char -> String -> Bool
temLetra letra palavra = letra `elem` palavra

-- Desenha a palavra com underlines nas letras que faltam
mostrarPainel :: String -> [Char] -> String
mostrarPainel palavra letrasDescobertas = 
    [ if x `elem` letrasDescobertas then x else '_' | x <- palavra ]

-- Se não sobrou nenhum underline, significa que ganhou
verificarVitoria :: String -> [Char] -> Bool
verificarVitoria palavra letrasDescobertas = 
    all (\x -> x `elem` letrasDescobertas) palavra

-- Normaliza a entrada
tratarEntrada :: String -> Char
tratarEntrada entrada = toUpper (head entrada)

-- Desenha o boneco baseado no número de erros
desenhoForca :: Int -> String
desenhoForca erros = case erros of
    0 -> "\n  +---+\n      |\n      |\n========="
    1 -> "\n  +---+\n  O   |\n      |\n========="
    2 -> "\n  +---+\n  O   |\n  |   |\n========="
    3 -> "\n  +---+\n  O   |\n /|   |\n========="
    4 -> "\n  +---+\n  O   |\n /|\\  |\n========="
    5 -> "\n  +---+\n  O   |\n /|\\  |\n /    |\n========="
    _ -> "\n  +---+\n  O   |\n /|\\  |\n / \\  |\n========="