% Tests de Download
:- include(download).

:- begin_tests(titulo).

test("Relación de un libro con su titulo"):-
    titulo(libro(fundation, asimov, 3), fundation).

test("Relación de un disco con su titulo", fail):-
    titulo(musica(theLastHero, hardRock, alterBridge), theFirstHero).


:- end_tests(titulo).

:- begin_tests(descargaContenido).

test("Descarga de contenido de leo",
     set(Contenido = [
             serie(dark, [thriller, drama]),
             musica(powerslave, heavyMetal, ironMaiden)
         ])):-
    descargaContenido(leoOoOok, Contenido).

% Forma mas facil de testear multiples valores
test("Descarga de contenido de mati", nondet):-
    descargaContenido(mati1009, serie(strangerThings, [thriller, fantasia])),
    descargaContenido(mati1009, pelicula(infinityWar, accion, 2018)).

:- end_tests(descargaContenido).
