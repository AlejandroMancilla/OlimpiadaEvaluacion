# CONSULTA 1
SELECT * FROM EVENTO WHERE id_complejo = 1;

# CONSULTA 2
SELECT CONCAT(P.nombre, ' ', P.apellido1, ' ', P.apellido2) AS COMISARIO
FROM PERSONA P
INNER JOIN `COMISARIO` C ON C.id_persona = P.id
INNER JOIN `EVENTO` E ON E.id_evento = C.id_evento
WHERE E.nombre LIKE '%fútbol%' ;

# CONSULTA 3
SELECT *
FROM `EVENTO`
WHERE fecha BETWEEN '2023-12-12 10:00:00' AND '2023-12-14 16:00:00';

# CONSULTA 4
SELECT COUNT(*) AS COMISARIOS_ASIGNADOS
FROM `COMISARIO`;

# CONSULTA 5
SELECT * 
FROM `COMPLEJO`
WHERE tipo = 2 AND area_total > '4000';

# CONSULTA 6
SELECT *
FROM `EVENTO`
WHERE num_participantes > (SELECT AVG(num_participantes) FROM `EVENTO`);

# CONSULTA 7
SELECT EQ.nombre AS EQUIPAMIENTO, E.nombre AS EVENTO
FROM `EQUIPO_NECESARIO` EN
INNER JOIN `EQUIPAMIENTO`EQ ON EQ.id_equipamiento = EN.id_equipamiento
INNER JOIN `EVENTO` E ON E.id_evento = EN.id_evento
WHERE E.nombre LIKE '%tenis%';

# CONSULTA 8
SELECT E.nombre AS EVENTO, CONCAT(P.nombre, ' ', P.apellido1, ' ', P.apellido2) AS COMISARIO
FROM `EVENTO` E
INNER JOIN `COMPLEJO` C ON C.id_complejo = E.id_complejo
INNER JOIN `PERSONA` P ON P.id = C.id_jefe
WHERE CONCAT(P.nombre, ' ', P.apellido1, ' ', P.apellido2) LIKE '%Juan Pérez%';

# CONSULTA 9
SELECT DISTINCT C.*, E.id_evento
FROM `COMPLEJO` C
LEFT JOIN `EVENTO` E ON C.id_complejo = E.id_complejo
WHERE C.tipo = 2 AND E.id_complejo IS NULL;

# CONSULTA 10
SELECT CONCAT(P.nombre, ' ', P.apellido1, ' ', P.apellido2) AS COMISARIOS_JEFES_EVENTOS
FROM `PERSONA` P
INNER JOIN `COMISARIO` C ON P.id = C.id_persona
WHERE C.tipo = 1;

# VISTA FECHAS
CREATE OR REPLACE VIEW fechas_eventos AS
    SELECT EVENTO.id_evento, EVENTO.fecha, ADDTIME(EVENTO.fecha, EVENTO.duracion), EVENTO.id_deporte FROM EVENTO;