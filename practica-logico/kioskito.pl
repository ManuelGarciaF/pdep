% enunciado: https://docs.google.com/document/d/1RNgFMlSqOKiwe9SEi1U2cQjCmdFfWNflqycSfp7Qa-w

% 1.

% atiende(profe, [horario(dia, inicio, fin)])
turnos(dodain, [horario(lunes, 9, 15), horario(miercoles, 9, 15), horario(viernes, 9, 15)]).
turnos(lucas, [horario(martes, 10, 20)]).
turnos(juanC, [horario(sabado, 18, 22), horario(domingo, 18, 22)]).
turnos(juanFdS, [horario(jueves, 10, 20), horario(viernes, 12, 20)]).
turnos(leoC, [horario(lunes, 14, 18), horario(miercoles, 14, 18)]).
turnos(martu, [horario(miercoles, 23, 24)]).

turnos(vale, Horarios):-
    turnos(dodain, Horarios1),
    turnos(juanC, Horarios2),
    append(Horarios1, Horarios2, Horarios).
% Que nadie haga el horario no se representa, ya que lo que no esta definido se considera falso.
% Que lo este pensando no significa que lo este haciendo asi que no se representa.

profe(Profe):- turnos(Profe, _).

% 2.
atiende(Profe, Dia, Hora):-
    turnos(Profe, Horarios),
    member(horario(Dia, HoraInicio, HoraFin), Horarios),
    between(HoraInicio, HoraFin, Hora).

% 3.
foreverAlone(Profe, Dia, Hora):-
    atiende(Profe, Dia, Hora),
    not((atiende(OtroProfe, Dia, Hora), OtroProfe \= Profe)).

% 4.
posibilidadesDeAtencion(Dia, Profes):-
    distinct(Profes, posibilidadesDeAtencion(Dia, Profes, [])).

posibilidadesDeAtencion(_, [], _).
posibilidadesDeAtencion(Dia, [Profe|Profes], YaConsiderados):-
    atiende(Profe, Dia, _),
    not(member(Profe, YaConsiderados)),
    posibilidadesDeAtencion(Dia, Profes, [Profe|YaConsiderados]).

% 5.
% venta(profe, fecha(Nro, Mes), ventas)
venta(dodain, fecha(10, agosto), [
          golosinas(1200),
          cigarrillos([jockey]),
          golosinas(50)
      ]).
venta(dodain, fecha(12, agosto), [
          bebidas(alcoholicas, 8),
          golosinas(10)
      ]).
venta(martu, fecha(12, agosto), [
          golosinas(1000),
          cigarrillos([chesterfield, colorado, parisiennes])
      ]).
venta(lucas, fecha(11, agosto), [
          golosinas(600)
      ]).
venta(lucas, fecha(18, agosto), [
          bebidas(noAlcoholicas, 2),
          cigarrillos([derby])
      ]).

ventaImportante(golosinas(Precio)):-
    Precio > 100.
ventaImportante(cigarrillos(Marcas)):-
    length(Marcas, Largo),
    Largo > 2.
ventaImportante(bebidas(alcoholicas, _)).
ventaImportante(bebidas(noAlcoholicas, Numero)):-
    Numero > 5.

vendedorSuertudo(Profe):-
    profe(Profe),
    forall(venta(Profe, _, [Venta|_]), ventaImportante(Venta)).
