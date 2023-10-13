% Enunciado: https://docs.google.com/document/d/1a8RMmT8wsOAsPunOmL_Rgdg-eSBBoB2VJ_AqexdzcgY/edit

/* Functores
% jugadores
jugador(Nombre, PuntosVida, PuntosMana, CartasMazo, CartasMano, CartasCampo)

% cartas
criatura(Nombre, PuntosDanio, PuntosVida, CostoMana)
hechizo(Nombre, FunctorEfecto, CostoMana)

% efectos
danio(CantidadDanio)
cura(CantidadCura)
*/

nombre(jugador(Nombre,_,_,_,_,_), Nombre).
nombre(criatura(Nombre,_,_,_), Nombre).
nombre(hechizo(Nombre,_,_), Nombre).

vida(jugador(_,Vida,_,_,_,_), Vida).
vida(criatura(_,_,Vida,_), Vida).
vida(hechizo(_,curar(Vida),_), Vida).

danio(criatura(_,Danio,_), Danio).
danio(hechizo(_,danio(Danio),_), Danio).

mana(jugador(_,_,Mana,_,_,_), Mana).
mana(criatura(_,_,_,Mana), Mana).
mana(hechizo(_,_,Mana), Mana).

cartasMazo(jugador(_,_,_,Cartas,_,_), Cartas).
cartasMano(jugador(_,_,_,_,Cartas,_), Cartas).
cartasCampo(jugador(_,_,_,_,_,Cartas), Cartas).

% Jugadores de ejemplo
jugador(jugador(juan,
                20,
                0,
                [criatura(criatura1, 1, 1, 1), criatura(criatura2, 2, 2, 2), criatura(criatura3, 3, 3, 3)],
                [hechizo(hechizo1, danio(1), 1), hechizo(hechizo2, danio(2), 2), hechizo(hechizo3, danio(3), 3)],
                [criatura(criatura4, 4, 4, 4), criatura(criatura5, 5, 5, 5), criatura(criatura6, 6, 6, 6)]
)).
jugador(jugador(pedro,
                20,
                40,
                [criatura(criatura1, 1, 1, 1), criatura(criatura2, 2, 2, 2), criatura(criatura3, 3, 3, 3)],
                [], []
)).

% 1.
cartaDeJugador(Jugador, Carta):-
    cartasMazo(Jugador, Cartas),
    member(Carta, Cartas).
cartaDeJugador(Jugador, Carta):-
    cartasMano(Jugador, Cartas),
    member(Carta, Cartas).
cartaDeJugador(Jugador, Carta):-
    cartasCampo(Jugador, Cartas),
    member(Carta, Cartas).

% 2.
esGuerrero(Jugador):-
    jugador(Jugador),
    not(cartaDeJugador(Jugador, hechizo(_,_,_))).

% 3.
empezarTurno(
    jugador(Nombre, Vida, Mana, [Carta|MazoNuevo], Mano, Campo),
    jugador(Nombre, Vida, ManaNuevo, MazoNuevo, [Carta|Mano], Campo)):-
    jugador(jugador(Nombre, Vida, Mana, [Carta|MazoNuevo], Mano, Campo)),
    ManaNuevo is Mana + 1.

% 4.
puedeJugarCarta(Jugador, Carta):-
    cartaDeJugador(Jugador, Carta),
    mana(Jugador, Mana),
    mana(Carta, Costo),
    Mana >= Costo.

cartaJugableProximoTurno(Jugador, Carta):-
    empezarTurno(Jugador, JugadorNuevo),
    puedeJugarCarta(JugadorNuevo, Carta).

% 5.
jugadaPosible(_, []).
jugadaPosible(Jugador, [Carta|Cartas]):-
    mana(Jugador, Mana),
    cartasMano(Jugador, Mano),
    member(Carta, Mano),
    mana(Carta, Costo),
    Costo =< Mana,
    delete(Mano, Carta, ManoSinCarta),
    ManaRestante is Mana - Costo,
    jugadaPosible(jugador(_, _, ManaRestante, _, ManoSinCarta, _), Cartas).

% 6.
cartaMasDaniina(Jugador, Carta):-
    jugador(Jugador),
    cartasMano(Jugador, Mano),
    member(Carta, Mano),
    danio(Carta, Danio),
    not((member(Carta2, Mano), danio(Carta2, Danio2), Danio2 > Danio)).

% 7.
jugarContra(hechizo(_, danio(Danio), _),
            jugador(Nombre, Vida, Mana, Mazo, Mano, Campo),
            jugador(Nombre, VidaNueva, Mana, Mazo, Mano, Campo)):-
    VidaNueva is Vida - Danio.

jugar(Carta, JugadorAntes, JugadorDespues):-
    consumirCarta(Carta, JugadorAntes, JugadorSinCarta),
    aplicarEfecto(Carta, JugadorSinCarta, JugadorDespues).

consumirCarta(Carta,
              jugador(Nombre, Vida, Mana, Mazo, Mano, Campo),
              jugador(Nombre, Vida, ManaNuevo, Mazo, ManoNueva, Campo)):-
    delete(Mano, Carta, ManoNueva),
    mana(Carta, Costo),
    ManaNuevo is Mana - Costo.

aplicarEfecto(hechizo(_, cura(Cantidad), _),
              jugador(Nombre, Vida, Mana, Mazo, Mano, Campo),
              jugador(Nombre, VidaNueva, Mana, Mazo, Mano, Campo)):-
    VidaNueva is Vida + Cantidad.
aplicarEfecto(criatura(Nombre, Danio, Vida, Costo),
              jugador(Nombre, Vida, Mana, Mazo, Mano, Campo),
              jugador(Nombre, Vida, Mana, Mazo, Mano, [criatura(Nombre, Danio, Vida, Costo)|Campo])).
