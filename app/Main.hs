module Main where

import System.IO
import System.Random (randomRIO)
import Data.Char (toUpper, isLetter)

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
    putStrLn "1. Jogar (Solo)"
    putStrLn "2. Instrucoes"
    putStrLn "3. Modo Multijogador"
    putStrLn "4. Sair"
    putStr "Escolha: "
    opcao <- getLine
    case opcao of
        "1" -> menuDificuldade
        "2" -> do
            exibirInstrucoes
            menuPrincipal
        "3" -> menuMultijogador
        "4" -> putStrLn "Saindo..."
        _   -> do
            putStrLn "Opcao invalida! Tente novamente."
            menuPrincipal

-- Função para exibir as regras
exibirInstrucoes :: IO ()
exibirInstrucoes = do
   putStrLn "\n========================================"
   putStrLn "       REGRAS E INSTRUÇÕES"
   putStrLn "========================================"
   putStrLn "1. O objetivo é adivinhar a palavra secreta."
   putStrLn "2. A cada rodada, digite uma letra."
   putStrLn "3. Se a letra estiver na palavra, ela será revelada."
   putStrLn "4. Se errar, uma parte do corpo será desenhada."
   putStrLn "5. No modo FÁCIL, você pode errar até 7 vezes."
   putStrLn "6. No modo DIFÍCIL, você pode errar até 5 vezes."
   putStrLn "============================================\n"
   putStrLn "Pressione Enter para voltar ao menu..."
   _ <- getLine -- Espera o usuário apertar Enter
   return ()

imprimirDivisor :: IO()
imprimirDivisor = putStrLn "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n-----------------------------------------------------------"

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

exibirEstado :: EstadoJogo -> Maybe String -> IO ()
exibirEstado estado msgErro = do
    putStrLn (desenhoForca (erros estado) (maxErros estado))
    putStrLn ("\nPalavra: " ++ mostrarPainel (palavraSecreta estado) (letrasUsadas estado))
    putStrLn ("Letras usadas: " ++ show (letrasUsadas estado))
    putStrLn ("Erros: " ++ show (erros estado) ++ "/" ++ show (maxErros estado))
    case msgErro of
      Just msg -> putStrLn msg
      Nothing  -> return ()

loopJogo :: EstadoJogo -> IO ()
loopJogo estado = loopJogoComErro estado Nothing

loopJogoComErro :: EstadoJogo -> Maybe String -> IO ()
loopJogoComErro estado msgErro = do
    imprimirDivisor
    exibirEstado estado msgErro
    case statusJogo estado of
        Perdido ->
            putStrLn ("\nPERDEU! A palavra era: " ++ palavraSecreta estado)

        Venceu ->
            putStrLn "\nPARABENS! Voce venceu!"

        EmAndamento ->
            processarTurnoComErro estado

processarTurnoComErro :: EstadoJogo -> IO ()
processarTurnoComErro estado = do
    putStr "\nDigite uma letra: "
    entrada <- getLine
    case avaliarEntrada entrada of
        EntradaInvalida msg ->
            loopJogoComErro estado (Just msg)

        IgnorarEntrada ->
            loopJogoComErro estado Nothing

        JogadaValida letra ->
            loopJogoComErro (processarJogada letra estado) Nothing

-- === LOGICA DO MODO MULTIJOGADOR ===
processarTurno :: EstadoJogo -> IO ()
processarTurno = processarTurnoComErro

validarPalavraSecreta :: String -> Either String String
validarPalavraSecreta entrada
    | null entrada = Left "A palavra nao pode ser vazia."
    | length entrada < 3 = Left "A palavra deve ter no minimo 3 letras."
    | any (== ' ') entrada = Left "A palavra nao pode conter espacos."
    | not (all isLetter entrada) = Left "Apenas letras sao permitidas."
    | otherwise = Right (map toUpper entrada)

menuMultijogador :: IO ()
menuMultijogador = do
    putStrLn "\n=== MODO MULTIJOGADOR ==="
    putStrLn "Regras: Minimo 3 letras, sem espacos, apenas letras."
    putStrLn "JOGADOR 1: Digite a palavra secreta:"
    entrada <- getLine
    
    case validarPalavraSecreta entrada of
        Left erro -> do
            putStrLn ("\n>>> ERRO: " ++ erro ++ " Tente novamente. <<<")
            menuMultijogador
            
        Right palavraValida -> do
            putStrLn (replicate 50 '\n') 
            putStrLn "JOGADOR 1: Escolha a dificuldade para o JOGADOR 2:"
            putStrLn "1. Facil (7 erros)"
            putStrLn "2. Dificil (5 erros)"
            putStr "Escolha: "
            op <- getLine

            case op of
                "1" -> iniciarJogoCustomizado palavraValida 7
                "2" -> iniciarJogoCustomizado palavraValida 5
                _   -> do
                    putStrLn "Opcao invalida!"
                    menuMultijogador

iniciarJogoCustomizado :: String -> Int -> IO ()
iniciarJogoCustomizado palavra maxE = do
    putStrLn "\n--- JOGO INICIADO ---"
    putStrLn "JOGADOR 2: Tente adivinhar a palavra!"
    loopJogo (estadoInicial palavra maxE)