% 1.

% puestoDeComida(alimento, precio)
puestoDeComida(hamburguesa, 2000).
puestoDeComida(pancho, 1500).
puestoDeComida(lomito, 2500).
puestoDeComida(caramelos, 0).

atraccion(paraTodaLaFamilia(autitosChocadores)).
atraccion(paraTodaLaFamilia(casaEmbrujada)).
atraccion(paraTodaLaFamilia(laberinto)).

atraccion(paraChicos(tobogan)).
atraccion(paraChicos(calesita)).

atraccion(intensa(barcoPirata, 14)).
atraccion(intensa(tazasChinas, 6)).
atraccion(intensa(simulador3D, 2)).

% montaniaRusa(nombre, girosInvertidos, tiempoEnSegundos)
atraccion(montaniaRusa(abismoMortalRecargada, 3, 134)).
atraccion(montaniaRusa(paseoPorElParque, 0, 45)).

atraccion(acuatica(torpedoSalpicon)).
atraccion(acuatica(esperoQueHayasTraidoUnaMudaDeRopa)).

atraccion(Nombre, paraTodaLaFamilia(Nombre)):- atraccion(paraTodaLaFamilia(Nombre)).
atraccion(Nombre, paraChicos(Nombre)):- atraccion(paraChicos(Nombre)).
atraccion(Nombre, intensa(Nombre, CoeficienteDeLanzamiento)):- atraccion(intensa(Nombre, CoeficienteDeLanzamiento)).
atraccion(Nombre, montaniaRusa(Nombre, Giros, Tiempo)):- atraccion(montaniaRusa(Nombre, Giros, Tiempo)).
atraccion(Nombre, acuatica(Nombre)):- atraccion(acuatica(Nombre)).

% visitante(nombre, dinero, edad, grupo, hambre, aburrimiento)
visitante(eusebio, 3000, 80, viejitos, 50, 0).
visitante(carmela, 0, 80, viejitos, 0, 25).

esMenor(Nombre):-
    visitante(Nombre, _, Edad, _, _, _),
    Edad < 13.
esMayor(Nombre):-
    visitante(Nombre, _, Edad, _, _, _),
    Edad >= 13.

% 2.
atributosEntre(Nombre, Minimo, Maximo):-
    visitante(Nombre, _, _, _, Hambre, Aburrimiento),
    Total is Hambre + Aburrimiento,
    between(Minimo, Maximo, Total).

estadoDeBienestar(Nombre, felicidadPlena):-
    visitante(Nombre, _, _, Grupo, 0, 0),
    Grupo \= solo.
estadoDeBienestar(Nombre, podriaEstarMejor):-
    visitante(Nombre, _, _, solo, 0, 0).
estadoDeBienestar(Nombre, podriaEstarMejor):- atributosEntre(Nombre, 1, 50).
estadoDeBienestar(Nombre, necesitaEntretenerse):- atributosEntre(Nombre, 51, 99).
estadoDeBienestar(Nombre, seQuiereIr):-
    visitante(Nombre, _, _, _, Hambre, Aburrimiento),
    Total is Hambre + Aburrimiento,
    Total > 100.

% 3.

llena(hamburguesa, Nombre):-
    visitante(Nombre, _, _, _, Hambre, _),
    Hambre < 50.
llena(pancho, Nombre):- esMenor(Nombre).
llena(lomito, _).
llena(caramelo, Nombre):-
    visitante(Nombre, Dinero, _, _, _, _),
    forall(puestoDeComida(_, Precio), Precio > Dinero).

puedeSatisfacerse(Grupo, Comida):-
    puestoDeComida(Comida, Precio),
    forall(
        visitante(Nombre, Dinero, _, Grupo, _, _),
        (llena(Comida, Nombre), Precio =< Dinero)
    ).

% 4.
atraccionPeligrosa(Atraccion, Nombre):-
    esMayor(Nombre),
    not(estadoDeBienestar(Nombre, necesitaEntretenerse)),
    atraccion(Atraccion, montaniaRusa(_, Giros)),
    not((atraccion(montaniaRusa(_, Giros2)), Giros2 > Giros)).
atraccionPeligrosa(Atraccion, Nombre):-
    esMenor(Nombre),
    atraccion(montaniaRusa(Atraccion, _, Tiempo)),
    Tiempo > 60.

lluviaDeHamburguesas(Persona, Atraccion):-
    visitante(Persona, Dinero, _, _, _, _),
    puestoDeComida(hamburguesa, Precio),
    Precio =< Dinero,
    atraccionPeligrosa(Atraccion, Persona).

% 5.

puestosDisponibles(Dinero, Puestos):-
    findall(Puesto, (puestoDeComida(Puesto, Precio), Precio =< Dinero), Puestos).

atraccionesIntensas(Atracciones):-
    findall(Atraccion, atraccion(intensa(Atraccion, _)), Atracciones).

atraccionesTranquilas(Nombre, Atracciones):-
    esMenor(Nombre),
    findall(Atraccion, atraccion(paraChicos(Atraccion, _)), ParaChicos),
    findall(Atraccion, atraccion(paraTodaLaFamilia(Atraccion, _)), ParaTodaLaFamilia),
    append(ParaChicos, ParaTodaLaFamilia, Atracciones).
atraccionesTranquilas(Nombre, Atracciones):-
    esMayor(Nombre),
    findall(Atraccion, atraccion(paraTodaLaFamilia(Atraccion, _)), Atracciones).

montaniasNoPeligrosas(Persona, Montanias):-
    findall(
        Montania,
        (atraccion(montaniaRusa(Montania, _, _)), not(atraccionPeligrosa(Montania, Persona))),
        Montanias
    ).

atraccionesAcuaticasAbiertas(Mes):- Mes >= 9.
atraccionesAcuaticasAbiertas(Mes):- Mes =< 3.

atraccionesAcuaticas(Mes, []):- not(atraccionesAcuaticasAbiertas(Mes)).
atraccionesAcuaticas(Mes, Acuaticas):-
    atraccionesAcuaticasAbiertas(Mes),
    findall(Atraccion, atraccion(acuatica(Atraccion)), Acuaticas).

opcionesDeEntretenimiento(Persona, Mes, Opciones):-
    visitante(Persona, Dinero, _, _, _, _),
    puestosDisponibles(Dinero, Puestos),
    atraccionesIntensas(Intensas),
    atraccionesTranquilas(Persona, Tranquilas),
    montaniasNoPeligrosas(Persona, Montanias),
    atraccionesAcuaticas(Mes, Acuaticas),
    append([Puestos, Intensas, Tranquilas, Montanias, Acuaticas], Opciones).
