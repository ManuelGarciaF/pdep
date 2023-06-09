-- Enunciado: https://github.com/pdep-sm/2021-simulacro-funcional

module CaidaMercados where

import PdePreludat

data Accion = Accion
  { simbolo :: String,
    precios :: [Number]
  }
  deriving (Show, Eq)

-- 1.

data Usuario = Usuario
  { cartera :: Number,
    accionesUsuario :: [TituloAccion]
  }
  deriving (Show, Eq)

data TituloAccion = TituloAccion
  { simboloTitulo :: String,
    cantidad :: Number,
    precioDeCompra :: Number
  }
  deriving (Show, Eq)

-- 2.

-- La transformacion tiene que ser (a->a) ya que la lista tambien contendra elementos sin transformar
mapCondicional :: (a -> Bool) -> (a -> a) -> [a] -> [a]
mapCondicional cond trans = map transformarCondicionalmente
  where
    transformarCondicionalmente x
      | cond x = trans x
      | otherwise = x

encontrar :: (a -> Bool) -> [a] -> a
encontrar cond = head . filter cond

cuantasTieneDe :: String -> Usuario -> Number
cuantasTieneDe simb = sum . map cantidad . filter ((== simb) . simboloTitulo) . accionesUsuario

-- 3.

nuevoPrecioAccion :: Number -> Accion -> Accion
nuevoPrecioAccion nuevoPrecio accion =
  accion
    { precios = nuevoPrecio : precios accion
    }

nuevoPrecio :: [Accion] -> String -> Number -> [Accion]
nuevoPrecio acciones objetivo nuevoPrecio =
  mapCondicional ((== objetivo) . simbolo) (nuevoPrecioAccion nuevoPrecio) acciones

precioActual :: Accion -> Number
precioActual = head . precios

-- 4.

estadoActual :: Usuario -> [Accion] -> Number
estadoActual usuario acciones = sum . map calcularDiferencia . accionesUsuario $ usuario
  where
    calcularDiferencia titulo = (precioAccionCorrespondiente titulo - precioDeCompra titulo) * cantidad titulo
    precioAccionCorrespondiente titulo = precioActual . encontrar ((== simboloTitulo titulo) . simbolo) $ acciones

-- 5.

pagarDividendos :: [Usuario] -> String -> Number -> [Usuario]
pagarDividendos usuarios simboloAccion dividendo = map agregarDividendo usuarios
  where
    agregarDividendo usuario =
      usuario
        { cartera = cartera usuario + dividendo * cuantasTieneDe simboloAccion usuario
        }

-- 6.

rescateFinanciero :: [Accion] -> [Usuario] -> [Usuario]
rescateFinanciero acciones = mapCondicional ((< -50000) . flip estadoActual acciones) regalar
  where
    regalar usuario = usuario {cartera = cartera usuario + 1000}

-- 7.

venta :: Usuario -> Accion -> Number -> Usuario
venta usuario accion cant =
  usuario
    { cartera = cartera usuario + (precioActual accion * cant),
      accionesUsuario = accionesActualizadas
    }
  where
    tituloAccion = encontrar ((== simbolo accion) . simboloTitulo) (accionesUsuario usuario)
    accionesActualizadas = tituloAccion {cantidad = cantidad tituloAccion - cant} : filter (/= tituloAccion) (accionesUsuario usuario)

-- No resuelve el caso en el que vende todas sus acciones de ese tipo, pues quedaria un titulo con cantidad 0

-- 8.
-- Es solamente volver a implementar maximoSegun
