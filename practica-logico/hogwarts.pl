% https://docs.google.com/document/d/e/2PACX-1vR9SBhz2J3lmqcMXOBs1BzSt7N1YWPoIuubAmQxPIOcnbn5Ow9REYt4NXQzOwXXiUaEQ4hfHNEt3_C7/pub

% Parte 1
% mago(nombre, sangre, caracteristicas, casaOdiada)
mago(harry, mestizo, [corajudo, amistoso, orgullozo, inteligente], slytherin).
mago(draco, pura, [inteligente, orgulloso], hufflepuff).
mago(hermione, impura, [inteligente, orgulloso, responsable], ninguna).

% criterios(casa, caracteristicas)
criterios(gryffindor, [corajudo]).
criterios(slytherin, [orgulloso, inteligente]).
criterios(ravenclaw, [inteligente, responsable]).
criterios(hufflepuff, [amistoso]).

casa(Casa):- criterios(Casa, _).

% 1.
permiteEntrar(slytherin, Nombre):-
    mago(Nombre, Sangre, _, _),
    Sangre \= impura.
permiteEntrar(gryffindor, _).
permiteEntrar(ravenclaw, _).
permiteEntrar(hufflepuff, _).

% 2.
caracterApropiado(Nombre, Casa):-
    mago(Nombre, _, Caracteristicas, _),
    criterios(Casa, Criterios),
    forall(
        member(Caracteristica, Criterios),
        member(Caracteristica, Caracteristicas)
    ).

% 3.
casaPosible(Nombre, Casa):-
    mago(Nombre, _, _, Odiada),
    permiteEntrar(Casa, Nombre),
    caracterApropiado(Nombre, Casa),
    Casa \= Odiada.
casaPosible(hermione, gryffindor).

% 4.
esDe(hermione, gryffindor).
esDe(ron, gryffindor).
esDe(harry, gryffindor).
esDe(draco, slytherin).
esDe(luna, ravenclaw).

% accion(nombre, accion)
accion(harry, andarFueraDeCama).
accion(hermione, irALugarProhibido(tercerPiso)).
accion(hermione, irALugarProhibido(seccionBiblioteca)).
accion(ron, buenaAccion(ganarAjedrez, 50)).
accion(hermione, buenaAccion(salvarAmigos, 50)).
accion(harry, buenaAccion(ganarAVoldemort, 60)).

accion(hermione, responderPregunta(dondeSeEncuentraUnBezoar, 20, snape)).
accion(hermione, responderPregunta(comoLevitarUnaPluma, 25, flitwick)).

% lugarProhibido(nombre, puntos)
lugarProhibido(bosque, -50).
lugarProhibido(seccionBiblioteca, -10).
lugarProhibido(tercerPiso, -75).

valorAccion(andarFueraDeCama, -50).
valorAccion(irALugarProhibido(Lugar), Valor):- lugarProhibido(Lugar, Valor).
valorAccion(buenaAccion(_, Valor), Valor).
valorAccion(responderPregunta(_, Dificultad, Profesor), Dificultad):- Profesor \= snape.
valorAccion(responderPregunta(_, Dificultad, snape), Valor):- Valor is Dificultad / 2.

% 1.
buenAlumno(Nombre):-
    esDe(Nombre, _),
    not(cometioMalasAcciones(Nombre)).

cometioMalasAcciones(Nombre):- accion(Nombre, andarFueraDeCama).
cometioMalasAcciones(Nombre):- accion(Nombre, irALugarProhibido(_)).

accionRecurrente(Accion):-
    accion(Mago1, Accion),
    accion(Mago2, Accion),
    Mago1 \= Mago2.

% 2.
puntajeTotalCasa(Casa, Puntaje):-
    casa(Casa),
    findall(PuntajeIndividual,
           (esDe(Alumno, Casa), puntajeTotalAlumno(Alumno, PuntajeIndividual)),
           Puntajes),
    sum_list(Puntajes, Puntaje).

puntajeTotalAlumno(Nombre, Puntaje):-
    esDe(Nombre, _),
    findall(Accion, accion(Nombre, Accion), Acciones),
    maplist(valorAccion, Acciones, Valores),
    sum_list(Valores, Puntaje).

% 3.
casaGanadora(Casa):-
    puntajeTotalCasa(Casa, Puntaje),
    not((puntajeTotalCasa(_, OtroPuntaje), OtroPuntaje > Puntaje)).
