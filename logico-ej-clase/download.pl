% Enunciado: https://docs.google.com/document/d/1HjOAYRvidHism1CVkZEVbKJsV1AbzT55a85MSUCmV3w/edit
% Parcial descargas

% libro(título, autor, edición)
recurso(amazingzone, host1, 0.1, libro(lordOfTheRings, jrrTolkien, 4)).
recurso(g00gle, ggle1, 0.04, libro(fundation, asimov, 3)).
recurso(g00gle, ggle1, 0.015, libro(estudioEnEscarlata, conanDoyle, 3)).

% musica(título, género, banda/artista)
recurso(spotify, spot1, 0.3, musica(theLastHero, hardRock, alterBridge)).
recurso(pandora, pand1, 0.3, musica(burn, hardRock, deepPurple)).
recurso(spotify, spot1, 0.3, musica(2, hardRock, blackCountryCommunion)).
recurso(spotify, spot2, 0.233, musica(squareUp, kpop, blackPink)).
recurso(pandora, pand1, 0.21, musica(exAct, kpop, exo)).
recurso(pandora, pand1, 0.28, musica(powerslave, heavyMetal, ironMaiden)).
recurso(spotify, spot4, 0.18, musica(whiteWind, kpop, mamamoo)).
recurso(spotify, spot2, 0.203, musica(shatterMe, dubstep, lindseyStirling)).
recurso(spotify, spot4, 0.22, musica(redMoon, kpop, mamamoo)).
recurso(g00gle, ggle1, 0.31, musica(braveNewWorld, heavyMetal, ironMaiden)).
recurso(pandora, pand1, 0.212, musica(loveYourself, kpop, bts)).
recurso(spotify, spot2, 0.1999, musica(aloneInTheCity, kpop, dreamcatcher)).

% serie(título, géneros)
recurso(netflix, netf1, 30, serie(strangerThings, [thriller, fantasia])).
recurso(fox, fox2, 500, serie(xfiles, [scifi])).
recurso(netflix, netf2, 50, serie(dark, [thriller, drama])).
recurso(fox, fox3, 127, serie(theMentalist, [drama, misterio])).
recurso(amazon, amz1, 12, serie(goodOmens, [comedia,scifi])).
recurso(netflix, netf1, 810, serie(doctorWho, [scifi, drama])).

% pelicula(título, género, año)
recurso(netflix, netf1, 2, pelicula(veronica, terror, 2017)).
recurso(netflix, netf1, 3, pelicula(infinityWar, accion, 2018)).
recurso(netflix, netf1, 3, pelicula(spidermanFarFromHome, accion, 2019)).

% descarga(usuario, contenido)
descarga(mati1009, strangerThings).
descarga(mati1009, infinityWar).
descarga(leoOoOok, dark).
descarga(leoOoOok, powerslave).

% 1.
recurso(Contenido):-
    recurso(_, _, _, Contenido).


titulo(Contenido, Titulo):-
    recurso(Contenido),
    tituloContenido(Contenido, Titulo).

tituloContenido(libro(T,_,_), T).
tituloContenido(musica(T,_,_), T).
tituloContenido(serie(T,_), T).
tituloContenido(pelicula(T,_,_), T).

descargaContenido(Usuario, Contenido):-
    descarga(Usuario, Titulo),
    titulo(Contenido, Titulo).

% 2.
contenidoPopular(Contenido):-
    recurso(Contenido),
    findall(Usuario, descargaContenido(Usuario, Contenido), Usuarios),
    length(Usuarios, Cantidad),
    Cantidad > 10.

% 3.
usuario(Usuario):-
    distinct(Usuario, descarga(Usuario, _)).
cinefilo(Usuario):-
    usuario(Usuario),
    forall(descargaContenido(Usuario, Contenido), esAudioVisual(Contenido)).

% No importa que no sea inversible
esAudioVisual(serie(_,_)).
esAudioVisual(pelicula(_,_,_)).

% 4.
totalDescargado(Usuario, Total):-
    usuario(Usuario),
    findall(Peso, (descargaContenido(Usuario, Contenido), peso(Contenido, Peso)), Pesos),
    sum_list(Pesos, Total).


peso(Contenido, Peso):-
    recurso(_,_,Peso,Contenido).

% 5.

usuarioCool(Usuario):-
    usuario(Usuario),
    forall(descargaContenido(Usuario,Contenido),esContenidoCool(Contenido)).

esContenidoCool(musica(_, kpop, _)).
esContenidoCool(musica(_, hardRock, _)).
esContenidoCool(serie(_, [_,_|_])).
esContenidoCool(pelicula(_, _, Anio)):- Anio < 2010.

% 6.

empresaHeterogenea(Empresa):-
    recurso(Empresa, _, _, C1),
    recurso(Empresa, _, _, C2),
    tipoContenido(C1, T1),
    tipoContenido(C2, T2),
    T1 \= T2.

tipoContenido(Contenido, Tipo):-
    Contenido =.. [Tipo|_].

% 7.

empresaServidor(Empresa,Servidor):-
    distinct(Servidor, recurso(Empresa, Servidor, _, _)).

cargaServidor(Empresa, Servidor, Carga):-
    empresaServidor(Empresa, Servidor),
    findall(Peso, recurso(Empresa, Servidor, Peso, _), Pesos),
    sum_list(Pesos, Carga).

tieneMuchaCarga(Empresa, Servidor):-
    cargaServidor(Empresa, Servidor, Carga),
    Carga > 1000.

servidorMasLiviano(Empresa, Servidor):-
    cargaServidor(Empresa, Servidor, Carga),
    not(tieneMuchaCarga(Empresa, Servidor)),
    not((cargaServidor(Empresa, _, OtraCarga), OtraCarga < Carga)).

balancearServidor(Empresa, ServidorCargado, ServidorLiviano):-
    tieneMuchaCarga(Empresa, ServidorCargado),
    servidorMasLiviano(Empresa, ServidorMasLiviano).
