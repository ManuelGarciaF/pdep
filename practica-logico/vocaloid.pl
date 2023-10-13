% https://docs.google.com/document/d/1xbXPZnhwyK5FSHR_oaXU4esfkTd2S-jf3rH1XLw864M/edit

% canta(nombre, cancion, duracion)
canta(megurineLuka, cancion(nightFever, 4)).
canta(megurineLuka, cancion(foreverYoung, 5)).
canta(hatsuneMiku,  cancion(tellYourWorld, 4)).
canta(gumi,         cancion(foreverYoung, 4)).
canta(gumi,         cancion(tellYourWorld, 5)).
canta(seeU,         cancion(novemberRain, 6)).
canta(seeU,         cancion(nightFever, 5)).

vocaloid(Nombre):- canta(Nombre, _).

% 1.
esNovedoso(Nombre):-
    sabeAlMenosDosCanciones(Nombre),
    duracionTotal(Nombre, Tiempo),
    Tiempo < 15.

sabeAlMenosDosCanciones(Nombre):-
    canta(Nombre, Cancion1),
    canta(Nombre, Cancion2),
    Cancion1 \= Cancion2.

duracionTotal(Nombre, Minutos):-
    vocaloid(Nombre),
    findall(Duracion, canta(Nombre, cancion(_, Duracion)), Duraciones),
    sum_list(Duraciones, Minutos).

% 2.
esAcelerado(Nombre):-
    vocaloid(Nombre),
    not((canta(Nombre, cancion(_, Duracion)), Duracion > 4)).

%% Conciertos

% 1.
% concierto(nombre, pais, fama, tipo)
% tipos:
%   gigante(cancionesMinimas, duracionMinima)
%   mediano(duracionTotalMaxima)
%   pequenio(duracionMinima)
concierto(mikuExpo, eeuu, 2000, gigante(2, 6)).
concierto(magicalMirai, japon, 3000, gigante(3, 10)).
concierto(vocalektVisions, eeuu, 1000, mediano(9)).
concierto(mikuFest, argentina, 100, pequenio(4)).

concierto(Nombre):- concierto(Nombre, _, _, _).

% 2.
puedeParticipar(Nombre, Concierto):-
    vocaloid(Nombre),
    concierto(Concierto, _, _, Tipo),
    cumpleRestricciones(Nombre, Tipo).
puedeParticipar(hatsuneMiku, Concierto):- concierto(Concierto).

cumpleRestricciones(Nombre, gigante(CancionesMin, DuracionMin)):-
    cancionesTotales(Nombre, Canciones),
    Canciones > CancionesMin,
    duracionTotal(Nombre, Duracion),
    Duracion > DuracionMin.
cumpleRestricciones(Nombre, mediano(DuracionMax)):-
    duracionTotal(Nombre, Duracion),
    Duracion < DuracionMax.
cumpleRestricciones(Nombre, pequenio(DuracionMin)):-
    canta(Nombre, cancion(_, Duracion)),
    Duracion > DuracionMin.

cancionesTotales(Nombre, Numero):-
    findall(Cancion, canta(Nombre, cancion(Cancion, _)), Canciones),
    length(Canciones, Numero).

% 3.
masFamoso(Nombre):-
    fama(Nombre, Fama),
    not((fama(_, FamaDeOtro), FamaDeOtro > Fama)).

fama(Nombre, Total):-
    vocaloid(Nombre),
    findall(
        Fama,
        (puedeParticipar(Nombre, Concierto), concierto(Concierto, _, Fama, _)),
        Famas
    ),
    sum_list(Famas, Total).

% 4.
conoceDirectamente(megurineLuka, hatsuneMiku).
conoceDirectamente(megurineLuka, gumi).
conoceDirectamente(gumi, seeU).
conoceDirectamente(seeU, kaito).
conoce(Vocaloid1, Vocaloid2):- conoceDirectamente(Vocaloid1, Vocaloid2).
conoce(Vocaloid1, Vocaloid3):-
    conoceDirectamente(Vocaloid1, Vocaloid2),
    conoce(Vocaloid2, Vocaloid3).

participaSolo(Nombre, Concierto):-
    puedeParticipar(Nombre, Concierto),
    not((conoce(Nombre, Conocido), puedeParticipar(Conocido, Concierto))).

% 5.
/* En la solución planteada habría que agregar una claúsula en el predicado
cumpleRequisitos/2  que tenga en cuenta el nuevo functor con sus respectivos requisitos

El concepto que facilita los cambios para el nuevo requerimiento es el polimorfismo,
que nos permite dar un tratamiento en particular a cada uno de los conciertos en la
cabeza de la cláusula.
*/
