%% % lenguaje/1
%% lenguaje(haskell).
%% lenguaje(cpp).
%% lenguaje(python).
%% lenguaje(html).

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
