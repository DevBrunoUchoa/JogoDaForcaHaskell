module Logica where

import EstadoJogo
import Normalizacao
import Data.Char (isLetter)
import Data.List (intersperse)

mostrarPainel :: String -> [Char] -> String
mostrarPainel palavra letrasDescobertas =
    intersperse ' ' [ if normalizarChar x `elem` map normalizarChar letrasDescobertas
                        then x
                        else '_'
                    | x <- palavra
                    ]

verificarVitoria :: EstadoJogo -> Bool
verificarVitoria estado =
    all (`elem` letrasNorm)
        palavraNorm
  where
    palavraNorm = normalizarString (palavraSecreta estado)
    letrasNorm  = map normalizarChar (letrasUsadas estado)

jogoPerdido :: EstadoJogo -> Bool
jogoPerdido estado =
    erros estado >= maxErros estado

data StatusJogo = Venceu | Perdeu | EmAndamento

statusJogo :: EstadoJogo -> StatusJogo
statusJogo estado
    | jogoPerdido estado      = Perdeu
    | verificarVitoria estado = Venceu
    | otherwise               = EmAndamento

processarJogada :: Char -> EstadoJogo -> EstadoJogo
processarJogada letra estado
    | letraNorm `elem` letrasNorm = estado
    | letraNorm `elem` palavraNorm =
        estado { letrasUsadas = letra : letrasUsadas estado }
    | otherwise =
        estado { letrasUsadas = letra : letrasUsadas estado
               , erros = erros estado + 1
               }
  where
    letraNorm   = normalizarChar letra
    letrasNorm  = map normalizarChar (letrasUsadas estado)
    palavraNorm = normalizarString (palavraSecreta estado)

avaliarEntrada :: String -> ResultadoEntrada
avaliarEntrada entrada
    | length entrada > 1 && all isLetter entrada =
        EntradaInvalida "\n>> Digite apenas UMA letra!"
    | entradaInvalida entrada =
        EntradaInvalida "\n>> Digite apenas letras"
    | otherwise =
        maybe IgnorarEntrada JogadaValida (tratarEntrada entrada)

data ResultadoEntrada
    = EntradaInvalida String
    | JogadaValida Char
    | IgnorarEntrada


entradaInvalida :: String -> Bool
entradaInvalida entrada =
    null entrada || not (all isLetter entrada)

tratarEntrada :: String -> Maybe Char
tratarEntrada []    = Nothing
tratarEntrada (c:_) = Just (normalizarChar c)

desenhoForca :: Int -> Int -> String
desenhoForca errosAtuais maxErrosPermitidos =
    let 
        indicesDesenho :: [Int]
        indicesDesenho = if maxErrosPermitidos == 5
            then     [0, 1, 2, 4, 5, 6]
            else     [0, 1, 2, 3, 4, 5, 5, 6]
        idx = min errosAtuais (length indicesDesenho - 1)
        fase = indicesDesenho !! idx
    in case fase of
        0 -> "\n  +---+\n      |\n      |\n========="
        1 -> "\n  +---+\n  O   |\n      |\n=========" 
        2 -> "\n  +---+\n  O   |\n  |   |\n=========" 
        3 -> "\n  +---+\n  O   |\n /|   |\n=========" 
        4 -> "\n  +---+\n  O   |\n /|\\  |\n=========" 
        5 -> "\n  +---+\n  O   |\n /|\\  |\n /    |\n=========" 
        6 -> "\n  +---+\n  O   |\n /|\\  |\n / \\  |\n=========" 
        _ -> "\n  +---+\n  O   |\n /|\\  |\n / \\  |\n========="
