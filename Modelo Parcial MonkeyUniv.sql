Use MonkeyUniv;

-- 1) Por cada año, la cantidad de cursos que se estrenaron en dicho año y el promedio de costo de cursada.
Select year(C.Estreno) 'Año', count(*) as 'Cantidad estrenados', avg(C.CostoCurso) 'Promedio de costo de cursada'
From Cursos C
Group by year(C.Estreno)
Order by 1 desc

-- 2) El idioma que se haya utilizado más veces como subtítulo. Si hay varios idiomas en esa condición, mostrarlos a todos.
Select top 1 with ties I.Nombre 'Más usado como subtítulo'
From Idiomas I
Inner Join Idiomas_x_Curso IxC on I.ID = IxC.IDIdioma
Inner Join TiposIdioma TI on IxC.IDTipo = TI.ID
Where TI.Nombre like '%subtítulo%'
Group by I.Nombre
Order by count(*) desc

-- 3) Apellidos y nombres de usuarios que cursaron algún curso y nunca fueron instructores de cursos.
Select DAT.Apellidos+ ', ' +DAT.Nombres 'Cursantes que nunca fueron instructores'
From Datos_Personales DAT
Where DAT.ID in(
	Select distinct I.IDUsuario
	From Inscripciones I
) and DAT.ID not in(
	Select distinct IxC.IDUsuario
	From Instructores_x_Curso IxC
)
-- 4) Para cada usuario mostrar los apellidos y nombres y el costo más caro de un curso al que se haya inscripto. En caso de no haberse inscripto a ningún curso debe figurar igual pero con importe igual a -1.
Select DAT.Apellidos, DAT.Nombres, isnull(max(I.Costo),-1)'Costo más caro de inscripción'
From Datos_Personales DAT
Left Join Inscripciones I on DAT.ID = I.IDUsuario
Group by DAT.Apellidos, DAT.Nombres
Order by 1

-- 5) La cantidad de usuarios que hayan realizado reseñas positivas (Puntaje>=7) pero nunca una reseña negativa (Puntaje<7).
Select count(*)'Cantidad con positivas, pero no negativas' From(
	Select DAT.Apellidos, DAT.Nombres,
	(
		Select count(*) From Reseñas R
		Inner Join Inscripciones I on R.IDInscripcion = I.ID
		Where DAT.ID = I.IDUsuario and R.Puntaje > 6
	)'Reseñas positivas',
	(
		Select Count(*) From Reseñas R
		Inner Join Inscripciones I on R.IDInscripcion = I.ID
		Where DAT.ID = I.IDUsuario and R.Puntaje < 7
	)'Reseñas negativas'
	From Datos_Personales DAT
)as AUX
Where AUX.[Reseñas positivas] <> 0 and AUX.[Reseñas negativas] = 0