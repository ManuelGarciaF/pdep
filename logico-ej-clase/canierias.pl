% Link https://docs.google.com/document/d/\1CuazQK1mmNwyagrYULvEmX3nciG5QVghNYPJZ3GF67w/edit

% precio/2
precio([pieza|piezas], Precio):-
    precio(Pieza, PrecioPieza),
    precio(Piezas, PrecioPiezas),
    Precio is PrecioPieza + PrecioPiezas.
precio([], 0).
precio(codo(_), 5).
precio(canio(_, Longitud),Precio):-
    Precio is 3 * Longitud.
precio(canilla(triangular,_,_), 20).
precio(canilla(Tipo, _, Ancho), 15):-
    Ancho > 5,
    Tipo \= triangular.
precio(canilla(Tipo, _, Ancho), 12):-
    Ancho =< 5,
    Tipo \= triangular.

% puedoEnchufar/2
puedoEnchufar(P1, P2):-
    color(P1, C1),
    color(P2, C2),
    coloresEnchufables(C1,C2).

puedoEnchufar(C, P2) :-
    last(C, P1),
    puedoEnchufar(P1,P2).
puedoEnchufar(P1, [P2|_]) :-
    puedoEnchufar(P1,P2).

% coloresEnchufables/2
coloresEnchufables(C,C).
coloresEnchufables(azul,rojo).
coloresEnchufables(rojo,negro).

% color/2
color(codo(C), C).
color(canio(C,_), C).
color(canilla(_,C,_), C).
