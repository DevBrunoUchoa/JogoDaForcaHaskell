module Main where

import System.IO
import System.Random (randomRIO)
import Data.Char (isLetter)
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
    putStrLn "2. Instruções"
    putStrLn "3. Sair"
    putStr "Escolha: "
    opcao <- getLine
    case opcao of
        "1" -> menuDificuldade
        "2" -> do 
            exibirInstrucoes
            menuPrincipal -- Volta para o menu após ler
        "3" -> putStrLn "Saindo..."
        _   -> do
            putStrLn "Opção inválida!"
            menuPrincipal

-- Função para exibir as regras
exibirInstrucoes :: IO ()
exibirInstrucoes = do
    putStrLn "\n============================================"
    putStrLn "           REGRAS E INSTRUÇÕES"
    putStrLn "============================================"
    putStrLn "1. O objetivo é adivinhar a palavra secreta."
    putStrLn "2. A cada rodada, digite uma letra."
    putStrLn "3. Se a letra estiver na palavra, ela será revelada."
    putStrLn "4. Se errar, uma parte do corpo será desenhada."
    putStrLn "5. No modo FÁCIL, você tem 7 chances."
    putStrLn "6. No modo DIFÍCIL, você tem 5 chances."
    putStrLn "============================================\n"
    putStrLn "Pressione Enter para voltar ao menu..."
    _ <- getLine -- Espera o usuário apertar Enter
    return ()

menuDificuldade :: IO ()
menuDificuldade = do
    putStrLn "\n--- DIFICULDADE ---"
    putStrLn "1. Facil (7 erros)"
    putStrLn "2. Dificil (5 erros)" 
    op <- getLine
    
    -- Carrega o CSV
    bancoCompleto <- carregarBancoDePalavras
    
    if op == "1"
        then do
            let palavrasFiltradas = filtrarPorDificuldade "FACIL" bancoCompleto
            sortearEIniciar palavrasFiltradas 7
        else if op == "2"
            then do
                let palavrasFiltradas = filtrarPorDificuldade "DIFICIL" bancoCompleto
                sortearEIniciar palavrasFiltradas 5
            else do
                putStrLn "Opcao invalida"
                menuDificuldade

sortearEIniciar :: [String] -> Int -> IO ()
sortearEIniciar lista maxErros = do
    if null lista
        then putStrLn "Erro: Nenhuma palavra encontrada no arquivo para essa dificuldade!"
        else do
            indice <- randomRIO (0, length lista - 1)
            let palavraSorteada = lista !! indice
            loopJogo palavraSorteada [] 0 maxErros

-- Loop Principal (Recursivo)
loopJogo :: String -> [Char] -> Int -> Int -> IO ()
loopJogo palavra letrasUsadas errosAtuais maxErros = do
    
    -- Exibe o estado atual
    putStrLn (desenhoForca errosAtuais)
    putStrLn ("\nPalavra: " ++ mostrarPainel palavra letrasUsadas)
    putStrLn ("Letras usadas: " ++ show letrasUsadas)
    putStrLn ("Erros: " ++ show errosAtuais ++ "/" ++ show maxErros)

    -- Verifica fim de jogo
    if errosAtuais >= maxErros
        then putStrLn ("\nPERDEU! A palavra era: " ++ palavra)
        else if verificarVitoria palavra letrasUsadas
            then putStrLn "\nPARABENS! Voce venceu!"
            else do
                putStr "\nDigite uma letra: "
                entrada <- getLine
                
                if null entrada
                    then loopJogo palavra letrasUsadas errosAtuais maxErros
                    else do
                        let letra = tratarEntrada entrada
                        
                        if not (isLetter letra)
                            then do
                                putStrLn ">> Digite apenas letras!"
                                loopJogo palavra letrasUsadas errosAtuais maxErros
                            else if letra `elem` letrasUsadas
                                then do
                                    putStrLn ">> Voce ja tentou essa letra."
                                    loopJogo palavra letrasUsadas errosAtuais maxErros
                                else do
                                    -- Atualiza contagem de erros
                                    let novosErros = if temLetra letra palavra 
                                                     then errosAtuais 
                                                     else errosAtuais + 1
                                    
                                    loopJogo palavra (letra : letrasUsadas) novosErros maxErros
