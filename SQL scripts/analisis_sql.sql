#1 Hacer una vista
CREATE VIEW metrorrey AS 
SELECT c.id, c.month, c.year, c.ecovia, c.metro, c.metrobus, c.transmetro,
COALESCE(m.`pasajeros_total`, e.`pasajeros_total`, 
t.`pasajeros_total`, mb.`pasajeros_total`) AS pasajeros
FROM transport_project.conjunto c
LEFT JOIN transport_project.metro m ON  c.id= m.id
LEFT JOIN transport_project.ecovia e ON  c.id = e.id
LEFT JOIN transport_project.transmetro t ON  c.id = t.id
LEFT JOIN transport_project.metrobus mb ON  c.id = mb.id;

#2 Analizar el año con mayor numero de usuarios en cada sistema
WITH Inforank AS (
    SELECT `year`, Medio, SUM(pasajeros) AS Maximo_pasaje,
        RANK() OVER (PARTITION BY Medio ORDER BY SUM(pasajeros) DESC) AS rank_num
    FROM (SELECT metro, ecovia, transmetro, metrobus, pasajeros, `year`,
				CASE WHEN metro = 1 THEN 'metro' 
				WHEN ecovia = 1 THEN 'ecovia'
				WHEN transmetro = 1 THEN 'transmetro'
				WHEN metrobus = 1 THEN 'metrobus'  END AS Medio
				from metrorrey) AS subquery_1 
    GROUP BY `year`, Medio)
SELECT `year`, Medio, Maximo_pasaje
FROM Inforank
WHERE rank_num = 1;
 -- NOTA:Añadimos a la vista una nueva columna que contiene el nombre del medio para posterior poder filtrarlo, recuerda poner nombre al subquery
 -- Agrupación por year y Medio: Usa SUM(pasajeros) para obtener el total de pasajeros por año y tipo de transporte.
 -- Se usa RANK() para asignar una clasificación basada en SUM(pasajeros) DESC.
 -- Se agrupa (PARTITION BY Medio) para obtener el año con más pasajeros por cada tipo de transporte.
 -- Solo selecciona el año con más pasajeros para cada Medio.
 
 #3 Buscar mes y año con mas usuarios
WITH TotalPasajeros AS (
    SELECT `year`, `month`, SUM(pasajeros) AS total_pasajeros
    FROM metrorrey
    GROUP BY `year`, `month`), 
    RankedData AS (
    SELECT `year`, `month`, total_pasajeros, RANK() OVER (ORDER BY total_pasajeros DESC) AS rank_m
    FROM TotalPasajeros)
SELECT `year`, `month`, total_pasajeros
FROM RankedData
WHERE rank_m = 1;

#3.2 mes y año con menos usuarios
WITH TotalPasajeros AS (
    SELECT `year`, `month`, SUM(pasajeros) AS total_pasajeros
    FROM metrorrey
    GROUP BY `year`, `month`), 
    RankedData AS (
    SELECT `year`, `month`, total_pasajeros, RANK() OVER (ORDER BY total_pasajeros ASC) AS rank_m
    FROM TotalPasajeros)
SELECT `year`, `month`, total_pasajeros
FROM RankedData
WHERE rank_m = 1;

#4 Buscar mes y año con menos usuarios en el metro
WITH Papitas AS (
    SELECT c.`year`, c.`month`, MIN(m.pasajeros_total) AS total_pasajeros
    FROM transport_project.metro m, transport_project.conjunto c
    WHERE c.id = m.id
    GROUP BY `year`, `month`), 
    RankedData AS (
    SELECT `year`, `month`, total_pasajeros, RANK() OVER (ORDER BY total_pasajeros ASC) AS rank_m
    FROM Papitas)
SELECT `year`, `month`, total_pasajeros
FROM RankedData
WHERE rank_m = 1;

