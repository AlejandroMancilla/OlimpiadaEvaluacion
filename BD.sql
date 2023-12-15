DROP DATABASE IF EXISTS Olimpiada;
CREATE DATABASE Olimpiada;
USE Olimpiada;

DROP TABLE IF EXISTS `SEDE`;
CREATE TABLE `SEDE` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `num_complejos` INT NOT NULL,
  `presupuesto` FLOAT NOT NULL
);

DROP TABLE IF EXISTS `COMPLEJO`;
CREATE TABLE `COMPLEJO` (
  `id_complejo` INT PRIMARY KEY AUTO_INCREMENT,
  `id_sede` INT,
  `id_localizacion` INT NOT NULL,
  `area_total` FLOAT NOT NULL,
  `tipo` ENUM('Polideportivo', 'Deportivo'),
  `id_jefe` INT UNIQUE,
  CONSTRAINT UNIQUE (id_sede, id_localizacion)
);

DROP TABLE IF EXISTS `PERSONA`;
CREATE TABLE `PERSONA` (
  `id` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(64) NOT NULL,
  `apellido1` VARCHAR(32) NOT NULL,
  `apellido2` VARCHAR(32)
);

DROP TABLE IF EXISTS `DEPORTE`;
CREATE TABLE `DEPORTE` (
  `id_deporte` INT PRIMARY KEY AUTO_INCREMENT,
  `nombre` VARCHAR(32) NOT NULL
);

DROP TABLE IF EXISTS `EVENTO`;
CREATE TABLE `EVENTO` (
  `id_evento` INT PRIMARY KEY AUTO_INCREMENT,
  `fecha` DATETIME NOT NULL,
  `nombre` VARCHAR(60) NOT NULL,
  `duracion` TIME NOT NULL,
  `num_participantes` INT NOT NULL,
  `num_comisarios` INT NOT NULL,
  `id_complejo` INT,
  `id_deporte` INT
);

DROP TABLE IF EXISTS `COMISARIO`;
CREATE TABLE `COMISARIO` (
  `id_evento` INT,
  `id_persona` INT,
  `tipo` ENUM('Juez', 'Observador')
);

DROP TABLE IF EXISTS `DEPORTESxCOMPLEJO`;
CREATE TABLE `DEPORTESxCOMPLEJO` (
  `id_deporte` INT,
  `id_complejo` INT,
  CONSTRAINT UNIQUE (id_deporte, id_complejo)
);

DROP TABLE IF EXISTS `EQUIPAMIENTO`;
CREATE TABLE `EQUIPAMIENTO` (
  `id_equipamiento` int PRIMARY KEY AUTO_INCREMENT,
  `nombre` varchar(255) NOT NULL
);

DROP TABLE IF EXISTS `EQUIPO_NECESARIO`;
CREATE TABLE `EQUIPO_NECESARIO` (
  `id_equipamiento` int,
  `id_evento` int
);


ALTER TABLE `COMPLEJO` ADD FOREIGN KEY (`id_sede`) REFERENCES `SEDE` (`id`);

ALTER TABLE `COMPLEJO` ADD FOREIGN KEY (`id_jefe`) REFERENCES `PERSONA` (`id`);

ALTER TABLE `EVENTO` ADD FOREIGN KEY (`id_complejo`) REFERENCES `COMPLEJO` (`id_complejo`);

ALTER TABLE `EVENTO` ADD FOREIGN KEY (`id_deporte`) REFERENCES `DEPORTE` (`id_deporte`);

ALTER TABLE `COMISARIO` ADD FOREIGN KEY (`id_evento`) REFERENCES `EVENTO` (`id_evento`);

ALTER TABLE `COMISARIO` ADD FOREIGN KEY (`id_persona`) REFERENCES `PERSONA` (`id`);

ALTER TABLE `DEPORTESxCOMPLEJO` ADD FOREIGN KEY (`id_deporte`) REFERENCES `DEPORTE` (`id_deporte`);

ALTER TABLE `DEPORTESxCOMPLEJO` ADD FOREIGN KEY (`id_complejo`) REFERENCES `COMPLEJO` (`id_complejo`);

ALTER TABLE `EQUIPO_NECESARIO` ADD FOREIGN KEY (`id_equipamiento`) REFERENCES `EQUIPAMIENTO` (`id_equipamiento`);

