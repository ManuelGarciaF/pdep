module Carreras where

import PdePreludat

-- 1.

type Color = String

data Auto = Auto
  { color :: !Color,
    velocidad :: !Number,
    distancia :: !Number
  }
  deriving (Show, Eq)

type Carrera = [Auto]

estaCerca :: Auto -> Auto -> Bool
estaCerca a1 a2 = a1 /= a2 && distanciaEntre <= 10
  where
    distanciaEntre = abs (distancia a1 - distancia a2)

mayorSegun :: Ord b => (a -> b) -> a -> a -> a
mayorSegun f x y
  | f x > f y = x
  | otherwise = y

maximoSegun :: Ord b => (a -> b) -> [a] -> a
maximoSegun _ [] = undefined
maximoSegun f (x : xs) = foldl (mayorSegun f) x xs

vaTranquilo :: Auto -> Carrera -> Bool
vaTranquilo auto carrera = vaPrimero && not (any (estaCerca auto) carrera)
  where
    vaPrimero = auto == maximoSegun distancia carrera

puesto :: Auto -> Carrera -> Number
puesto auto = (+ 1) . length . filter ((> velocidad auto) . velocidad)

-- 2.

correr :: Number -> Auto -> Auto
correr tiempo auto =
  auto
    { distancia = distancia auto + velocidad auto * tiempo
    }

alterarVelocidad :: (Number -> Number) -> Auto -> Auto
alterarVelocidad modificador auto =
  auto
    { velocidad = modificador . velocidad $ auto
    }

bajarVelocidad :: Number -> Auto -> Auto
bajarVelocidad reduccion = alterarVelocidad (\actual -> max (actual - reduccion) 0)

-- 3.

type PowerUp = Auto -> Carrera -> Carrera

afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista =
  (map efecto . filter criterio) lista ++ filter (not . criterio) lista

terremoto :: PowerUp
terremoto auto = afectarALosQueCumplen (estaCerca auto) (bajarVelocidad 50)

miguelitos :: Number -> PowerUp
miguelitos reduccion auto carrera =
  afectarALosQueCumplen vaAtras (bajarVelocidad reduccion) carrera
  where
    vaAtras = (< puesto auto carrera) . flip puesto carrera

jetPack :: Number -> PowerUp
jetPack tiempo auto = afectarALosQueCumplen (== auto) efecto
  where
    efecto = alterarVelocidad (`div` 2) . correr tiempo . alterarVelocidad (* 2)

-- 4.

type Evento = Carrera -> Carrera

simularCarrera :: Carrera -> [Evento] -> [(Number, Color)]
simularCarrera inicial = generarPosiciones . foldl (flip ($)) inicial
  where
    generarPosiciones carrera = map (\auto -> (puesto auto carrera, color auto)) carrera

correnTodos :: Number -> Evento
correnTodos tiempo = map (correr tiempo)

usaPowerUp :: PowerUp -> Color -> Evento
usaPowerUp powerUp colorAfectado carrera = powerUp autoAfectado carrera
  where
    autoAfectado = head . filter ((== colorAfectado) . color) $ carrera

carreraEjemplo =
  simularCarrera
    [ Auto "Rojo" 120 0,
      Auto "Blanco" 120 0,
      Auto "Azul" 120 0,
      Auto "Negro" 120 0
    ]
    [ correnTodos 30,
      usaPowerUp (jetPack 3) "Azul",
      usaPowerUp terremoto "Blanco",
      correnTodos 40,
      usaPowerUp (miguelitos 20) "Blanco",
      usaPowerUp (jetPack 6) "Negro",
      correnTodos 10
    ]

-- 5.
{-
  a. Se podría, creando una funcion del tipo misil :: Color -> PowerUp
     que afecte solamente al auto que cumpla que su color es igual al objetivo.
     No habria que cambiar nada de los puntos anteriores.

  b. No, no se podría utilizar ya que ambas requieren recorrer la lista entera
     vaTranquilo cortaría solamente cuando existe un auto cerca del que se esta evaluando
     y puesto no cortaria nunca.

-}

-- 5a.
misilTeledirigido :: Color -> PowerUp
misilTeledirigido colorObjetivo _ =
  afectarALosQueCumplen ((== colorObjetivo) . color) (bajarVelocidad 1000)
