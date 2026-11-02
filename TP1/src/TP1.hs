module TP1 where

data Caja = Bombilla Bool | Nada
              deriving Eq
instance Show Caja where
    show = showDeCaja

showDeCaja :: Caja -> String 
showDeCaja (Bombilla True) = "💡"
showDeCaja (Bombilla False) = "⚪️"
showDeCaja (Nada) = "🛑"

data Circuito = Caja     Caja
              | Serie    Circuito Circuito
              | Paralelo Caja Circuito Circuito Caja
                  deriving Eq
instance Show Circuito where
    show = showDeCircuitoConEstructura

showDeCircuito :: Circuito -> String
showDeCircuito (Caja caja) = showDeCaja caja
showDeCircuito (Serie circuitoInicial circuitoFinal) =
  (showDeCircuito circuitoInicial) ++ "-" ++ (showDeCircuito circuitoFinal)
showDeCircuito (Paralelo cajaEntrada circuitoIzquierdo circuitoDerecho cajaSalida) =
  (showDeCaja cajaEntrada) ++
  "{" ++ (showDeCircuito circuitoIzquierdo) ++ "}" ++
  "{" ++ (showDeCircuito circuitoDerecho) ++ "}" ++
  (showDeCaja cajaSalida)

showDeCircuitoConEstructura :: Circuito -> String
showDeCircuitoConEstructura (Caja caja) = showDeCaja caja
showDeCircuitoConEstructura (Serie circuitoInicial circuitoFinal) = "(" ++
  (showDeCircuitoConEstructura circuitoInicial) ++
    "-" ++
  (showDeCircuitoConEstructura circuitoFinal) ++ ")"
showDeCircuitoConEstructura (Paralelo cajaEntrada circuitoIzquierdo circuitoDerecho cajaSalida) =
  (showDeCaja cajaEntrada) ++
  "{" ++ (showDeCircuitoConEstructura circuitoIzquierdo) ++ "}" ++
  "{" ++ (showDeCircuitoConEstructura circuitoDerecho) ++ "}" ++
  (showDeCaja cajaSalida)

on  = Bombilla True
off = Bombilla False

cajaOn   = Caja on
cajaOff  = Caja off
cajaNada = Caja Nada

-- 1: recCircuito

recrCircuito :: (Caja -> b) -> (b -> b -> Circuito -> Circuito -> b) -> (Caja -> b -> b -> Caja -> Circuito -> Circuito -> b) -> Circuito -> b
recrCircuito casoCaja casoSerie casoParalelo c = case c of
    Caja x -> casoCaja x
    Serie c1 c2 -> casoSerie (rec c1) (rec c2) c1 c2
    Paralelo ca1 ci1 ci2 ca2 -> casoParalelo ca1 (rec ci1) (rec ci2) ca2 ci1 ci2
    where rec = recrCircuito casoCaja casoSerie casoParalelo

-- 2: foldCircuito

foldCircuito :: (Caja -> b) -> (b -> b -> b) -> (Caja -> b -> b -> Caja -> b) -> Circuito -> b
foldCircuito casoCaja casoSerie casoParalelo = recrCircuito
    casoCaja
    (\c1 c2 _ _ -> casoSerie c1 c2)
    (\ca1 ci1 ci2 ca2 _ _ -> casoParalelo ca1 ci1 ci2 ca2)

-- 3: invertido

invertido :: Circuito -> Circuito
invertido = foldCircuito
    Caja
    (\c1 c2 -> Serie c2 c1)
    (\ca1 ci1 ci2 ca2 -> Paralelo ca2 ci2 ci1 ca1)

-- 4: hayCaminoIluminado

hayCaminoIluminado :: Circuito -> Bool
hayCaminoIluminado = foldCircuito
    estaEncendida
    (\c1 c2 -> c1 && c2)
    (\ca1 ci1 ci2 ca2 -> estaEncendida ca1 && estaEncendida ca2 && (ci1 || ci2))

estaEncendida :: Caja -> Bool
estaEncendida c = case c of
    Bombilla True -> True
    _ -> False

-- 5: cantidadPrendidas

cantidadPrendidas :: Circuito -> Int
cantidadPrendidas = foldCircuito 
    flagCajaPrendida
    (\c1 c2 -> c1 + c2) 
    (\b1 c1 c2 b2 -> flagCajaPrendida b1 + c1 + c2 + flagCajaPrendida b2)

flagCajaPrendida :: Caja -> Int
flagCajaPrendida caja = if caja == on then 1 else 0

-- 6: cajasDeCircuito

cajasDeCircuito :: Circuito -> [Caja]
cajasDeCircuito = foldCircuito
    (\c -> [c])
    (\c1 c2 -> c1 ++ c2)
    (\ca1 ci1 ci2 ca2 -> [ca1] ++ ci1 ++ ci2 ++ [ca2])

-- 7: esCircuitoProlijo

esCircuitoProlijo :: Circuito -> Bool
esCircuitoProlijo = recrCircuito 
    (const True) 
    (\recc1 recc2 _ c2 -> not (esSerie c2) && recc1 && recc2) 
    (\_ recc1 recc2 _ _ _ -> recc1 && recc2)

esSerie :: Circuito -> Bool
esSerie c = case c of
        Serie _ _ -> True
        _ -> False

-- 8: circuitoEmprolijado

-- circuitoEmprolijado :: Circuito -> Circuito
-- circuitoEmprolijado = foldCircuito 
--     Caja 
--     (\c1 c2 -> if not (esSerie c1) && esSerie c2 then Serie c2 c1 else Serie c1 c2)
--     Paralelo

-- 9: tienenLaMismaEstructura

tienenLaMismaEstructura :: Circuito -> Circuito -> Bool
tienenLaMismaEstructura = foldCircuito 
    (\_ c2 -> esCaja c2)
    (\rcir1i rcir1d cir2 -> case cir2 of
                    Serie cir2i cir2d -> (rcir1i cir2i) && (rcir1d cir2d)
                    _ -> False)
    (\_ rcir1i rcir1d _ cir2 -> case cir2 of
                    Paralelo _ cir2i cir2d _ -> (rcir1i cir2i) && (rcir1d cir2d)
                    _ -> False)

esCaja :: Circuito -> Bool
esCaja c = case c of
        Caja _ -> True
        _ -> False

-- 10: subCircuitoMásResistente

subCircuitoMasResistente :: Circuito -> Circuito
subCircuitoMasResistente = recrCircuito 
    Caja
    (\recc1 recc2 c1 c2 -> circuitoMasResistente [Serie c1 c2, recc1, recc2])
    (\ca1 recc1 recc2 ca2 c1 c2 -> circuitoMasResistente [Paralelo ca1 c1 c2 ca2, recc1, recc2])

circuitoMasResistente :: [Circuito] -> Circuito
circuitoMasResistente = foldr1 (\c1 c2 -> if resistenciaCircuito c1 > resistenciaCircuito c2 then c1 else c2)


resistenciaCircuito :: Circuito -> Float
resistenciaCircuito (Caja b) =  case b of 
                        Bombilla True -> 1
                        Bombilla False -> 0
                        Nada -> 100
resistenciaCircuito (Serie c1 c2) = resistenciaCircuito c1 + resistenciaCircuito c2 
resistenciaCircuito (Paralelo ca1 c1 c2 ca2) = (resistenciaCircuito c1 + resistenciaCircuito c2 + 1) / 2