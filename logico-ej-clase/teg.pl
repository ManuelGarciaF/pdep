% Enunciado:

% estaEnContinente(Jugador,Continente)
estaEnContinente(Jugador, Continente):-
    paisContinente(Continente, Pais),
    ocupa(Pais, Jugador, _).

cantidadPaises(Jugador, Cantidad):-
    % Generar un valor para el jugador, esto unifica la variable con un jugador en
    % particular antes de pasarlo a la consulta del findall.
    objetivo(Jugador, _),
    findall(Pais, ocupa(Pais, Jugador, _), Paises),
    length(Paises, Cantidad).

ocupaContinente(Jugador, Continente):-
    estaEnContinente(Jugador, Continente),
    not((estaEnContinente(Jugador2, Continente), Jugador2 \= Jugador)).

ocupaContinente2(Jugador, Continente):-
    objetivo(Jugador, _), %Generamos para checkear un solo continente de un solo jugador
    continente(Continente),
    forall(paisContinente(Continente, Pais), ocupa(Pais, Jugador, _)).

leFaltaMucho(Jugador, Continente):-
    objetivo(Jugador),
    continente(Continente),
    findall(Pais, (paisContinente(Continente, Pais), not(ocupa(Pais, Jugador, _))), PaisesDelContinente),
    length(Paises, CantidadPaises),
    CantidadPaises > 2.
