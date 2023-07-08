/* distintos paises */
paisContinente(americaDelSur, argentina).
paisContinente(americaDelSur, bolivia).
paisContinente(americaDelSur, brasil).
paisContinente(americaDelSur, chile).
paisContinente(americaDelSur, ecuador).
paisContinente(europa, alemania).
paisContinente(europa, espania).
paisContinente(europa, francia).
paisContinente(europa, inglaterra).
paisContinente(asia, aral).
paisContinente(asia, china).
paisContinente(asia, gobi).
paisContinente(asia, india).
paisContinente(asia, iran).

/*países importantes*/
paisImportante(argentina).
paisImportante(kamchatka).
paisImportante(alemania).

/*países limítrofes*/
limitrofes([argentina,brasil]).
limitrofes([bolivia,brasil]).
limitrofes([bolivia,argentina]).
limitrofes([argentina,chile]).
limitrofes([espania,francia]).
limitrofes([alemania,francia]).
limitrofes([nepal,india]).
limitrofes([china,india]).
limitrofes([nepal,china]).
limitrofes([afganistan,china]).
limitrofes([iran,afganistan]).

/*distribucion en el tablero */
ocupa(argentina, azul, 4).
ocupa(bolivia, rojo, 1).
ocupa(brasil, verde, 4).
ocupa(chile, negro, 3).
ocupa(ecuador, rojo, 2).
ocupa(alemania, azul, 3).
ocupa(espania, azul, 1).
ocupa(francia, azul, 1).
ocupa(inglaterra, azul, 2).
ocupa(aral, negro, 2).
ocupa(china, verde, 1).
ocupa(gobi, verde, 2).
ocupa(india, rojo, 3).
ocupa(iran, verde, 1).

ocupa(Pais, Jugador):- ocupa(Pais, Jugador, _).

/*continentes*/
continente(americaDelSur).
continente(europa).
continente(asia).

/*objetivos*/
objetivo(rojo, ocuparContinente(asia)).
objetivo(azul, ocuparPaises([argentina, bolivia, francia, inglaterra, china])).
objetivo(verde, destruirJugador(rojo)).
objetivo(negro, ocuparContinente(europa)).

jugador(Jugador):-
    objetivo(Jugador, _).

% estaEnContinente(Jugador,Continente)
estaEnContinente(Jugador, Continente):-
    paisContinente(Continente, Pais),
    ocupa(Pais, Jugador, _).

cantidadPaises(Jugador, Cantidad):-
    % Generar un valor para el jugador, esto unifica la variable con un jugador en
    % particular antes de pasarlo a la consulta del findall.
    jugador(Jugador),
    findall(Pais, ocupa(Pais, Jugador, _), Paises),
    length(Paises, Cantidad).

ocupaContinente(Jugador, Continente):-
    estaEnContinente(Jugador, Continente),
    not((estaEnContinente(Jugador2, Continente), Jugador2 \= Jugador)).

ocupaContinente2(Jugador, Continente):-
    % Generamos para checkear un solo continente de un solo jugador
    jugador(Jugador),
    continente(Continente),
    forall(paisContinente(Continente, Pais), ocupa(Pais, Jugador)).

leFaltaMucho(Jugador, Continente):-
    jugador(Jugador),
    continente(Continente),
    findall(Pais, (paisContinente(Continente, Pais), not(ocupa(Pais, Jugador))), PaisesDelContinente),
    length(PaisesDelContinente, CantidadPaises),
    CantidadPaises > 2.

sonLimitrofes(Pais1, Pais2):-
    limitrofes(Paises),
    member(Pais1, Paises),
    member(Pais2, Paises),
    Pais1 \= Pais2.

esGroso(Jugador):-
    jugador(Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador)).
esGroso(Jugador):-
    cantidadPaises(Jugador, Cantidad),
    Cantidad > 10.
esGroso(Jugador):- % Complicandola para demostrar el uso de maplist
    jugador(Jugador),
    findall(Pais, ocupa(Pais, Jugador), Paises),
    maplist(ejercitosEn, Paises, Cantidades),
    sum_list(Cantidades, Total),
    Total > 50.

ejercitosEn(Pais, Cantidad):-
    ocupa(Pais, _, Cantidad).

estaEnElHorno(Pais):-
    ocupa(Pais, Jugador),
    jugador(Jugador2),
    Jugador \= Jugador2,
    forall(sonLimitrofes(Pais,Limitrofe), ocupa(Limitrofe, Jugador2)).

ganadooor(Jugador):-
    objetivo(Jugador, Objetivo),
    cumpleObjetivo(Jugador, Objetivo).

cumpleObjetivo(Jugador, ocuparContinente(Continente)):-
    ocupaContinente(Jugador, Continente).
cumpleObjetivo(Jugador, ocuparPaises(Paises)):-
    forall(member(Pais, Paises), ocupa(Pais, Jugador)).
cumpleObjetivo(Jugador, destruirJugador(JugadorADestruir)):-
    not(ocupa(_, JugadorADestruir)).
