:- module(popong, [color/1,mostrarMatriz/1,mostrarMatrizAlt/1]).

color(amarillo).
color(naranja).
color(rojo).
color(verde).
color(azul).
color(violeta).

ansiColor(libre, '\x1B[30m').
ansiColor(amarillo, '\x1B[33m').
ansiColor(naranja, '\x1B[38;5;208m').
ansiColor(rojo, '\x1B[31m').
ansiColor(verde, '\x1B[32m').
ansiColor(azul, '\x1B[34m').
ansiColor(violeta, '\x1B[35m').

ansiColorAlt(libre, '   ').
ansiColorAlt(amarillo, ' 1 ').
ansiColorAlt(naranja, ' 2 ').
ansiColorAlt(rojo, ' 3 ').
ansiColorAlt(verde, ' 4 ').
ansiColorAlt(azul, ' 5 ').
ansiColorAlt(violeta, ' 6 ').

reset('\x1B[39m\x1B[49m').

mostrarMatriz(M) :-
  [Fila|_] = M,
  length(Fila, N),
  borde(N, B),
  string_concat('╔', B, S1),
  string_concat(S1, '╗\n', S2),
  strMatriz(M, S3),
  string_concat(S2, S3, S4),
  string_concat(S4, '╚', S5),
  string_concat(S5, B, S6),
  string_concat(S6, '╝\n', S7),
  write(S7).

mostrarMatrizAlt(M) :-
  [Fila|_] = M,
  length(Fila, N),
  bordeAlt(N, B),
  string_concat('/', B, S1),
  string_concat(S1, '\\\n', S2),
  strMatrizAlt(M, S3),
  string_concat(S2, S3, S4),
  string_concat(S4, '\\', S5),
  string_concat(S5, B, S6),
  string_concat(S6, '/\n', S7),
  write(S7).

borde(0, '').
borde(N, S) :-
  N > 0,
  Nm1 is N - 1,
  borde(Nm1, S1),
  string_concat('══', S1, S).

bordeAlt(0, '').
bordeAlt(N, S) :-
  N > 0,
  Nm1 is N - 1,
  bordeAlt(Nm1, S1),
  string_concat('---', S1, S).

strMatriz([], '').
strMatriz([Fila|Resto], S) :-
  strLínea(Fila, S1),
  strMatriz(Resto, S2),
  string_concat(S1, S2, S).

strMatrizAlt([], '').
strMatrizAlt([Fila|Resto], S) :-
  strLíneaAlt(Fila, S1),
  strMatrizAlt(Resto, S2),
  string_concat(S1, S2, S).

strLínea(Fila, S) :-
  strFila(Fila, S1),
  string_concat('║', S1, S).

strLíneaAlt(Fila, S) :-
  strFilaAlt(Fila, S1),
  string_concat('|', S1, S).

strFila([], '║\n').
strFila([Color | Resto], S) :-
  ansiColor(Color, ColorCode),
  reset(Reset),
  string_concat(ColorCode, '██', S1),
  string_concat(S1, Reset, S2),
  strFila(Resto, S3),
  string_concat(S2, S3, S).

strFilaAlt([], '|\n').
strFilaAlt([Color | Resto], S) :-
  ansiColorAlt(Color, ColorCode),
  strFilaAlt(Resto, S3),
  string_concat(ColorCode, S3, S).