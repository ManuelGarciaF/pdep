-- | https://docs.google.com/document/d/1C_oehBaJYavsacmThRZcrpIpX6axxVOdX19vYusRhlE/
module Vacaciones where

import PdePreludat

-- 1.

data Turista = Turista
  { cansancio :: !Number,
    stress :: !Number,
    solo :: !Bool,
    idiomas :: ![String]
  }

ana :: Turista
ana =
  Turista
    { cansancio = 0,
      stress = 21,
      solo = False,
      idiomas = ["Español"]
    }

beto :: Turista
beto =
  Turista
    { cansancio = 15,
      stress = 15,
      solo = True,
      idiomas = ["Aleman"]
    }

cathi :: Turista
cathi = beto {idiomas = ["Catalan", "Aleman"]}

-- 2.

type Excursion = Turista -> Turista

hacerExcursion :: Excursion -> Turista -> Turista
hacerExcursion excursion turista = variarStress (- reduccion) . excursion $ turista
  where
    reduccion = stress turista `div` 10

variarStress :: Number -> Turista -> Turista
variarStress variacion turista = turista {stress = stress turista + variacion}

variarCansancio :: Number -> Turista -> Turista
variarCansancio variacion turista = turista {cansancio = cansancio turista + variacion}

irALaPlaya :: Excursion
irALaPlaya turista
  | solo turista = variarCansancio (-5) turista
  | otherwise = variarStress (-1) turista

apreciarElemento :: String -> Excursion
apreciarElemento elemento = variarStress (- length elemento)

salirAHablar :: String -> Excursion
salirAHablar idioma turista =
  turista
    { solo = False,
      idiomas = idioma : (filter (/= idioma) . idiomas) turista -- Remueve duplicados
    }

caminar :: Number -> Excursion
caminar minutos = variarStress (- intensidad) . variarCansancio intensidad
  where
    intensidad = minutos `div` 4

data Marea = MareaFuerte | MareaModerada | MareaTranquila deriving (Eq)

paseoEnBarco :: Marea -> Excursion
paseoEnBarco MareaFuerte turista =
  turista
    { stress = stress turista + 6,
      cansancio = cansancio turista + 10
    }
paseoEnBarco MareaModerada turista = turista
paseoEnBarco MareaTranquila turista = salirAHablar "Aleman" . apreciarElemento "mar" . caminar 10 $ turista

deltaSegun :: (a -> Number) -> a -> a -> Number
deltaSegun f algo1 algo2 = f algo1 - f algo2

deltaExcursionSegun :: (Turista -> Number) -> Turista -> Excursion -> Number
deltaExcursionSegun indice turista excursion = (indice . hacerExcursion excursion) turista - indice turista

esEducativa :: Excursion -> Turista -> Bool
esEducativa excursion turista = (> 0) $ deltaExcursionSegun (length . idiomas) turista excursion

excursionesDesestresantes :: Turista -> [Excursion] -> [Excursion]
excursionesDesestresantes turista = filter (esDesestresante turista)

esDesestresante :: Turista -> Excursion -> Bool
esDesestresante turista = (<= -3) . deltaExcursionSegun stress turista

-- 3.
type Tour = [Excursion]

tourCompleto :: Tour
tourCompleto =
  [ caminar 20,
    apreciarElemento "cascada",
    caminar 40,
    irALaPlaya,
    salirAHablar "melmacquiano"
  ]

ladoB :: Excursion -> Tour
ladoB excursionElegida =
  [ paseoEnBarco MareaTranquila,
    excursionElegida,
    caminar 120
  ]

islaVecina :: Marea -> Tour
islaVecina marea =
  [ paseoEnBarco marea,
    excursion,
    paseoEnBarco marea
  ]
  where
    excursion
      | marea == MareaFuerte = apreciarElemento "lago"
      | otherwise = irALaPlaya

hacerTour :: Tour -> Turista -> Turista
hacerTour tour turista = foldl (flip hacerExcursion) (variarStress (length tour) turista) tour

leEsConvincente :: Turista -> Tour -> Bool
leEsConvincente turista = any (\excursion -> esDesestresante turista excursion && (not . solo . hacerExcursion excursion) turista)

hayAlgunoConvincente :: Turista -> [Tour] -> Bool
hayAlgunoConvincente turista = any (leEsConvincente turista)

efectividad :: Tour -> [Turista] -> Number
efectividad tour = sum . map espiritualidadRecibida . filter (`leEsConvincente` tour)
  where
    espiritualidadRecibida turista = perdidaStress turista + perdidaCansancio turista
    perdidaStress turista = max 0 (deltaTourSegun stress turista tour) -- Solo considerar perdidas
    perdidaCansancio turista = max 0 (deltaTourSegun cansancio turista tour) -- Solo considerar perdidas

deltaTourSegun :: (Turista -> Number) -> Turista -> Tour -> Number
deltaTourSegun indice turista tour = (indice . hacerTour tour) turista - indice turista

-- 4.

-- a) repeat irALaPlaya

-- No quiero pensar tanto
