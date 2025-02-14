##Query para normalizar la tabla de transporte_nl_inegi en subtablas. date: 02-02-2025

-- Llenar primero la tabla conjunto con la columna id de transporte_nl_inegi
-- Se insertan los valores en la tabla conjunto, tomando el id de transporte_nl_inegi como conjunto_id
INSERT INTO transport_project.metro (id, `pasajeros_total`,`Unidades en operacion de L-V`, 
 `Unidades en operacion de S-D`, `Miles de km recorridos`, `Miles de KWH consumido`, 
 `Ingresos miles de pesos de pasajes`)
SELECT t.id, t.`Pasajeros transportados-total` , t.`Unidades en operacion de L-V`, t.`Unidades en operacion de S-D`, 
       t.`Miles de km recorridos`, t.`Miles de KWH consumido`, 
       t.`Ingresos miles de pesos de pasajes`
FROM transport_project.transporte_nl_inegi t
WHERE t.metro = '1';

-- Poblar tabla ecovia
INSERT INTO transport_project.ecovia (id, `pasajeros_total`, `Unidades en operacion de L-V`, 
 `Unidades en operacion de S-D`, `Miles de km recorridos`,`Pasajeros transportados-tarifa completa`, 
 `Pasajeros transportados-con descuento`,`Pasajeros transportados-con cortesia`)
SELECT t.id, 
IFNULL(t.`Pasajeros transportados-total`,0),
IFNULL(t.`Unidades en operacion de L-V`, 0), 
IFNULL(t.`Unidades en operacion de S-D`, 0), 
IFNULL(t.`Miles de km recorridos`, 0), 
IFNULL(t.`Pasajeros transportados-tarifa completa`, 0), 
IFNULL(t.`Pasajeros transportados-con descuento`, 0), 
IFNULL(t.`Pasajeros transportados-con cortesia`, 0)
FROM transport_project.transporte_nl_inegi t
WHERE t.ecovia = '1';

-- Poblar tabla transmetro
INSERT INTO transport_project.transmetro (id, `pasajeros_total`, `Unidades en operacion de L-V`, 
 `Unidades en operacion de S-D`, `Miles de km recorridos`,`Numero de rutas`, `Personal ocupado`)
SELECT t.id, 
IFNULL(t.`Pasajeros transportados-total`,0),
IFNULL(t.`Unidades en operacion de L-V`, 0), 
IFNULL(t.`Unidades en operacion de S-D`, 0), 
IFNULL(t.`Miles de km recorridos`, 0), 
IFNULL(t.`Numero de rutas`, 0), 
IFNULL(t.`Personal ocupado`, 0)
FROM transport_project.transporte_nl_inegi t
WHERE t.transmetro = '1';

-- Poblar tabla metrobus
INSERT INTO transport_project.metrobus (id, `pasajeros_total`, `Unidades en operacion de L-V`, 
 `Unidades en operacion de S-D`, `Miles de km recorridos`,`Numero de rutas`, `Personal ocupado`)
SELECT t.id, 
IFNULL(t.`Pasajeros transportados-total`,0),
IFNULL(t.`Unidades en operacion de L-V`, 0), 
IFNULL(t.`Unidades en operacion de S-D`, 0), 
IFNULL(t.`Miles de km recorridos`, 0), 
IFNULL(t.`Numero de rutas`, 0), 
IFNULL(t.`Personal ocupado`, 0)
FROM transport_project.transporte_nl_inegi t
WHERE t.metrobus = '1';

-- Asegurar correcta migración después de poblar las tablas
SELECT COUNT(*) FROM transport_project.transporte_nl_inegi;
SELECT COUNT(*) FROM transport_project.metro;
SELECT COUNT(*) FROM transport_project.ecovia;
SELECT COUNT(*) FROM transport_project.metrobus;
SELECT COUNT(*) FROM transport_project.transmetro;

#Eliminar solo datos de la tabla y DESC es para descipcion de la tabla
#TRUNCATE TABLE transport_project.metrobus;
#DESC transport_project.transmetro;