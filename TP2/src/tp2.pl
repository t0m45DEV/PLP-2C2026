:- use_module(popong).

% ----------------
% Ejercicio 1
% ----------------

% esMatriz(+ListaDeListas)
esMatriz(_) :- completar("Ejercicio 1").

% ----------------
% Ejercicio 2
% ----------------

% tamaño(+Matriz, -Filas, -Columnas)
% Precondición: esMatriz(Matriz)
tamaño(_, _, _) :- completar("Ejercicio 2").

% ----------------
% Ejercicio 3
% ----------------

% coordenadaEnRango(+Matriz, +Coordenada)
% Precondición: esMatriz(Matriz)
coordenadaEnRango(_, _) :- completar("Ejercicio 3").

% ----------------
% Observadores de tablero.
% ----------------

% valorEnCoordenada(+Tablero, ?Coordenada, ?Valor)
% Posibles usos:
% - (+T, +Coordenada, -V): Instancia en V el valor en las coordenadas Coordenada del tablero T.
% - (+T, -Coordenada, +V): Instancia en Coordenada todas las coordenadas del tablero T que tienen el valor V.
% - (+T, -Coordenada, -V): Instancia en Coordenada todas las coordenadas del tablero T y en V sus correspondientes valores.
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada).
valorEnCoordenada(T, (I,J), V) :-
  nth1(I, T, Fila),
  nth1(J, Fila, V).

% coordenada(+Tablero, -Coordenada)
% Instancia en Coordenada todas las coordenadas del tablero Tablero.
% Precondición: esMatriz(Tablero).
coordenada(T, Coordenada) :-
  valorEnCoordenada(T, Coordenada, _).

% libre(+Tablero, ?Coordenada)
% Instancia en Coordenada todas las coordenadas libres del tablero Tablero (o verifica si la coordenada Coordenada está libre en Tablero).
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada).
libre(T, Coordenada) :-
  valorEnCoordenada(T, Coordenada, libre).

% color(+Tablero, +Color, ?Coordenada)
% Instancia en Coordenada todas las coordenadas del tablero Tablero que tienen el color Color (o verifica si la coordenada Coordenada tiene color Color en Tablero).
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada).
color(T, Color, Coordenada) :-
  color(Color),
  valorEnCoordenada(T, Coordenada, Color).

% ----------------
% Ejercicio 4.a)
% ----------------

% tableroConPosiciónLiberada(+Tablero, +Coordenada, -TableroLiberado)
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, Coordenada), not(libre(Tablero, Coordenada)).
tableroConPosiciónLiberada(_, _, _) :- completar("Ejercicio 4.a").

% ----------------
% Ejercicio 4.b)
% ----------------

% tableroConPosicionesLiberadas(+Tablero, +Posiciones, -TableroLiberado)
% Precondición: esMatriz(Tablero).
% Precondición: para cada Coordenada en Posiciones: coordenadaEnRango(Tablero, Coordenada), not(libre(Tablero, Coordenada)).
tableroConPosicionesLiberadas(_, _, _) :- completar("Ejercicio 4.b").

% ----------------
% Operaciones sobre coordenadas.
% ----------------

% dirección(?Dirección)
% Instacia en Dirección todas las posibles direcciones (o verifica que Dirección sea una dirección).
dirección(norte).
dirección(este).
dirección(sur).
dirección(oeste).

% direcciones(-Direcciones)
% Instancia en Direcciones una lista con todas las direcciones.
direcciones([norte, este, sur, oeste]).

% vecinaEnDir(+Coordenada, ?Dirección, -Vecina)
% Instancia en Vecina la coordenada vecina a Coordenada en la dirección Dirección (o instancia cada par dirección-vecina en Dirección y Vecina, respectivamente).
vecinaEnDir((I,J), norte, (I2, J)) :- I2 is I-1.
vecinaEnDir((I,J), este, (I, J2)) :- J2 is J+1.
vecinaEnDir((I,J), sur, (I2, J)) :- I2 is I+1.
vecinaEnDir((I,J), oeste, (I, J2)) :- J2 is J-1.

% hayOcupadaAl(+Tablero, +(I, J), +Dirección)
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)).
hayOcupadaAl(T, (I, J), D) :-
  vecinaEnDir((I, J), D, V),
  coordenadaEnRango(T, V),
  color(T, _, V).
hayOcupadaAl(T, (I, J), D) :-
  vecinaEnDir((I, J), D, V),
  coordenadaEnRango(T, V),
  libre(T, V),
  hayOcupadaAl(T, V, D).

% ocupadaEnLíneaRectaAl(+Tablero, +(I, J), +Dirección, -Ocupada)
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)), hayOcupadaAl(Tablero, (I, J), Dirección).
ocupadaEnLíneaRectaAl(T, (I, J), D, O) :-
  vecinaEnDir((I, J), D, O),
  color(T, _, O).
