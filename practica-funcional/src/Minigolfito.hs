-- Enunciado: https://docs.google.com/document/d/1LeWBI6pg_7uNFN_yzS2DVuVHvD0M6PTlG1yK0lCvQVE

module Minigolfito where

import PdePreludat
import System.Environment (getEnvironment)

-- Modelo inicial
data Jugador = UnJugador
  { nombre :: !String,
    padre :: !String,
    habilidad :: !Habilidad
  }
  deriving (Eq, Show)

data Habilidad = Habilidad
  { fuerzaJugador :: !Number,
    precisionJugador :: !Number
  }
  deriving (Eq, Show)

-- Jugadores de ejemplo
bart = UnJugador "Bart" "Homero" (Habilidad 25 60)

todd = UnJugador "Todd" "Ned" (Habilidad 15 80)

rafa = UnJugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = UnTiro
  { velocidad :: !Number,
    precision :: !Number,
    altura :: !Number
  }
  deriving (Eq, Show)

type Puntos = Number

-- Funciones útiles
between n m x = x `elem` [n .. m]

maximoSegun f = foldl1 (mayorSegun f)

mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- 1.

type Palo = Habilidad -> Tiro

putter :: Palo
putter (Habilidad fuerza precision) = UnTiro 10 (precision * 2) 0

madera :: Palo
madera (Habilidad fuerza precision) = UnTiro 100 (precision `div` 2) 5

hierro :: Number -> Palo
hierro n (Habilidad fuerza precision) = UnTiro (fuerza * n) (precision `div` n) (n -3)

palos :: [Palo]
palos = [putter, madera] ++ map hierro [1 .. 10]

-- 2.

golpe :: Jugador -> Palo -> Tiro
golpe (UnJugador _ _ habilidad) palo = palo habilidad

-- 3.

type Obstaculo = Tiro -> Tiro

tiroDetenido :: Tiro
tiroDetenido = UnTiro 0 0 0

obstaculoSuperableSi :: (Tiro -> Bool) -> (Tiro -> Tiro) -> Obstaculo
obstaculoSuperableSi condicion efecto tiro
  | condicion tiro = efecto tiro
  | otherwise = tiroDetenido

tunelConRampita :: Obstaculo
tunelConRampita = obstaculoSuperableSi superaTunel efectoTunel
  where
    superaTunel tiro = precision tiro > 90 && altura tiro == 0
    efectoTunel tiro = tiro {velocidad = velocidad tiro * 2, precision = 100}

laguna :: Number -> Obstaculo
laguna largo = obstaculoSuperableSi superaLaguna efectoLaguna
  where
    superaLaguna tiro = velocidad tiro > 80 && altura tiro `elem` [1 .. 5]
    efectoLaguna tiro = tiro {altura = altura tiro `div` largo}

hoyo :: Obstaculo
hoyo = obstaculoSuperableSi superaHoyo efectoHoyo
  where
    superaHoyo tiro = between 2 50 . velocidad $ tiro
    efectoHoyo _ = tiroDetenido

-- 4.

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter ((/= tiroDetenido) . obstaculo . golpe jugador) palos

cuantosSupera :: Tiro -> [Obstaculo] -> Number
cuantosSupera tiro = length . takeWhile (/= tiroDetenido) . foldl (\tiros obs -> tiros ++ [obs $ last tiros]) [tiro]

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip cuantosSupera obstaculos . golpe jugador) palos
