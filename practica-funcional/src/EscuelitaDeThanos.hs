-- Enunciado: https://docs.google.com/document/d/1IKrJkdbPyoxfHqREIfqzxpsBdANcL2g9gvs9t-IR30E

module EscuelitaDeThanos where

import PdePreludat

-- 1.

data Guantelete = Guantelete
  { material :: !String,
    gemas :: ![Gema]
  }

data Persona = Persona
  { edad :: !Number,
    energia :: !Number,
    habilidades :: ![String],
    planeta :: !String
  }

type Universo = [Persona]

chasquido :: Guantelete -> Universo -> Universo
chasquido guantelete universo
  | guanteleteEsValido = take ((`div` 2) . length $ universo) universo
  | otherwise = universo
  where
    guanteleteEsValido = material guantelete == "uru" && ((== 6) . length . gemas $ guantelete)

-- 2.

aptoParaPendex :: Universo -> Bool
aptoParaPendex = any ((< 45) . edad)

energiaTotal :: Universo -> Number
energiaTotal = sum . map energia . filter ((> 1) . length . habilidades)

-- 3.

type Gema = Persona -> Persona

gemaMente :: Number -> Gema
gemaMente reduccion persona =
  persona
    { energia = energia persona - reduccion
    }

gemaAlma :: String -> Gema
gemaAlma habilidad persona =
  persona
    { habilidades = filter (/= habilidad) . habilidades $ persona
    }

gemaEspacio :: String -> Gema
gemaEspacio destino persona =
  persona
    { planeta = destino,
      energia = energia persona - 20
    }

gemaPoder :: Gema
gemaPoder persona
  | (length . habilidades) persona <= 2 =
    persona
      { habilidades = drop 2 . habilidades $ persona,
        energia = 0
      }
  | otherwise = persona {energia = 0}

gemaTiempo :: Gema
gemaTiempo persona =
  persona
    { edad = min 18 (edad persona `div` 2),
      energia = energia persona - 50
    }

gemaLoca :: Gema -> Gema
gemaLoca gema = gema . gema

-- 4.

guanteEjemplo :: Guantelete
guanteEjemplo =
  Guantelete
    { material = "Goma",
      gemas =
        [ gemaTiempo,
          gemaAlma "usar Mjolnir",
          gemaLoca (gemaAlma "programación en Haskell")
        ]
    }

-- 5.

utilizar :: [Gema] -> Persona -> Persona
utilizar gemas enemigo = foldl (flip ($)) enemigo gemas

-- Se produce el "efecto de lado" porque vamos aplicando sucesivamente las gemas, utilizando el resultado
-- de una como argumento de la próxima.

-- 6.

gemaMasPoderosa :: Guantelete -> Persona -> Gema
gemaMasPoderosa (Guantelete _ []) _ = undefined -- No tiene sentido
gemaMasPoderosa (Guantelete _ [gema]) _ = gema
gemaMasPoderosa (Guantelete _ (gema1 : gema2 : gemas)) persona
  | (energia . gema1) persona < (energia . gema2) persona = gemaMasPoderosa (Guantelete "" (gema1 : gemas)) persona
  | otherwise = gemaMasPoderosa (Guantelete "" (gema2 : gemas)) persona
