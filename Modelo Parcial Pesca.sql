Use MODELOPARCIAL2_PUNTO2

--A) El ganador del torneo es aquel que haya capturado el pez más pesado entre todos los
--peces siempre y cuando se trate de un pez no descartado. Puede haber más de un ganador
--del torneo. Listar Apellido y nombre, especie de pez que capturó y el pesaje del mismo.
Select top 1 PAR.Apellido, PAR.Nombre, E.Especie, P.Peso
From Participantes PAR
Inner Join Pesca P on PAR.IDParticipante = P.IDParticipante
Inner Join Especies E on P.IDEspecie = E.IDEspecie
Order by P.Peso desc

--B) Listar todos los participantes que no hayan pescado ningún tipo de bagre. (ninguna
--especie cuyo nombre contenga la palabra "bagre"). Listar apellido y nombre.
Select PAR.Apellido, PAR.Nombre
From Participantes PAR
Where PAR.IDParticipante not in(
	Select P.IDParticipante
	From Pesca P
	Inner Join Especies E on P.IDEspecie = E.IDEspecie
	Where E.Especie like '%bagre%'
)

--C) Listar los participantes cuyo promedio de pesca (en kilos) sea mayor a 30. Listar apellido,
--nombre y promedio de kilos. ATENCIÓN: No tener en cuenta los peces descartados.
Select PAR.Apellido, PAR.Nombre, avg(P.Peso)'Promedio de kilos'
From Participantes PAR
Inner Join Pesca P on PAR.IDParticipante = P.IDParticipante
Inner Join Especies E on P.IDEspecie = E.IDEspecie
Group by PAR.Apellido, PAR.Nombre
Having avg(P.Peso) > 30
Order by 1

--D) Por cada especie listar la cantidad de veces que han sido capturadas por un pescador
--durante la noche. (Se tiene en cuenta a la noche como el horario de la competencia entre las
--21pm y las 5am -ambas inclusive-).
Select E.Especie,
(
	Select count(P.IDEspecie) From Pesca P
	Inner Join Participantes PAR on P.IdParticipante = PAR.IDParticipante
	Where P.IDEspecie = E.IDEspecie and (datepart(hour, P.Fecha_Hora) between 21 and 24 or datepart(hour, P.Fecha_Hora) between 0 and 5)
)'Cantidad entre 21pm y 5am'
From Especies E

--E) Por cada participante, listar apellido, nombres, la cantidad de peces no descartados y la
--cantidad de peces descartados que capturó.
Select PAR.Apellido, PAR.Nombre,
(
	Select count(*) From Pesca P
	Where P.IDEspecie is not null and PAR.IDParticipante = P.IDParticipante
)'Cantidad de no descartados',
(
	Select count(*) From Pesca P
	Where P.IDEspecie is null and PAR.IDParticipante = P.IDParticipante
)'Cantidad descartados'
From Participantes PAR

--F) Listar apellido y nombre del participante y nombre de la especie de cada pez que haya
--capturado el pescador/a. Si alguna especie de pez no ha sido pescado nunca entonces
--deberá aperecer en el listado de todas formas pero sin datos de pescador. El listado debe
--aparecer ordenado por nombre de especie de manera creciente. La combinación apellido,
--nombre y nombre de la especie debe aparecer sólo una vez en este listado.
Select distinct PAR.Apellido, PAR.Nombre, E.Especie
From Participantes PAR
Inner Join Pesca P on PAR.IDParticipante = P.IDParticipante
Right Join Especies E on P.IDEspecie = E.IDEspecie
Order by 3
