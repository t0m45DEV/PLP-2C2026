import Test.HUnit
import TP1

-- TESTS

testsInvertido :: Test
testsInvertido = TestList -- TODO: AGREGAR
  [ "Caja invertida (1)"
    ~: invertido cajaOn
    ~?= cajaOn
  , "Caja invertida (2)"
    ~: invertido cajaOff
    ~?= cajaOff
  , "Caja invertida (3)"
    ~: invertido cajaNada
    ~?= cajaNada
  , "Serie Invertida (1)"
    ~: invertido (Serie cajaOn cajaOff)
    ~?= Serie cajaOff cajaOn
  , "Serie Invertida (2)"
    ~: invertido (Serie cajaNada (Paralelo on cajaOff cajaOn off))
    ~?= Serie (Paralelo off cajaOn cajaOff on) cajaNada
  , "Serie Invertida (3)"
    ~: invertido (Serie (Serie cajaNada cajaOn) (Paralelo off cajaNada cajaNada on))
    ~?= Serie (Paralelo on cajaNada cajaNada off) (Serie cajaOn cajaNada)
  , "Paralelo Invertido (1)"
    ~: invertido (Paralelo off cajaNada cajaNada on)
    ~?= (Paralelo on cajaNada cajaNada off)
  , "Paralelo Invertido (2)"
    ~: invertido (Paralelo on (Serie cajaOn cajaOff) (Serie cajaOn cajaOff) off)
    ~?= Paralelo off (Serie cajaOff cajaOn) (Serie cajaOff cajaOn) on
  , "Paralelo Invertido (1)"
    ~: invertido (Paralelo off cajaNada cajaNada on)
    ~?= (Paralelo on cajaNada cajaNada off)
  , "Paralelo Invertido (3)"
    ~: invertido (Paralelo Nada (Paralelo off cajaNada cajaOn on) (Serie cajaOn cajaOff) off)
    ~?= Paralelo off (Serie cajaOff cajaOn) (Paralelo on cajaOn cajaNada off) Nada
  ]

testsHayCaminoIluminado :: Test
testsHayCaminoIluminado = TestList -- TODO: AGREGAR
  [ "En una caja con bombilla encendida hay camino iluminado"
    ~: hayCaminoIluminado cajaOn
    ~?= True
  , "En una caja con bombilla apagada no hay camino iluminado"
    ~: hayCaminoIluminado cajaOff
    ~?= False
  , "En una caja vacía no hay camino iluminado"
    ~: hayCaminoIluminado cajaNada
    ~?= False
  , "En un circuito en serie con dos cajas con bombillas encendidas hay camino iluminado"
    ~: hayCaminoIluminado (Serie cajaOn cajaOn)
    ~?= True
  , "En un circuito en serie con dos cajas con una bombilla encendida y otra apagada no hay camino iluminado"
    ~: hayCaminoIluminado (Serie cajaOn cajaOff)
    ~?= False
  , "En un circuito en paralelo con uno de los dos caminos iluminado hay camino iluminado"
    ~: hayCaminoIluminado (Paralelo on (Paralelo on cajaOn cajaOn on) (Serie cajaOff cajaOff) on)
    ~?= True
  , "En un circuito en paralelo con ningún camino iluminado no hay camino iluminado"
    ~: hayCaminoIluminado (Paralelo off (Paralelo on cajaNada cajaOn on) (Serie cajaOff cajaOff) on)
    ~?= False 
  , "En un circuito en paralelo con bombillas encendidas y cajas vacías no hay camino iluminado"
    ~: hayCaminoIluminado (Paralelo on (Paralelo on cajaNada cajaNada on) (Serie cajaNada cajaNada) on)
    ~?= False
  ]

testsCantidadPrendidas :: Test
testsCantidadPrendidas = TestList -- TODO: AGREGAR
  [ "Cantidad prendidas en caja prendida es 1"
    ~: cantidadPrendidas cajaOn
    ~?= 1
  , "Cantidad prendidas en caja apagada es 0"
    ~: cantidadPrendidas cajaOff
    ~?= 0
  , "Cantidad prendidas en caja vacía es 0"
    ~: cantidadPrendidas cajaNada
    ~?= 0
  , "Cantidad prendidas en circuito paralelo con todas las bombillas encendidas es 4"
    ~: cantidadPrendidas (Paralelo on cajaOn cajaOn on)
    ~?= 4
  , "Cantidad prendidas en circuito serie es 6"
    ~: cantidadPrendidas (Serie (Paralelo on (Paralelo off cajaNada cajaOn on) (Paralelo Nada cajaOn cajaOff Nada) on) cajaOn)
    ~?= 6
  , "Cantidad prendidas en circuito serie es 0"
    ~: cantidadPrendidas (Serie (Paralelo off (Paralelo off cajaNada cajaOff off) (Paralelo Nada cajaOff cajaOff Nada) off) cajaNada)
    ~?= 0
  ]

