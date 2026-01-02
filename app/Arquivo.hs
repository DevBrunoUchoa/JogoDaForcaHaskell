module Arquivo where

import System.IO

-- Função auxiliar que quebra uma string quando encontra uma vírgula
quebrarVirgula :: String -> (String, String)
quebrarVirgula linha = 
    let palavra = takeWhile (/= ',') linha
        resto = dropWhile (/= ',') linha
        dificuldade = drop 1 resto -- remove a vírgula
    in (palavra, dificuldade)

-- Lê o arquivo "palavras.csv" e devolve uma lista de tuplas
carregarBancoDePalavras :: IO [(String, String)]
carregarBancoDePalavras = do
    conteudo <- readFile "palavras.csv"
    let linhas = lines conteudo
    return (map quebrarVirgula linhas)

-- Filtra as palavras baseada na dificuldade escolhida
filtrarPorDificuldade ::String -> [(String, String)] -> [String]
filtrarPorDificuldade difEscolhida lista = 
    [ p | (p, d) <- lista, d == difEscolhida ]