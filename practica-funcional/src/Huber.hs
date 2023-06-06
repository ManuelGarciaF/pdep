module Huber where

import PdePreludat

--data Ubicacion = Intersección calle1 calle2 | Altura calle número
data Ubicacion
  = Interseccion !String !String
  | Altura !String !Number
  deriving (Show, Eq)

--data Persona = Persona edad tiempoLibre dineroEncima
data Persona = Persona
  { edad :: !Number,
    tiempoLibre :: !Number,
    dineroEncima :: !Number
  }
  deriving (Show)

huberto = Persona 42 10 10.2

leto = Persona 32 20 20

--colectivos = [(línea, paradas)]
type Colectivo = (Number, [Ubicacion])

colectivos :: [Colectivo]
colectivos =
  [ ( 14,
      [ Interseccion "Salguero" "Lavalle",
        Interseccion "Salguero" "Potosi",
        Interseccion "Bulnes" "Potosi",
        Altura "Bulnes" 1200
      ]
    ),
    ( 168,
      [ Altura "Corrientes" 100,
        Altura "Corrientes" 300,
        Altura "Corrientes" 500,
        Altura "Corrientes" 700
      ]
    )
  ]

data Huber = Huber
  { origen :: !Ubicacion,
    destino :: !Ubicacion,
    importe :: !Number
  }

hubers :: [Huber]
hubers =
  [ Huber (Interseccion "Salguero" "Lavalle") (Interseccion "Bulnes" "Potosi") 5,
    Huber (Altura "Av Corrientes" 700) (Interseccion "Sarmiento" "Gallo") 10,
    Huber (Interseccion "Salguero" "Potosi") (Altura "Ecuador" 600) 20,
    Huber (Altura "Corrientes" 300) (Altura "Corrientes" 700) 5,
    Huber (Interseccion "Salguero" "Lavalle") (Altura "Bulnes" 1200) 5
  ]

ubicaciones :: [Ubicacion]
ubicaciones =
  [ ubicacion1,
    Interseccion "Salguero" "Potosi",
    ubicacion2,
    Interseccion "Sarmiento" "Gallo",
    Altura "Ecuador" 600,
    Altura "Corrientes" 100,
    Altura "Corrientes" 300,
    Altura "Corrientes" 500,
    Altura "Corrientes" 700,
    ubicacion3
  ]

ubicacion1 = Interseccion "Salguero" "Lavalle"

ubicacion2 = Interseccion "Bulnes" "Potosi"

ubicacion3 = Altura "Bulnes" 1200

estanOrdenadas :: Ubicacion -> Ubicacion -> [Ubicacion] -> Bool
estanOrdenadas = undefined -- Dada en el enunciado

-- 1.

importeEnHuber :: Ubicacion -> Ubicacion -> Number
importeEnHuber desde hasta
  | any coincide hubers = importe . head . filter coincide $ hubers
  | otherwise = 0
  where
    coincide huber = origen huber == desde && destino huber == hasta

-- 2.

sePuedeIrEnBondi :: Ubicacion -> Ubicacion -> Number
sePuedeIrEnBondi desde hasta
  | any perteneceAlRecorrido colectivos = fst . head . filter perteneceAlRecorrido $ colectivos
  | otherwise = -1
  where
    perteneceAlRecorrido = estanOrdenadas desde hasta . snd

-- 3.

masBaratasQueHuber :: Ubicacion -> Ubicacion -> [Number]
masBaratasQueHuber desde hasta = map fst . filter condicion $ colectivos
  where
    limite = importeEnHuber desde hasta
    condicion colectivo = limite < importeEnColectivo desde hasta colectivo

importeEnColectivo :: Ubicacion -> Ubicacion -> Colectivo -> Number
importeEnColectivo desde hasta colectivo = (* 2) $ cantidadDeParadasEntre desde hasta (snd colectivo)

cantidadDeParadasEntre :: Ubicacion -> Ubicacion -> [Ubicacion] -> Number
cantidadDeParadasEntre desde hasta = length . tail . dropWhileEnd (/= hasta) . dropWhile (/= desde)

-- No se puede importar de Data.List ya que rompe el PdePreludat
dropWhileEnd condicion = reverse . dropWhile condicion . reverse

distanciaEntre :: Ubicacion -> Ubicacion -> [Ubicacion] -> Number
distanciaEntre desde hasta = (* 4) . cantidadDeParadasEntre desde hasta

puedeIrCaminando :: Persona -> Ubicacion -> Ubicacion -> Bool
puedeIrCaminando (Persona e tl de) desde hasta =
  distanciaEntre desde hasta ubicaciones < 20 || e < 35 && tl > 30

maximoSegun :: Ord a => (a -> a -> a) -> [a] -> a
maximoSegun = undefined

encuentroPosible :: (Persona, Ubicacion) -> (Persona, Ubicacion) -> Bool
encuentroPosible (persona1, ubicacion1) (persona2, ubicacion2) =
  puedeIrA ubicacion2 persona1 || puedeIrA ubicacion1 persona2
  where
    puedeIrA ubicacion persona = undefined -- TODO

funcionLoca a f m b = (m <) . head $ [uncurry b t | t <- zip a f]
