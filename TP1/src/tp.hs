
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