# 5 Calcular los promedios de ganancias por mes en el metro
SELECT c.month, AVG(m.`Ingresos miles de pesos de pasajes`) AS Promedio_ganancias
FROM transport_project.metro m, transport_project.conjunto c
WHERE c.id = m.id
GROUP BY `month`
ORDER BY FIELD(c.month, 
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre') ASC;
 -- NO es lo ideal (definir correctamente tipo de dato al hacer tabla), pero funciona para solucionar.
 
# 6.1 Calcular promedio de usuarios por mes en cada sistema
SELECT AVG(pasajeros) AS Pasajeros_promedio, Medio, month AS mes
FROM (SELECT metro, ecovia, transmetro, metrobus, pasajeros, `year`, month,
				CASE WHEN metro = 1 THEN 'metro' 
				WHEN ecovia = 1 THEN 'ecovia'
				WHEN transmetro = 1 THEN 'transmetro'
				WHEN metrobus = 1 THEN 'metrobus'  END AS Medio
				from metrorrey) AS subquery_1 
GROUP BY Medio, month
ORDER BY FIELD(month, 
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre') ASC;
    
# 6.2 Calcular promedio de usuarios por mes en el metro
SELECT month AS mes, AVG(pasajeros) AS Pasajeros_promedio
FROM metrorrey
WHERE metro = 1
GROUP BY mes
ORDER BY FIELD(month, 
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre') ASC;

# 7 Calcular promedio de kilometros recorridos por mes
SELECT c.month AS mes, AVG(m.`Miles de km recorridos`) AS Promedio_miles_de_km_recorrido
FROM transport_project.metro m
INNER JOIN transport_project.conjunto c ON c.id = m.id
WHERE metro = 1
GROUP BY mes
ORDER BY FIELD(month, 
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio', 
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre') ASC;

# 8 Ver los principales cinco municipios con mayor poblacion
SELECT Municipio, Poblacion_total
FROM (SELECT m.Municipio, p.Poblacion_total,
		RANK() OVER(ORDER BY p.Poblacion_total DESC) AS ranking
		FROM transport_project.municipios m
		INNER JOIN transport_project.poblacion_nl p ON m.`code`=p.`code`
        WHERE p.Year = 2024 #Año puede impactar query
        ) ranked
WHERE ranking <= 5;

# 9 Ranking de meses de servicio de los medios de transporte (No recuerdo porque se escogio)
SELECT ROUND(COUNT(month)/4, 0) AS Meses_reportados, month AS Mes
FROM metrorrey
GROUP BY Mes
ORDER BY Meses_reportados DESC;

# 10 Cuanto recorre en promedio una unidad por mes
WITH Charrones AS ( 
    SELECT  me.metro, me.ecovia, me.transmetro, me.metrobus,
    COALESCE(m.`Miles de km recorridos`, e.`Miles de km recorridos`, 
			t.`Miles de km recorridos`, mb.`Miles de km recorridos`) AS Miles_km_recorridos,
	COALESCE(m.`Unidades en operacion de L-V`, e.`Unidades en operacion de L-V`, 
			t.`Unidades en operacion de L-V`, mb.`Unidades en operacion de L-V`) AS Unidades_LV,
	COALESCE(m.`Unidades en operacion de S-D`, e.`Unidades en operacion de S-D`, 
			t.`Unidades en operacion de S-D`, mb.`Unidades en operacion de S-D`) AS Unidades_SD
			FROM metrorrey me
			LEFT JOIN transport_project.metro m ON  me.id= m.id
			LEFT JOIN transport_project.ecovia e ON  me.id = e.id
			LEFT JOIN transport_project.transmetro t ON  me.id = t.id
			LEFT JOIN transport_project.metrobus mb ON  me.id = mb.id
            ), 
    Transporte AS (
    SELECT  Medio, Miles_km_recorridos , Unidades_LV, Unidades_SD
    FROM (SELECT metro, ecovia, transmetro, metrobus, Unidades_LV, Unidades_SD, Miles_km_recorridos,
				CASE WHEN metro = 1 THEN 'metro' 
				WHEN ecovia = 1 THEN 'ecovia'
				WHEN transmetro = 1 THEN 'transmetro'
				WHEN metrobus = 1 THEN 'metrobus'  END AS Medio
				FROM Charrones) AS subquery_2
                ),
	Conchitas AS (
    SELECT  Medio,  (Unidades_LV + Unidades_SD)/2 AS Promedio_unidades, Miles_km_recorridos
    FROM Transporte),
	Papirringas AS (
    SELECT AVG(Promedio_unidades) AS Prom_unidades, Medio, AVG(Miles_km_recorridos) AS Prom_miles_km_recorridos
    FROM Conchitas
    GROUP BY Medio)
SELECT (Prom_miles_km_recorridos/ Prom_unidades) AS Miles_km_recorridos_por_unidad,
		Prom_miles_km_recorridos, Prom_unidades, Medio
FROM Papirringas;

# 11 Personas por km transportadas
WITH Mario AS ( 
    SELECT  me.metro, me.ecovia, me.transmetro, me.metrobus, me.pasajeros,
    COALESCE(m.`Miles de km recorridos`, e.`Miles de km recorridos`, 
			t.`Miles de km recorridos`, mb.`Miles de km recorridos`) AS Miles_km_recorridos,
	COALESCE(m.`Unidades en operacion de L-V`, e.`Unidades en operacion de L-V`, 
			t.`Unidades en operacion de L-V`, mb.`Unidades en operacion de L-V`) AS Unidades_LV,
	COALESCE(m.`Unidades en operacion de S-D`, e.`Unidades en operacion de S-D`, 
			t.`Unidades en operacion de S-D`, mb.`Unidades en operacion de S-D`) AS Unidades_SD
			FROM metrorrey me
			LEFT JOIN transport_project.metro m ON  me.id= m.id
			LEFT JOIN transport_project.ecovia e ON  me.id = e.id
			LEFT JOIN transport_project.transmetro t ON  me.id = t.id
			LEFT JOIN transport_project.metrobus mb ON  me.id = mb.id
            ), 
    Luigi AS (
    SELECT  Medio, Miles_km_recorridos , Unidades_LV, Unidades_SD, pasajeros
    FROM (SELECT metro, ecovia, transmetro, metrobus, Unidades_LV, Unidades_SD, Miles_km_recorridos, pasajeros,
				CASE WHEN metro = 1 THEN 'metro' 
				WHEN ecovia = 1 THEN 'ecovia'
				WHEN transmetro = 1 THEN 'transmetro'
				WHEN metrobus = 1 THEN 'metrobus'  END AS Medio
				FROM Mario) AS subquery_2
                ),
	Peach AS (
    SELECT  Medio,  (Unidades_LV + Unidades_SD)/2 AS Promedio_unidades, (Miles_km_recorridos * 1000) AS km_recorridos,
    pasajeros
    FROM Luigi),
	Toad AS (
    SELECT AVG(Promedio_unidades) AS Prom_unidades, Medio, AVG(km_recorridos) AS Prom_km_recorridos, 
    AVG(pasajeros) AS Prom_pasajeros
    FROM Peach
    GROUP BY Medio)
SELECT (Prom_pasajeros/ Prom_km_recorridos) AS Razon_pasajeros_por_km, Prom_pasajeros,
		Prom_km_recorridos,
        (Prom_pasajeros/Prom_unidades) AS Pasajeros_por_unidad ,Prom_unidades, Medio
FROM Toad;


SELECT * FROM metrorrey;