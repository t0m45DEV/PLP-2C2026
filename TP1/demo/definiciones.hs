 alternado :: Circuito -> Circuito
 alternado (Caja caja) = Caja (cajaAlternada caja)                                       -- {AC}
 alternado (Serie ci cf) = Serie (alternado ci) (alternado cf)                           -- {AS}
 alternado (Paralelo ce ci cd cs) =
    Paralelo (cajaAlternada ce) (alternado ci) (alternado cd) (cajaAlternada cs)         -- {AP}

 cajaAlternada :: Caja -> Caja
 cajaAlternada Nada = Nada                                                               -- {CAN}
 cajaAlternada Bombilla booleano = Bombilla not booleano                                 -- {CAB}

 (.) :: (b -> c) -> (a -> b) -> a -> c
 (f . f) x = f (f x)                                                                     -- {C}

 id :: a -> a
 id x = x                                                                                -- {I}

 not :: Bool -> Bool
 not True = False                                                                        -- {NT}
 not False = True                                                                        -- {NF}


