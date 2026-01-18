module Logica where

import EstadoJogo
import Normalizacao
import Data.Char (isLetter)


data ResultadoEntrada
    = EntradaInvalida String
    | JogadaValida Char
    | IgnorarEntrada

temLetra :: Char -> String -> Bool
temLetra letra palavra =
    normalizarChar letra `elem` normalizarString palavra

mostrarPainel :: String -> [Char] -> String
mostrarPainel palavra letrasDescobertas =
    [ if normalizarChar x `elem` map normalizarChar letrasDescobertas
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

data StatusJogo = Venceu | Perdido | EmAndamento

statusJogo :: EstadoJogo -> StatusJogo
statusJogo estado
    | jogoPerdido estado      = Perdido
    | verificarVitoria estado = Venceu
    | otherwise               = EmAndamento

tratarEntrada :: String -> Maybe Char
tratarEntrada []    = Nothing
tratarEntrada (c:_) = Just (normalizarChar c)

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


entradaInvalida :: String -> Bool
entradaInvalida entrada =
    null entrada || not (all isLetter entrada)


desenhoForca :: Int -> String
desenhoForca erros = case erros of
    0 -> "\n  +---+\n      |\n      |\n========="
    1 -> "\n  +---+\n  O   |\n      |\n========="
    2 -> "\n  +---+\n  O   |\n  |   |\n========="
    3 -> "\n  +---+\n  O   |\n /|   |\n========="
    4 -> "\n  +---+\n  O   |\n /|\\  |\n========="
    5 -> "\n  +---+\n  O   |\n /|\\  |\n /    |\n========="
    _ -> "\n  +---+\n  O   |\n /|\\  |\n / \\  |\n========="
