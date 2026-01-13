module EstadoJogo where

data EstadoJogo = EstadoJogo
    { palavraSecreta :: String
    , letrasUsadas   :: [Char]
    , erros          :: Int
    , maxErros       :: Int
    } deriving (Show)

estadoInicial :: String -> Int -> EstadoJogo
estadoInicial palavra = EstadoJogo palavra [] 0