ALTER TABLE `EQUIPO_NECESARIO` ADD FOREIGN KEY (`id_evento`) REFERENCES `EVENTO` (`id_evento`);

# TRIGEGERS VALIDACIONES
# Cantidad de Comisarios asignados a un evento
DROP TRIGGER IF EXISTS cantidadComisarios;
CREATE TRIGGER cantidadComisarios
BEFORE INSERT ON COMISARIO
FOR EACH ROW
BEGIN
    SET @comisarios = (SELECT COUNT(*) FROM `COMISARIO` WHERE id_evento = NEW.id_evento);
    SET @cantidad = (SELECT num_comisarios FROM EVENTO WHERE id_evento = NEW.id_evento);
    if (@comisarios = @cantidad) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya fueron asignados todos los comisarios para este evento";
    END IF;
end;

# Cantidad de complejos en una sede
DROP TRIGGER IF EXISTS cantidad_complejos;
CREATE TRIGGER cantidad_complejos
BEFORE INSERT ON COMPLEJO
FOR EACH ROW
BEGIN
    SET @complejos = (SELECT COUNT(*) FROM COMPLEJO WHERE id_sede = NEW.id_sede);
     SET @cantidad = (SELECT num_complejos FROM SEDE where id = NEW.id_sede);
    if (@complejos = @cantidad) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Ya fueron asignados todos los complejos para esta sede";
    END IF;
end;

# Función Validar Deporte en un Complejo
CREATE FUNCTION validar_deporte_complejo (DEPORTE INT, COMPLEJO INT ) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    RETURN (DEPORTE in (SELECT id_deporte FROM `DEPORTESxCOMPLEJO` WHERE id_complejo = COMPLEJO));
end;
# Función Validar Complejo Deportivo o Polideportivo
DROP FUNCTION IF EXISTS validar_tipo_complejo;
CREATE FUNCTION validar_tipo_complejo (COMPLEJO INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    RETURN ((COMPLEJO IN (SELECT id_complejo FROM `COMPLEJO` WHERE tipo = 2)) AND (COMPLEJO IN (SELECT id_complejo FROM `DEPORTESxCOMPLEJO`)));
end;

# Complejo Apto para Evento
DROP TRIGGER IF EXISTS evento_complejo;
CREATE TRIGGER evento_complejo
BEFORE INSERT ON EVENTO
FOR EACH ROW
BEGIN
    SET @deporte = NEW.id_deporte;
    SET @complejo = NEW.id_complejo;
    SET @fecha = NEW.fecha;
    SET @fecha_fin = ADDTIME(NEW.fecha, NEW.duracion);
    IF NOT validar_deporte_complejo(@deporte, @complejo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Complejo no apto para el evento";
    end if;
    IF fecha_evento(@fecha, @complejo, @deporte) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Fecha no disponible para el tipo de evento";
    END IF;
    IF fecha_evento(@fecha_fin, @complejo, @deporte) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Evento se sobrepone a uno existente en el complejo";
    END IF;
end;

/* Complejo Polideportivo o No */
DROP TRIGGER IF EXISTS tipo_complejo;
CREATE TRIGGER tipo_complejo
BEFORE INSERT ON DEPORTESxCOMPLEJO
FOR EACH ROW
BEGIN
    SET @complejo = NEW.id_complejo;
    IF validar_tipo_complejo(@complejo) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "Complejo no polideportivo";
    end if;
end;


CREATE OR REPLACE VIEW fechas_eventos AS
    SELECT EVENTO.id_evento AS id, EVENTO.fecha AS FECHA_INICIO, ADDTIME(EVENTO.fecha, EVENTO.duracion) AS FECHA_FINAL, EVENTO.id_deporte AS id_deporte, EVENTO.id_complejo AS id_complejo FROM EVENTO;

CREATE FUNCTION fecha_evento(fecha_nueva DATETIME, complejo INT, deporte INT) RETURNS BOOLEAN DETERMINISTIC
BEGIN
    RETURN (
    SELECT
    1 IN
    (SELECT fecha_nueva between FECHA_INICIO and FECHA_FINAL
     FROM fechas_eventos
     WHERE id IN
           (SELECT fechas_eventos.id
            FROM fechas_eventos
            WHERE fechas_eventos.id_complejo = complejo AND fechas_eventos.id_deporte = deporte)));
end;
