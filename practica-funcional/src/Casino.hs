-- https://docs.google.com/document/d/1DFcRQqRKeE2yGUqfQD9YVum4GMPS0L3roYL42nTExUw/edit

module Casino where

import PdePreludat

type Carta = (Number, String)

palos = ["Corazones", "Picas", "Tréboles", "Diamantes"]

valores = [(par, 1), (pierna, 2), (color, 3), (fullHouse, 4), (poker, 5), (otro, 0)]

type Mano = [Carta]

data Jugador = Jugador
  { nombre :: String,
    mano :: Mano,
    bebida :: String
  }
  deriving (Show)

type Mesa = [Jugador]

mayoresQue7 :: Mano -> Mano
mayoresQue7 = filter $ (> 7) . fst

bebidasFavoritas :: [Jugador] -> [String]
bebidasFavoritas = map bebida

jugadoresQueTomanGin :: [Jugador] -> [String]
jugadoresQueTomanGin = map nombre . filter ((== "Gin Tonic") . bebida)

maximoSegun :: (a -> Number) -> [a] -> a
maximoSegun f = foldl1 mayorSegun
  where
    mayorSegun x y
      | f x > f y = x
      | otherwise = y

ocurrenciasDe :: Eq a => a -> [a] -> Number
ocurrenciasDe x = length . filter (== x)

sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x : xs) = x : sinRepetidos (filter (/= x) xs)

esoNoSeVale :: Carta -> Bool
esoNoSeVale = not . esoSeVale

esoSeVale :: Carta -> Bool
esoSeVale (n, p) = n `elem` [1 .. 13] && p `elem` palos

manoNegra :: Jugador -> Bool
manoNegra (Jugador _ m _) = ((/= 5) . length $ m) || any esoNoSeVale m

numero :: Carta -> Number
numero = fst

palo :: Carta -> String
palo = snd

manoN :: Number -> Mano -> Bool
manoN n cartas = any (\num -> ocurrenciasDe num numeros == n) numeros
  where
    numeros = map numero cartas

par :: Mano -> Bool
par = manoN 2

pierna :: Mano -> Bool
pierna = manoN 3

color :: Mano -> Bool
color [] = True
color (carta : cartas) = all ((== palo carta) . palo) cartas

poker :: Mano -> Bool
poker = manoN 4

fullHouse :: Mano -> Bool
fullHouse cartas = par cartas && pierna cartas

fullHouse' = flip all [par, pierna] . flip ($)

otro :: Mano -> Bool
otro _ = True

alguienSeCarteo :: Mesa -> Bool
alguienSeCarteo mesa = cartas /= sinRepetidos cartas
  where
    cartas = concatMap mano mesa

valor :: Mano -> Number
valor cartas = snd . maximoSegun snd . filter (($ cartas) . fst) $ valores

bebidaWinner :: Mesa -> String
bebidaWinner = bebida . maximoSegun (valor . mano) . filter (not . manoNegra)

-- 6
-- a

ordenar :: (a -> a -> Bool) -> [a] -> [a]
ordenar _ [] = []
ordenar criterio (x : xs) = aplica not ++ [x] ++ aplica id
  where
    aplica param = ordenar criterio (filter (param . criterio x) xs)

escalera :: Mano -> Bool
escalera cartas = numerosOrdenados == [primer .. primer + 4]
  where
    numerosOrdenados = ordenar (<) . map numero $ cartas
    primer = head numerosOrdenados

escaleraDeColor :: Mano -> Bool
escaleraDeColor cartas = escalera cartas && color cartas