ocupadaEnLíneaRectaAl(T, (I, J), D, O) :-
  vecinaEnDir((I, J), D, V),
  libre(T, V),
  ocupadaEnLíneaRectaAl(T, V, D, O).

% ocupadasEnLíneaRecta(+Tablero, +(I, J), -PosicionesOcupadas)
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)).
ocupadasEnLíneaRecta(T, (I, J), Ocupadas) :-
  direcciones(Direcciones),
  ocupadasPorDirecciones(T, (I, J), Direcciones, Ocupadas).

% ocupadasPorDirecciones(+Tablero, +(I, J), +Direcciones, -PosicionesOcupadas)
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)).
ocupadasPorDirecciones(_, _, [], []).
ocupadasPorDirecciones(T, (I, J), [D|Ds], [O|Os]) :-
  hayOcupadaAl(T, (I, J), D),
  ocupadaEnLíneaRectaAl(T, (I, J), D, O),
  ocupadasPorDirecciones(T, (I, J), Ds, Os).
ocupadasPorDirecciones(T, (I, J), [D|Ds], Os) :-
  not(hayOcupadaAl(T, (I, J), D)),
  ocupadasPorDirecciones(T, (I, J), Ds, Os).

% ----------------
% Obtención de los colores predominantes desde una coordenada.
% ----------------

% coloresPredominantes(+Tablero, +(I, J), -Colores, -Coordenadas)
% Instancia en Colores la lista con los colores que son predominantes en el tablero Tablero desde la coordenada (I,J), y en Coordenadas las coordenadas correspondientes a dichos colores..
% Precondición: esMatriz(Tablero), coordenadaEnRango(Tablero, (I,J)), libre(Tablero, (I, J)).
coloresPredominantes(T, (I, J), ColoresPredominantes, Coordenadas) :-
  ocupadasEnLíneaRecta(T, (I, J), Os),
  posicionesAColores(T, Os, ColoresOcupadas),
  soloPredominantesEn(ColoresOcupadas, ColoresOcupadas, Os, ColoresPredominantes, Coordenadas).

% posicionesAColores(+Tablero, +Posiciones, -Colores)
% Instancia en Colores los colores de las coordenadas Posiciones en el tablero Tablero.
% Precondición: esMatriz(Tablero).
% Precondición: para cada Coordenada en Posiciones: coordenadaEnRango(Tablero, Coordenada), not(libre(Tablero, Coordenada)).
posicionesAColores(_, [], []).
posicionesAColores(T, [P | Ps], [C | Cs]) :-
  color(T, C, P),
  posicionesAColores(T, Ps, Cs).

% soloPredominantesEn(+ColoresOcupadasCompleta, +ColoresOcupadasRestantes, +CoordenadasOcupadas, -ColoresPredominantes, -CoordenadasPredominantes).
% Instancia en ColoresPredominantes los colores de la lista ColoresOcupadasRestantes que son predominantes en ColoresOcupadasCompleta.
soloPredominantesEn(_, [], [], [], []).
soloPredominantesEn(COC, [CO | COs], [Cr | Crs], CPs, [Cr | Coord]) :-
  soloPredominantesEn(COC, COs, Crs, CPs, Coord),
  member(CO, CPs).
soloPredominantesEn(COC, [CO | COs], [Cr | Crs], [CO | CPs], [Cr | Coord]) :-
  soloPredominantesEn(COC, COs, Crs, CPs, Coord),
  not(member(CO, CPs)),
  esPredominante(CO, COC).
soloPredominantesEn(COC, [CO | COs], [_ | Crs], CPs, Coord) :-
  soloPredominantesEn(COC, COs, Crs, CPs, Coord),
  not(member(CO, CPs)),
  not(esPredominante(CO, COC)).

% esPredominante(+Color, +Colores)
% Indica si el color Color es predominante en Colores.
esPredominante(C, Cs) :-
  cantApariciones(C, Cs, K),
  not(hayColorConMásPresencia(Cs, K, Cs)), !.

% cantApariciones(+Elemento, +Lista, -Cantidad)
% Instancia en Cantidad la cantidad de veces que aparece el elemento Elemento en la lista Lista.
cantApariciones(_, [], 0).
cantApariciones(X, [X|Xs], N) :-
  cantApariciones(X, Xs, N2),
  N is N2 + 1.
cantApariciones(X, [Y|Xs], N) :-
  X \= Y,
  cantApariciones(X, Xs, N).

% hayColorConMásPresencia(+ListaCompleta, +Cantidad, +ListaRestante)
% Indica si hay algún color de la lista ListaRestante que aparezca en ListaCompleta más de Cantidad veces.
hayColorConMásPresencia([C|_], K, CC) :-
  cantApariciones(C, CC, K2), K2 > K.