testsCajasDeCircuito :: Test
testsCajasDeCircuito = TestList -- TODO: AGREGAR
  [ "La lista de cajas de un circuito con una única caja es la lista con esa caja"
    ~: cajasDeCircuito cajaOn
    ~?= [on]
  , "La lista de cajas de un circuito en paralelo es"
    ~: cajasDeCircuito (Paralelo on cajaOn cajaOn on)
    ~?= [on, on, on, on]
  , "La lista de cajas de un circuito en serie es"
    ~: cajasDeCircuito (Serie cajaOn cajaOff)
    ~?= [on, off]
  , "La lista de cajas de un circuito en serie es"
    ~: cajasDeCircuito (Serie (Paralelo on (Paralelo off cajaNada cajaOn on) (Paralelo Nada cajaOn cajaOff Nada) on) cajaOn)
    ~?= [on, off, Nada, on, on, Nada, on, off, Nada, on, on]
  ]

testsEsCircuitoProlijo :: Test
testsEsCircuitoProlijo = TestList -- TODO: AGREGAR
  [ "Una caja es prolija"
    ~: esCircuitoProlijo cajaOn
    ~?= True
  , "Un circuito serie con el primer circuito siendo caja y el segundo serie no es prolijo"
    ~: esCircuitoProlijo (Serie cajaOn (Serie cajaNada cajaNada))
    ~?= False
  , "Un circuito serie con el primer circuito siendo serie y el segundo caja es prolijo"
    ~: esCircuitoProlijo (Serie (Serie cajaNada cajaNada) cajaOn) 
    ~?= True
  , "Un circuito paralelo sin ningún circuito serie es prolijo"
    ~: esCircuitoProlijo (Paralelo on cajaNada cajaOff on) 
    ~?= True
  , "Un circuito paralelo con circuito en serie desprolijo no es prolijo"
    ~: esCircuitoProlijo (Paralelo on (Serie cajaNada (Serie cajaOn cajaOn)) cajaOff on) 
    ~?= False
  ]

-- NOTA: para correr este test, cambiar la línea 18 del archivo tp1.hs de "show = showDeCircuito" a
  -- "show = showDeCircuitoConEstructura".
  -- De esa forma, podrán distinguir la estructura de los circuitos en serie.
testsCircuitoEmprolijado :: Test
testsCircuitoEmprolijado = TestList -- TODO: AGREGAR
  [ "La versión emprolijada de una caja es la misma caja"
    ~: circuitoEmprolijado cajaOn
    ~?= cajaOn
  ]

testsTienenLaMismaEstructura :: Test
testsTienenLaMismaEstructura = TestList -- TODO: AGREGAR
  [ "Un circuito paralelo con todas las bombillas encendidas tiene la misma estructura que ese circuito pero con las bombillas apagadas"
    ~: tienenLaMismaEstructura (Paralelo on cajaOn cajaOn on) (Paralelo off cajaOff cajaOff off)
    ~?= True
  , "Un circuito de una caja vacía tiene la misma estructura que un circuito de una caja con una bombilla encendida"
    ~: tienenLaMismaEstructura cajaNada cajaOn
    ~?= True
  , "Un circuito paralelo no tiene la misma estructura que un circuito en serie"
    ~: tienenLaMismaEstructura (Paralelo on cajaNada cajaOn on) (Serie cajaOff cajaOn)
    ~?= False
  , "Dos circuitos paralelos que no comparten la misma estructura"
    ~: tienenLaMismaEstructura (Paralelo on (Serie cajaOff cajaOn) cajaOn on) (Paralelo off cajaOff cajaOff off)
    ~?= False
  ]

testsSubCircuitoMásResistente :: Test
testsSubCircuitoMásResistente = TestList -- TODO: AGREGAR
  [ "El subcircuito más resistente de un circuito en paralelo con una caja vacía va a ser esa caja vacía"
    ~: subCircuitoMasResistente (Paralelo on (Serie cajaOff cajaNada) cajaOn on)
    ~?= cajaNada
  , "El subcircuito más resistente de un circuito en serie con todas las bombillas prendidas es ese circuito"
    ~: subCircuitoMasResistente (Serie (Serie (Serie cajaOn cajaOn) (Serie cajaOn cajaOn)) cajaOn)
    ~?= Serie (Serie (Serie cajaOn cajaOn) (Serie cajaOn cajaOn)) cajaOn
  , "El subcircuito más resistente de un circuito en paralelo con dos series es ese circuito en serie de dos series"
    ~: subCircuitoMasResistente (Paralelo off (Serie (Serie cajaOff cajaOn) (Serie cajaOn cajaOn)) cajaOff on)
    ~?= Serie (Serie cajaOff cajaOn) (Serie cajaOn cajaOn)
  ]

tests :: Test
tests = TestList
  [ TestLabel "invertido"                testsInvertido
  , TestLabel "hayCaminoIluminado"       testsHayCaminoIluminado
  , TestLabel "cantidadPrendidas"        testsCantidadPrendidas
  , TestLabel "cajasDeCircuito"          testsCajasDeCircuito
  , TestLabel "esCircuitoProlijo"        testsEsCircuitoProlijo
--  , TestLabel "circuitoEmprolijado"      testsCircuitoEmprolijado
  , TestLabel "tienenLaMismaEstructura"  testsTienenLaMismaEstructura
  , TestLabel "subCircuitoMásResistente" testsSubCircuitoMásResistente
  ]

main :: IO ()
main = runTestTT tests >>= print