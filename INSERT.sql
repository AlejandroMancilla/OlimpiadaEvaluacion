# POBLACIÓN TABLA DEPORTES
INSERT INTO DEPORTE (nombre)
VALUES
('Fútbol'),
('Baloncesto'),
('Voleibol'),
('Tenis'),
('Rugby'),
('Ciclismo'),
('Atletismo'),
('Natación'),
('Gimnasia');

# POBLACIÓN TABLA EQUIPAMIENTO
INSERT INTO EQUIPAMIENTO (nombre)
VALUES
('Balón de fútbol'),
('Letrero de Cambios'),
('Canasta de baloncesto'),
('Pelota de baloncesto'),
('Red de voleibol'),
('Pelota de voleibol'),
('Raqueta de tenis'),
('Pelota de tenis'),
('Bola de Rugby');

# POBLACIÓN TABLA PERSONAS
INSERT INTO PERSONA (nombre, apellido1, apellido2)
VALUES
('Juan', 'Pérez', 'García'),
('María', 'González', 'López'),
('Antonio', 'Martínez', 'Rodríguez'),
('Laura', 'López', 'Sánchez'),
('Pedro', 'García', 'Fernández'),
('Isabel', 'Martín', 'Pérez'),
('David', 'Sánchez', 'López'),
('Ana', 'Rodríguez', 'González'),
('José', 'Fernández', 'Martín'),
('Luis', 'López', 'Martín'),
('Carmen', 'García', 'Pérez'),
('Francisco', 'Sánchez', 'Rodríguez'),
('Marta', 'Fernández', 'López'),
('Miguel', 'Martín', 'García'),
('Elena', 'Pérez', 'Sánchez'),
('Daniel', 'Rodríguez', 'González'),
('Cristina', 'López', 'Martín'),
('José Antonio', 'García', 'Pérez');

# POBLACIÓN TABLA SEDE
INSERT INTO SEDE (num_complejos, presupuesto)
VALUES
(3, 250000),
(4, 300000),
(5, 350000),
(1, 400000),
(2, 450000);

# POBLACIÓN TABLA COMPLEJO
INSERT INTO COMPLEJO (id_sede, id_localizacion, area_total, tipo, id_jefe)
VALUES
(1, 1, 1000, 'Deportivo', 1),
(1, 2, 2000, 'Polideportivo', 2),
(2, 1, 3000, 'Deportivo', 3),
(2, 2, 4000, 'Polideportivo', 4),
(3, 1, 5000, 'Deportivo', 5),
(3, 2, 6000, 'Polideportivo', 6),
(3, 3, 7000, 'Deportivo', 7),
(3, 4, 8000, 'Polideportivo', 8),
(3, 5, 9000, 'Deportivo', 9);

# POBLACIÓN TABLA DEPORTESxCOMPLEJO
INSERT INTO `DEPORTESxCOMPLEJO` (id_deporte, id_complejo)
VALUES
(1,1),
(5,2),
(2,2),
(6,2),
(8,2),
(3,3),
(4,4),
(9,4),
(7,4);

# POBLACIÓN TABLA EVENTO
INSERT INTO `EVENTO` (fecha, nombre, duracion, num_participantes, num_comisarios, id_complejo, id_deporte)
VALUES
('2023-12-12 11:00:00', 'Torneo de fútbol', '09:00:00', 20, 3, 1, 1),
('2023-12-12 15:00:00', 'Campeonato de tenis', '04:00:00', 30, 2, 4, 4),
('2023-12-13 09:00:00', 'Festival de natación', '06:00:00', 40, 1, 2, 8),
('2023-12-13 10:00:00', 'Concurso de atletismo', '04:00:00', 50, 5, 4, 7),
('2023-12-13 18:00:00', 'Exhibición de gimnasia', '03:00:00', 60, 4, 4, 9),
('2023-12-14 10:00:00', 'Partido de baloncesto', '02:00:00', 70, 1, 2, 2),
('2023-12-14 12:00:00', 'Torneo de voleibol', '10:00:00', 80, 17, 3, 3),
('2023-12-14 16:00:00', 'Campeonato de rugby', '10:00:00', 90, 19, 2, 5),
('2023-12-14 18:00:00', 'Amistoso de Tenis', '06:00:00', 10, 2, 4, 4);

# POBLACIÓN TABLA COMISARIO
INSERT INTO `COMISARIO`(id_evento, id_persona, tipo)
VALUES
(1,10,1),
(1,11,2),
(1,12,2),
(2,13,1),
(2,14,2),
(3,15,1),
(4,16,1),
(4,17,2),
(5,18,1),
(5,18,2);

# POBLACIÓN TABLA EQUIPO_NECESARIO
INSERT INTO `EQUIPO_NECESARIO` (id_evento, id_equipamiento)
VALUES
(1,1),
(1,2),
(6,3),
(6,4),
(2,7),
(9,7),
(9,8);
