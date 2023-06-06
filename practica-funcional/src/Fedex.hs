-- | https://docs.google.com/document/d/1jMTZ7RZK8uarQoANiptBpARroUrmUSSIObDZb1PAV6g
module Fedex where

import PdePreludat

whatever :: Eq t => t -> (u -> t) -> (t -> [u] -> s) -> [u] -> s
whatever a b c = c a . filter ((a ==) . b)

data Envio = Envio
  { origen :: Locacion,
    destino :: Locacion,
    peso :: Number,
    precioBase :: Number,
    categorias :: [Categoria],
    impuestos :: [Impuesto]
  }
  deriving (Show, Eq)

data Locacion = Locacion
  { ciudad :: String,
    pais :: String
  }
  deriving (Show, Eq)

type Categoria = String

aplicarCargo condicion monto envio
  | condicion envio = envio {precioBase = precioBase envio + monto}
  | otherwise = envio

cargoCategorico :: Categoria -> Number -> Cargo
cargoCategorico categoria porcentaje = aplicarCargo (elem categoria . categorias) (porcentaje / 100)

cargoSobrepeso :: Number -> Cargo
cargoSobrepeso pesoLimite envio = aplicarCargo ((> pesoLimite) . peso) ((peso envio - pesoLimite) * 80) envio

-- 1a
type Cargo = Envio -> Envio

-- 1b
type Impuesto = Envio -> Number

-- 2a

cargoTecnologia :: Cargo
cargoTecnologia = cargoCategorico "tecnologia" 18
