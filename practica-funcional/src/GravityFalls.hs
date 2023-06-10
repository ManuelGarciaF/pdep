-- | https://docs.google.com/document/d/1ivhqJIWGanstr324ElRY6lev0b0UN-QN3kcYFH9wqMs/edit
module GravityFalls where

import Data.Char (digitToInt)
import PdePreludat

-- Primera parte

-- 1.

data Creatura = Creatura
  { peligrosidad :: Number,
    requisitoDeshacerse :: Persona -> Bool
  }

data Persona = Persona
  { edad :: Number,
    items :: [String],
    experiencia :: Number
  }

siempreDetras :: Creatura
siempreDetras =
  Creatura
    { peligrosidad = 0,
      requisitoDeshacerse = const False
    }

gnomos :: Number -> Creatura
gnomos numero =
  Creatura
    { peligrosidad = 2 ^ numero,
      requisitoDeshacerse = elem "Soplador de hojas" . items
    }

fantasma :: Number -> (Persona -> Bool) -> Creatura
fantasma poder puedeResolverAsuntoPendiente =
  Creatura
    { peligrosidad = poder * 20,
      requisitoDeshacerse = puedeResolverAsuntoPendiente
    }

-- 2.

aumentarExperiencia :: Number -> Persona -> Persona
aumentarExperiencia aumento persona =
  persona
    { experiencia = experiencia persona + aumento
    }

enfrentar :: Creatura -> Persona -> Persona
enfrentar creatura persona
  | requisitoDeshacerse creatura persona = aumentarExperiencia (peligrosidad creatura) persona
  | otherwise = aumentarExperiencia 1 persona

-- 3.

experienciaGanada :: Persona -> [Creatura] -> Number
experienciaGanada persona creaturas = (experiencia . foldl (flip enfrentar) persona) creaturas - experiencia persona

{- Consulta (iria todo en 1 linea)

  > experienciaGanada
      (Persona 12 [] 27)
      [ siempreDetras,
        gnomos 10,
        fantasma 3 (\persona -> edad persona < 13 && (elem "Disfraz de oveja" . items) persona),
        fantasma 1 ((> 10) . experiencia)
      ]
-}

-- Segunda parte

-- 1.

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf f condicion [] _ = [] -- Parar cuando se termina alguna de las listas
zipWithIf f condicion _ [] = []
zipWithIf f condicion (x : xs) (y : ys)
  | condicion y = f x y : zipWithIf f condicion xs ys
  | otherwise = y : zipWithIf f condicion (x : xs) ys

-- 2.

abecedarioDesde :: Char -> [Char]
abecedarioDesde inicio = take (length ['a' .. 'z']) ([inicio .. 'z'] ++ ['a' .. 'z'])

desencriptarLetra :: Char -> Char -> Char
desencriptarLetra clave encriptada = fst . find ((== encriptada) . snd) $ zip ['a' .. 'z'] (abecedarioDesde clave)

find condicion = head . filter condicion

cesar :: Char -> String -> String
cesar clave = zipWithIf desencriptarLetra (`elem` ['a' .. 'z']) (repeat clave)

-- > map (flip cesar "jrzel zrfaxal!") ['a'..'z']

-- 3.
vigenere :: String -> String -> String
vigenere clave = zipWithIf desencriptarLetra (`elem` ['a' .. 'z']) (cycle clave)
