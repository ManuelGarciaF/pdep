% enunciado https://docs.google.com/document/d/1-09GZDTEqFgjbnHIjVx7jgZtzMS-RljS11XHnufAejU
% Parcial Die-hard

% Punto 5

% estado(Chico, Grande) functor con la cantidad de litros en cada bidon

%accion/1
accion(llenarChico).
accion(llenarGrande).
accion(vaciarChico).
accion(vaciarGrande).
accion(ponerChicoEnGrande).
accion(ponerGrandeEnChico).

accion(llenarChico, estado(ChicoPrevio, Grande), estado(3, Grande)):-
    ChicoPrevio < 3.
accion(llenarGrande, estado(Chico, GrandePrevio), estado(Chico, 5)):-
    GrandePrevio < 5.
accion(vaciarChico, estado(ChicoPrevio, Grande), estado(0, Grande)):-
    ChicoPrevio > 0.
accion(vaciarGrande, estado(Chico, GrandePrevio), estado(Chico, 0)):-
    GrandePrevio > 0.
accion(ponerChicoEnGrande, estado(CPrev, GPrev), estado(CPost, GPost)):-
    CPrev > 0, GPrev < 5,
    GDispo is 5 - GPrev,
    Transferido is min(GDispo, CPrev),
    CPost is CPrev - Transferido,
    GPost is GPrev + Transferido.
accion(ponerGrandeEnChico, estado(CPrev, GPrev), estado(CPost, GPost)):-
    GPrev > 0, CPrev < 3,
    CDispo is 3 - CPrev,
    Transferido is min(CDispo, GPrev),
    GPost is GPrev - Transferido,
    CPost is CPrev + Transferido.

%cumpleObjetivo/2
cumpleObjetivo(estado(Objetivo, _), Objetivo).
cumpleObjetivo(estado(_, Objetivo), Objetivo).

%resolverBidones/3
resolverBidones(Objetivo, Tope, Acciones):-
    resolverBidones(Objetivo, Tope, Acciones, estado(0,0)).

%resolverBidones/4
resolverBidones(Objetivo, _, [], Estado):-
    cumpleObjetivo(Estado, Objetivo).
resolverBidones(Objetivo, Tope, [Accion | As], Estado):-
    not(cumpleObjetivo(Estado, Objetivo)),
    Tope > 0,
    accion(Accion),
    accion(Accion, Estado, EstadoPost),
    TopePost is Tope - 1,
    resolverBidones(Objetivo, TopePost, As, EstadoPost).
