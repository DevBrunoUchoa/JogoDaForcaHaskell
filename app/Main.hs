module Main where

import System.IO
import System.Random (randomRIO)
import Data.Char (isLetter)

import EstadoJogo
import Logica
import Arquivo

main :: IO ()
main = do
    hSetBuffering stdout NoBuffering
    menuPrincipal

menuPrincipal :: IO ()
menuPrincipal = do
    putStrLn "\n=== JOGO DA FORCA ==="
    putStrLn "1. Jogar"
    putStrLn "2. Sair"
    putStr "Escolha: "
    opcao <- getLine
    case opcao of
        "1" -> menuDificuldade
        _   -> putStrLn "Saindo..."

menuDificuldade :: IO ()
menuDificuldade = do
    putStrLn "\n--- DIFICULDADE ---"
    putStrLn "1. Facil (7 erros)"
    putStrLn "2. Dificil (5 erros)"
    putStr "Escolha: "
    op <- getLine

    banco <- carregarBancoDePalavras

    case op of
        "1" -> iniciarJogo (filtrarPorDificuldade "FACIL" banco) 7
        "2" -> iniciarJogo (filtrarPorDificuldade "DIFICIL" banco) 5
        _   -> do
            putStrLn "Opcao invalida"
            menuDificuldade

iniciarJogo :: [String] -> Int -> IO ()
iniciarJogo palavras maxE
    | null palavras = putStrLn "Erro: Nenhuma palavra encontrada!"
    | otherwise = do
        idx <- randomRIO (0, length palavras - 1)
        let palavra = palavras !! idx
        loopJogo (estadoInicial palavra maxE)

loopJogo :: EstadoJogo -> IO ()
loopJogo estado = do
    putStrLn (desenhoForca (erros estado))
    putStrLn ("\nPalavra: " ++ mostrarPainel (palavraSecreta estado) (letrasUsadas estado))
    putStrLn ("Letras usadas: " ++ show (letrasUsadas estado))
    putStrLn ("Erros: " ++ show (erros estado) ++ "/" ++ show (maxErros estado))

    if jogoPerdido estado
        then putStrLn ("\nPERDEU! A palavra era: " ++ palavraSecreta estado)
        else if verificarVitoria estado
            then putStrLn "\nPARABENS! Voce venceu!"
            else do
                putStr "\nDigite uma letra: "
                entrada <- getLine
                case tratarEntrada entrada of
                    Nothing ->
                        loopJogo estado

                    Just letra
                        | not (isLetter letra) -> do
                            putStrLn ">> Digite apenas letras!"
                            loopJogo estado
                        | otherwise ->
                            loopJogo (processarJogada letra estado)