hayColorConMásPresencia([_|Cs], K, CC) :-
  hayColorConMásPresencia(Cs, K, CC).

% jugadaPosible(+Tablero, ?Jugada)
% Precondición: esMatriz(Tablero).
% Tiene éxito si la posición Jugada tiene colores vecinos repetidos
jugadaPosible(T, (I, J)) :-
  libre(T, (I, J)),
  ocupadasEnLíneaRecta(T, (I, J), Os),
  posicionesAColores(T, Os, Cs),
  not(is_set(Cs)).

% ----------------
% Ejercicio 5.a)
% ----------------

% jugarPosición(+TableroInicial, +Coordenada, -TableroResultante)
% Precondición: esMatriz(TableroInicial), coordenadaEnRango(TableroInicial, Coordenada), libre(TableroInicial, Coordenada).
jugarPosición(_, _, _) :- completar("Ejercicio 5.a").

% ----------------
% Ejercicio 5.b)
% ----------------

% jugarPosiciones(+TableroInicial, +Jugadas, -TableroResultante)
% Precondición: esMatriz(TableroInicial).
% Precondición: para cada Coordenada en Jugadas: coordenadaEnRango(TableroInicial, Coordenada).
jugarPosiciones(_, _, _) :- completar("Ejercicio 5.b").

% jugarNaive(+TableroInicial, -TableroFinal)
% Precondición: esMatriz(TableroInicial).
jugarNaive(T, T) :-
  not(jugadaPosible(T, _)).
jugarNaive(T, TF) :-
  jugadaPosible(T, J),
  jugarPosición(T, J, TI),
  jugarNaive(TI, TF).

% ----------------
% Ejercicio 6.b)
% ----------------

% jugadasNaive(+Tablero, -Jugadas)
% Precondición: esMatriz(Tablero).
jugadasNaive(_, _) :- completar("Ejercicio 6.b").

% ----------------
% Ejercicio 7.a)
% ----------------

% victoriaConJugadas(+Tablero, +Jugadas).
% Precondición: esMatriz(Tablero).
% Precondición: para cada Coordenada en Jugadas: coordenadaEnRango(Tablero, Coordenada).
victoriaConJugadas(_, _) :- completar("Ejercicio 7.a").

% ----------------
% Ejercicio 7.b)
% ----------------

% juegoNaiveVictorioso(+Tablero, -Jugadas)
% Precondición: esMatriz(Tablero).
juegoNaiveVictorioso(_, _) :- completar("Ejercicio 7.b").

% ----------------
% Ejercicio 7.c)
% ----------------

% mejorJuegoNaive(+Tablero, -Jugadas)
% Precondición: esMatriz(Tablero).
mejorJuegoNaive(_, _) :- completar("Ejercicio 7.c").

% ----------------
% Ejercicio 8 - OPCIONAL
% ----------------

% tableroEnElQueNaiveGanaEmpezandoPor(-Tablero, +Coordenada)
tableroEnElQueNaiveGanaEmpezandoPor(_, _) :- completar("Ejercicio 8").

% ----------------
% Interfaz gráfica
% ----------------

% guiTablero(+Tablero)
%% NOTA: Si no funciona, usar en su lugar mostrarMatrizAlt.
guiTablero(T) :- mostrarMatriz(T), !.

% guiJugada(+Tablero1, +Coordenada, +Tablero2)
guiJugada(T1, J, T2) :- guiTablero(T1), write(J), write('\n'), guiTablero(T2).

% guiJugadas(+Tablero, +Jugadas)
guiJuego(T, Js) :- guiTablero(T), guiParesJugadasTableros(T, Js).

% guiParesJugadasTableros(+Tablero, +Jugadas)
guiParesJugadasTableros(_, []).
guiParesJugadasTableros(T, [J | Js]) :-
  write(J), write('\n'),
  jugarPosición(T, J, T2),
  guiTablero(T2),
  guiParesJugadasTableros(T2, Js).

% ----------------
% Tableros de ejemplo
% ----------------

% tablero(+N, -T)
tablero(1, [
  [rojo,  libre, azul,  rojo],
  [azul,  libre, azul,  rojo],
  [verde, rojo,  azul,  verde],
  [libre, libre, libre, rojo]
]).
tablero(2, [
  [libre, libre, libre, libre],
  [libre, libre, libre, libre],
  [verde, libre, libre, verde],
  [libre, libre, libre, libre]
]).
tablero(3, [
  [libre, libre, libre, libre],
  [libre, libre, libre, libre],
  [libre, libre, libre, libre],
  [libre, libre, libre, libre]
]).

% Indica que se debe completar el predicado. Siempre falla.
completar(S) :- write("COMPLETAR: "), write(S), nl, fail.
