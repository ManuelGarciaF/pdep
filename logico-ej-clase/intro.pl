% implementa/2 lenguaje con paradigma
implementa(haskell, funcional).
implementa(cpp, imperativo).
implementa(cpp, objetos).
implementa(python, imperativo).
implementa(python, objetos).

% lenguajeProgramacion/1 cuando implementa al menos 1 paradigma
lenguajeProgramacion(Lenguaje):-
    implementa(Lenguaje, _).

% lenguaje/1
lenguaje(Lenguaje):-
    lenguajeProgramacion(Lenguaje).
lenguaje(html).
lenguaje(xml).

% lenguajeMultiparadigma/1 cuando implementa al menos 2 paradigmas
lenguajeMultiparadigma(Lenguaje):-
    % Orden importa
    implementa(Lenguaje, P1),
    implementa(Lenguaje, P2),
    P1 \= P2.

% Clase 2 24/6

% suma/2 Suma de elementos de una lista.
suma([],0).
suma([H|T], Resultado):-
    suma(T, SumaT),
    Resultado is H + SumaT.

% miembro/2 Elemento es miembro de la lista.
miembro(X, [X|_]).
miembro(X, [_|T]):-
    member(X, T).

% revertir/2
revertir([], []).
revertir([H|T], L):-
    revertir(T, RT),
    append(RT,[H],L).

%factorial/1
factorial(0,1).
factorial(Numero, Factorial) :-
    Numero >= 0, % Para cortar el caso recursivo y hacer que use la otra definicion.
    Anterior is Numero - 1,
    factorial(Anterior, FAnterior),
    Factorial is Numero * FAnterior.

% Clase 3 01/07

%padre/2
padre(homero, bart).
padre(abraham, homero).

%ancestro/2
ancestro(Ancestro, Persona):-
    padre(Ancestro, Persona).
ancestro(Ancestro, Persona):-
    padre(Padre, Persona),
    ancestro(Ancestro, Padre).

%appendar/3
appendar([], L, L).
appendar([H|T], L2, [H|TLista]) :-
    appendar(T, L2, TLista).
