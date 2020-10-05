--1) - Por cada vecino, listar el apellido y nombre y la cantidad total de propiedades de distinto tipo
--que posea. (10 puntos)
Select V.Apellidos, V.Nombres, count(distinct P.IDTipo)'Cant. de propiedades distinto tipo'
From Vecinos V
Left Join Propiedades P on V.DNI = P.DNI
Group by V.Apellidos, V.Nombres
Order by 1

--2) - Listar todos los datos de los vecinos que no tengan Casas de más de 80m2 de superficie
--construida. (20 puntos)
--NOTA: Tipo de propiedad = 'Casa'
Select * From Vecinos V
Where V.DNI not in(
	Select P.DNI
	From Propiedades P
	Inner Join Tipos_Propiedades TI on P.IDTipo = TI.ID
	Where TI.Tipo = 'Casa' and P.Superficie_Construida > 80
)

--3) - Listar por cada vecino el apellido y nombres, la cantidad de propiedades sin superficie
--construida y la cantidad de propiedades con superficie construida que posee. (25 puntos)
Select V.Apellido, V.Nombre,
(
	Select count(*) From Propiedades P
	Where V.DNI = P.DNI and P.Superficie_Construida = 0
)'Prop. sin superficie construida',
(
	Select count(*) From Propiedades P
	Where V.DNI = P.DNI and P.Superficie_Construida > 0  ,                        
)'Prop con superficie construida'
From Vecinos V

--4) - Listar por cada tipo de propiedad el tipo y valor promedio. Sólo listar aquellos registros cuyo
--valor promedio supere los $900000. (15 puntos)
Select TP.Tipo, avg(P.Valor)'Valor promedio'
From Tipos_Propiedades TP
Inner Join Propiedades P on TP.ID = P.IDTipo
Group by TP.Tipo
Having avg(P.Valor) > 9000000

--5) - Por cada vecino, listar apellido y nombres y el total acumulado en concepto de propiedades. Si
--un vecino no posee propiedades deberá figurar acumulando 0. (15 puntos)
Select V.Apellidos, V.Nombres, IsNull(sum(P.Valor), 0)'Total acumulado'
From Vecinos V
Left Join Propiedades P on V.DNI = P.DNI
Group by V.Apellidos, V.Nombres
Order by 1
