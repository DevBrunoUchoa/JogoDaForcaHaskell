module Normalizacao where

import Data.Char (toUpper)

normalizarChar :: Char -> Char
normalizarChar c = case toUpper c of
    'Á' -> 'A'
    'À' -> 'A'
    'Ã' -> 'A'
    'Â' -> 'A'
    'Ä' -> 'A'
    'É' -> 'E'
    'Ê' -> 'E'
    'Í' -> 'I'
    'Ó' -> 'O'
    'Ô' -> 'O'
    'Õ' -> 'O'
    'Ú' -> 'U'
    'Ç' -> 'C'
    x   -> x

normalizarString :: String -> String
normalizarString = map normalizarChar
