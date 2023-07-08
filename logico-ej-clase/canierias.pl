% Link https://docs.google.com/document/d/\1CuazQK1mmNwyagrYULvEmX3nciG5QVghNYPJZ3GF67w/edit

% precio/2
precio([Pieza|Piezas], Precio):-
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
    P1 \= extremo(derecho,_),
    P2 \= extremo(izquierdo,_),
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
color(extremo(_, C), C).

% canieriaBienArmada/1
canieriaBienArmada([Pieza]):-
    color(Pieza, _).
canieriaBienArmada([Canieria]):-
    canieriaBienArmada(Canieria).
canieriaBienArmada([CanieriaOPieza|CanieriasOPiezas]):-
    puedoEnchufar(CanieriaOPieza,CanieriasOPiezas), % Acomplamiento minimo
    canieriaBienArmada([CanieriaOPieza]),
    canieriaBienArmada(CanieriasOPiezas).

% canieriaLegal/2
canieriaLegal(Piezas, Canieria):-
    permutation(Piezas, Canieria),
    canieriaBienArmada(Canieria).

% Implementacion casera de permutation
permutation([],[]).
permutation(Lista1, [H|T]):-
    select(H, Lista1, Resto), % El primer elemento de la permutacion esta en la lista
    permutation(Resto, T).    % El resto de los elementos estan en el resto de la permutacion
