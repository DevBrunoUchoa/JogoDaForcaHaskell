module Arquivo where

quebrarVirgula :: String -> (String, String)
quebrarVirgula linha = 
    let palavra = takeWhile (/= ',') linha
        resto = dropWhile (/= ',') linha
        dificuldade = drop 1 resto 
    in (palavra, dificuldade)

carregarBancoDePalavras :: IO [(String, String)]
carregarBancoDePalavras = do
    conteudo <- readFile "palavras.csv"
    let linhas = lines conteudo
    return (map quebrarVirgula linhas)

filtrarPorDificuldade ::String -> [(String, String)] -> [String]
filtrarPorDificuldade difEscolhida lista = 
    [ p | (p, d) <- lista, d == difEscolhida ]