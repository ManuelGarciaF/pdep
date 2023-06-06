module Currycoin where

import PdePreludat

-- 1a. --------------------------------------------------

type Id = String

data Cuenta = Cuenta
  { idCuenta :: !Id,
    saldo :: !Number
  }
  deriving (Show, Eq)

type Transaccion = Cuenta -> Cuenta

type Bloque = [(Id, Transaccion)]

-- 1b. --------------------------------------------------

transaccion :: Number -> Transaccion
transaccion numero cuenta = cuenta {saldo = saldo cuenta + numero}

pago, cobro :: Number -> Transaccion
pago = transaccion
cobro monto = transaccion (- monto)

mineria :: Transaccion
mineria = transaccion 25

-- 2a. --------------------------------------------------

correspondeId :: Id -> Cuenta -> Bool
correspondeId identificador = (identificador ==) . idCuenta

-- 2b. --------------------------------------------------

primeraQueCumple :: (Cuenta -> Bool) -> [Cuenta] -> Cuenta
primeraQueCumple condicion = head . filter condicion

-- 2c. --------------------------------------------------

sinLaPrimeraQueCumple :: (Cuenta -> Bool) -> [Cuenta] -> [Cuenta]
sinLaPrimeraQueCumple condicion cuentas =
  takeWhile (/= primera) cuentas ++ tail (dropWhile (/= primera) cuentas)
  where
    primera = primeraQueCumple condicion cuentas

-- 3. --------------------------------------------------

modificarCuenta :: Id -> [Cuenta] -> Transaccion -> [Cuenta]
modificarCuenta identificador cuentas trx =
  trx (primeraQueCumple esId cuentas) : sinLaPrimeraQueCumple esId cuentas
  where
    esId = correspondeId identificador

-- 4. --------------------------------------------------

afectar :: Bloque -> [Cuenta] -> [Cuenta]
afectar bloque cuentas = foldl aplicarTrx cuentas bloque
  where
    aplicarTrx cs (identificador, trx) = modificarCuenta identificador cs trx

-- 5. --------------------------------------------------

esEstable :: [Cuenta] -> Bool
esEstable = all ((> 0) . saldo)

-- 6. --------------------------------------------------

type Blockchain = [Bloque]

chequeo :: [Cuenta] -> Blockchain -> Bool
chequeo cuentas = all esEstable . foldr (\bloque estados -> afectar bloque (head estados) : estados) [cuentas]

chequeo' :: Blockchain -> [Cuenta] -> Bool
chequeo' [] cuentas = esEstable cuentas
chequeo' (bloque : bloques) cuentas = esEstable aplicados && chequeo' bloques aplicados
  where
    aplicados = afectar bloque cuentas
