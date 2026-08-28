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
    show = showDeCircuito

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

-- 3 invertido

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

hayCaminoIluminado2 :: Circuito -> Bool
hayCaminoIluminado2 = recrCircuito (== on) 
                                   (\recc1 recc2 _ _ -> recc1 && recc2) 
                                   (\b1 recc1 recc2 b2 _ _ -> (b1 == on) && (b2 == on) && (recc1 || recc2))

-- 5: cantidadPrendidas

cantidadPrendidas :: Circuito -> Int
cantidadPrendidas = foldCircuito
    (\c -> if estaEncendida c then 1 else 0)
    (\c1 c2 -> c1 + c2)
    (\ca1 ci1 ci2 ca2 -> ci1 + ci2 + (prendidasEnParDeCajas ca1 ca2))

prendidasEnParDeCajas :: Caja -> Caja -> Int
prendidasEnParDeCajas c1 c2 = if estaEncendida c1 && estaEncendida c2 then 2
                        else if estaEncendida c1 && not (estaEncendida c2) then 1
                        else if not (estaEncendida c1) && estaEncendida c2 then 1
                        else 0

cantidadPrendidas2 :: Circuito -> Int 
cantidadPrendidas2 = foldCircuito flagPrendida
                                  (\c1 c2 -> c1 + c2) 
                                  (\b1 c1 c2 b2 -> flagPrendida b1 + c1 + c2 + flagPrendida b2)

flagPrendida :: Caja -> Int
flagPrendida caja = if caja == on then 1 else 0

-- 6: cajasDeCircuito

cajasDeCircuito :: Circuito -> [Caja]
cajasDeCircuito = foldCircuito
    (\c -> [c])
    (\c1 c2 -> c1 ++ c2)
    (\ca1 ci1 ci2 ca2 -> [ca1] ++ ci1 ++ ci2 ++ [ca2])

-- 7: esCircuitoProlijo

esCircuitoProlijo :: Circuito -> Bool
esCircuitoProlijo = recrCircuito (const True) 
                                 (\recc1 recc2 _ c2 -> not (esSerie c2) && recc1 && recc2) 
                                 (\_ recc1 recc2 _ _ _ -> recc1 && recc2)

esSerie :: Circuito -> Bool
esSerie c = case c of
        Serie _ _ -> True
        _ -> False

-- 8: circuitoEmprolijado

circuitoEmprolijado :: Circuito -> Circuito
circuitoEmprolijado = foldCircuito Caja 
                                   (\c1 c2 -> if not (esSerie c1) && esSerie c2 then Serie c2 c1 else Serie c1 c2)
                                   Paralelo

-- 9: tienenLaMismaEstructura 

tienenLaMismaEstructura :: Circuito -> Circuito -> Bool
tienenLaMismaEstructura = foldCircuito (\_ bc2 -> esCaja bc2) 
                                       (\rc11 rc12 cc2 -> case cc2 of
                                                        Serie rc21 rc22 -> (rc11 rc21) && (rc12 rc22)
                                                        _ -> False) 
                                       (\_ rc11 rc12 _ cc2 -> case cc2 of
                                                        Paralelo _ rc21 rc22 _ -> (rc11 rc21) && (rc12 rc22)
                                                        _ -> False) 

esCaja :: Circuito -> Bool
esCaja c = case c of
        Caja _ -> True
        _ -> False

circuito1Inv = Serie cajaOn (Paralelo on (Paralelo Nada cajaOff cajaOn Nada) (Paralelo on cajaOn cajaNada off) on)
circuito1 = Serie (Paralelo on (Paralelo off cajaNada cajaOn on) (Paralelo Nada cajaOn cajaOff Nada) on) cajaOn
circuito2 = Serie (Paralelo off (Paralelo on cajaNada cajaOn on) (Paralelo on cajaOn cajaOff on) on) cajaOn
circuito3 = Serie cajaOn (Paralelo off (Paralelo off cajaNada cajaOn off) (Paralelo off cajaOn cajaOff Nada) on)               
circuito4 = cajaOn
circuito5 = Serie cajaOn cajaOff       

-- 10: subCircuitoMásResistente

subCircuitoMásResistente = undefined -- TODO: COMPLETAR

