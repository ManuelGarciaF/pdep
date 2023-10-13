% https://docs.google.com/document/d/1GBORNTd2fujNy0Zs6v7AKXxRmC9wVICX2Y-pr7d1PwE/edit#heading=h.tah786xadto6

herramientasRequeridas(ordenarCuarto, [alternativa(aspiradora(100), escoba), trapeador, plumero]).
herramientasRequeridas(limpiarTecho, [escoba, pala]).
herramientasRequeridas(cortarPasto, [bordedadora]).
herramientasRequeridas(limpiarBanio, [sopapa, trapeador]).
herramientasRequeridas(encerarPisos, [lustradora, cera, aspiradora(300)]).

% 1.
poseeHerramienta(egon, aspiradora(200)).
poseeHerramienta(egon, trapeador).
poseeHerramienta(peter, trapeador).
poseeHerramienta(winston, varitaDeNeutrones).

empleado(Nombre):- poseeHerramienta(Nombre, _).

% 2.
tieneHerramientaRequerida(Persona, Herramienta):- poseeHerramienta(Persona, Herramienta).
tieneHerramientaRequerida(Persona, aspiradora(PotenciaRequerida)):-
    poseeHerramienta(Persona, aspiradora(Potencia)),
    Potencia > PotenciaRequerida.
% lidiar con alternativas
tieneHerramientaRequerida(Persona, alternativa(Herramienta, _)):- tieneHerramientaRequerida(Persona, Herramienta).
tieneHerramientaRequerida(Persona, alternativa(_, Herramienta)):- tieneHerramientaRequerida(Persona, Herramienta).

% 3.
puedeRealizar(Persona, Tarea):-
    herramientasRequeridas(Tarea, _),
    poseeHerramienta(Persona, varitaDeNeutrones).
puedeRealizar(Persona, Tarea):-
    empleado(Persona),
    herramientasRequeridas(Tarea, Requeridas),
    forall(member(Herramienta, Requeridas), tieneHerramientaRequerida(Persona, Herramienta)).

% 4.
tareaPedida(Cliente, Tarea, MetrosCuadrados).
precio(Tarea, PrecioPorM3).

cliente(Cliente):- tareaPedida(Cliente, _, _).

costoPedido(Cliente, PrecioTotal):-
    cliente(Cliente),
    findall(Precio, precioTarea(Cliente, Precio), Precios),
    sum_list(Precios, PrecioTotal).

precioTarea(Cliente, Precio):-
    tareaPedida(Cliente, Tarea, Metros),
    precio(Tarea, PrecioM3),
    Precio is Metros * PrecioM3.

% 5.
aceptaPedido(Cliente, Empleado):-
    cliente(Cliente),
    empleado(Empleado),
    forall(tareaPedida(Cliente, Tarea, _), puedeRealizar(Empleado, Tarea)),
    dispuestoAAceptar(Cliente, Empleado).

dispuestoAAceptar(Cliente, ray):- not(tareaPedida(Cliente, limpiarTechos, _)).
dispuestoAAceptar(Cliente, winston):-
    costoPedido(Cliente, Paga),
    Paga > 500.
dispuestoAAceptar(Cliente, egon):-
    not((tareaPedida(Cliente, Tarea, _), tareaCompleja(Tarea))).
dispuestoAAceptar(_, peter).

tareaCompleja(Tarea):-
    herramientasRequeridas(Tarea, Herramientas),
    length(Herramientas, Numero),
    Numero > 2.
tareaCompleja(limpiarTecho).

% 6.
% Es facil de incorporar gracias al polimorfismo, que nos permite incorporar distintas formas de tratar una alternativa,
% definiendo modos especiales de cumplir tieneHerramientaRequerida mediante pattern matching.
