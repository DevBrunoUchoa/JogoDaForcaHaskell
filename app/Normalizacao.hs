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
    'È' -> 'E'
    'Ë' -> 'E'
    'Í' -> 'I'
    'Ì' -> 'I'
    'Ï' -> 'I'
    'Î' -> 'I'
    'Ó' -> 'O'
    'Ô' -> 'O'
    'Ò' -> 'O'
    'Õ' -> 'O'
    'Ö' -> 'O'
    'Ú' -> 'U'
    'Û' -> 'U'
    'Ù' -> 'U'
    'Ü' -> 'U'
    'Ç' -> 'C'
    x   -> x

normalizarString :: String -> String
normalizarString = map normalizarChar
