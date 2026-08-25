
data Caja = Bombilla Bool | Nada
            deriving Eq

data Circuito = Caja    Caja
                | Serie Circuito Circuito
                | Paralelo Caja Circuito Circuito Caja
                deriving Eq

on = Bombilla True
off = Bombilla False

cajaOn = Caja on
cajaOff = Caja off
cajaNada = Caja Nada

ejemplo = Serie
            cajaOn
            ( Paralelo
                on
                (Paralelo Nada cajaOff cajaOn Nada)
                (Paralelo on cajaOn cajaNada off)
                on
            )

-- Ejercicio 1
recrCircuito :: (Caja -> b) -> (b -> b -> Circuito -> Circuito -> b) -> (Caja -> b -> b -> Caja -> Circuito -> Circuito -> b) -> Circuito -> b
recrCircuito casoCaja casoSerie casoParalelo c = case c of
    Caja x -> casoCaja x
    Serie c1 c2 -> casoSerie (rec c1) (rec c2) c1 c2
    Paralelo ca1 ci1 ci2 ca2 -> casoParalelo ca1 (rec ci1) (rec ci2) ca2 ci1 ci2
    where rec = recrCircuito casoCaja casoSerie casoParalelo

-- Ejercicio 2
foldCircuito :: (Caja -> b) -> (b -> b -> b) -> (Caja -> b -> b -> Caja -> b) -> Circuito -> b
foldCircuito casoCaja casoSerie casoParalelo = recrCircuito
    casoCaja
    (\c1 c2 _ _ -> casoSerie c1 c2)
    (\ca1 ci1 ci2 ca2 _ _ -> casoParalelo ca1 ci1 ci2 ca2)

-- Ejercicio 3
invertido :: Circuito -> Circuito
invertido = foldCircuito
    Caja
    (\c1 c2 -> Serie c2 c1)
    (\ca1 ci1 ci2 ca2 -> Paralelo ca2 ci2 ci1 ca1)

