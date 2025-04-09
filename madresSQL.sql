-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 03-12-2024 a las 01:22:21
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.1.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `madres`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `ActualizarContactoEmergenciaDetallado` (IN `p_id_tutor` INT, IN `p_nuevo_contacto` VARCHAR(45), OUT `p_mensaje` VARCHAR(200))   BEGIN
    DECLARE v_existe_tutor INT;
    DECLARE v_tiene_infantes INT;
    DECLARE v_nombre_tutor VARCHAR(100);

    -- Verificar si el tutor existe
    SELECT COUNT(*) INTO v_existe_tutor
    FROM tutor_legal
    WHERE usuarios_id_tutor_legal = p_id_tutor;

    IF v_existe_tutor = 0 THEN
        SET p_mensaje = 'Error: El tutor con el ID proporcionado no existe.';
    ELSE
        -- Verificar si el tutor está asociado a algún infante
        SELECT COUNT(*) INTO v_tiene_infantes
        FROM infantes
        WHERE representante_legal_usuarios_id_madres_comunitarias = p_id_tutor;

        IF v_tiene_infantes = 0 THEN
            SET p_mensaje = 'Error: El tutor no tiene infantes asociados.';
        ELSE
            -- Obtener el nombre completo del tutor
            SELECT CONCAT(primer_nombre, ' ', segundo_nombre, ' ', primer_apellido, ' ', segundo_apellido)
            INTO v_nombre_tutor
            FROM usuarios
            WHERE id_usuarios = p_id_tutor;

            -- Actualizar el contacto de emergencia
            UPDATE tutor_legal
            SET telefono_contacto_emergencia = p_nuevo_contacto
            WHERE usuarios_id_tutor_legal = p_id_tutor;

            SET p_mensaje = CONCAT('Contacto de emergencia actualizado exitosamente para el tutor ', v_nombre_tutor, ' (ID: ', p_id_tutor, ').');
        END IF;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cambiar_tutor_legal` (IN `p_tutor_actual` INT, IN `p_nuevo_tutor` INT)   BEGIN
    DECLARE num_registros INT;
SELECT COUNT(*) INTO num_registros
    FROM infantes
    WHERE representante_legal_usuarios_id_madres_comunitarias = p_tutor_actual;
IF num_registros = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontró el tutor actual en los registros.';
    ELSE
        UPDATE infantes
        SET representante_legal_usuarios_id_madres_comunitarias = p_nuevo_tutor
        WHERE representante_legal_usuarios_id_madres_comunitarias = p_tutor_actual;
        SELECT 'Tutor legal actualizado exitosamente.' AS mensaje;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_planeaciones_con_notificaciones` (IN `p_fecha_inicio` DATE, IN `p_fecha_fin` DATE, IN `p_nombre_actividad` VARCHAR(45))   BEGIN
 SELECT
p.nombre_actividad,
p.descripcion,
p.fecha_actividad,
n.descripcion_notificacion,
n.hora_notificacion
FROM
planeacion p
JOIN
planeacion_has_notificaciones pn ON p.fecha_actividad = pn.planeacion_fecha_actividad
JOIN
notificaciones n ON pn.notificaciones_descripcion_notificacion = n.descripcion_notificacion
WHERE
p.fecha_actividad BETWEEN p_fecha_inicio AND p_fecha_fin 
AND (p_nombre_actividad IS NULL OR p.nombre_actividad = p_nombre_actividad)
ORDER BY
p.fecha_actividad DESC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `obtener_reporte_desarrollo_niño` (IN `id_niño` INT, IN `ano` INT)   BEGIN
    DECLARE num_registros INT;

    -- Contamos los registros que coinciden con los parámetros
    SELECT COUNT(*) INTO num_registros
    FROM 
        desarrollo_infantes di
    JOIN 
        infantes i ON di.infantes_id_desarrollo = i.id_infantes
    WHERE 
        YEAR(di.fecha_fin_mes) = ano
        AND i.id_infantes = id_niño;

    -- Si no hay registros, enviamos un mensaje
    IF num_registros = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se encontraron registros de desarrollo para el niño especificado en el año proporcionado.';
    ELSE
        -- Si hay registros, mostramos el reporte
        SELECT 
            i.id_infantes AS id_niño,
            CONCAT(i.primer_nombre, ' ', i.segundo_nombre, ' ', i.primer_apellido, ' ', i.segundo_apellido) AS nombre_completo_niño,
            i.edad AS edad_niño,
            di.fecha_fin_mes AS reporte_desarrollo,
            di.registro_comportamiento
        FROM 
            desarrollo_infantes di
        JOIN 
            infantes i ON di.infantes_id_desarrollo = i.id_infantes
        WHERE 
            YEAR(di.fecha_fin_mes) = ano
            AND i.id_infantes = id_niño
        ORDER BY 
            di.fecha_fin_mes;

        -- Mensaje de éxito al obtener los registros
        SIGNAL SQLSTATE '01000' SET MESSAGE_TEXT = 'Reporte de desarrollo generado exitosamente.';
    END IF;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencia`
--

CREATE TABLE `asistencia` (
  `fecha` date NOT NULL,
  `asistio` varchar(2) NOT NULL,
  `ninos_id_Ninos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `asistencia`
--

INSERT INTO `asistencia` (`fecha`, `asistio`, `ninos_id_Ninos`) VALUES
('2024-01-06', 'SI', 201005),
('2024-01-31', 'SI', 201020),
('2024-02-16', 'NO', 201011),
('2024-03-02', 'NO', 201021),
('2024-03-16', 'SI', 201016),
('2024-03-19', 'SI', 201014),
('2024-03-20', 'SI', 201003),
('2024-04-02', 'SI', 201010),
('2024-04-15', 'NO', 201002),
('2024-05-10', 'SI', 201001),
('2024-05-11', 'NO', 201019),
('2024-06-11', 'SI', 201012),
('2024-06-21', 'SI', 201024),
('2024-07-11', 'NO', 201004),
('2024-07-16', 'SI', 201022),
('2024-08-16', 'SI', 201008),
('2024-08-21', 'SI', 201018),
('2024-09-02', 'NO', 201017),
('2024-09-13', 'SI', 201006),
('2024-09-14', 'NO', 201023),
('2024-10-26', 'NO', 201013),
('2024-11-09', 'NO', 201007),
('2024-12-02', 'NO', 201015),
('2024-12-21', 'NO', 201009);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `desarrollo_infantes`
--

CREATE TABLE `desarrollo_infantes` (
  `infantes_id_desarrollo` int(11) NOT NULL,
  `fecha_fin_mes` date NOT NULL,
  `registro_comportamiento` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `desarrollo_infantes`
--

INSERT INTO `desarrollo_infantes` (`infantes_id_desarrollo`, `fecha_fin_mes`, `registro_comportamiento`) VALUES
(201001, '2022-05-10', 'Participa activamente en actividades grupales.'),
(201002, '2021-04-15', 'Le gusta explorar su entorno y hacer preguntas.'),
(201003, '2023-03-20', 'Demuestra inter?s por aprender colores y formas.'),
(201004, '2022-07-11', 'Prefiere juegos tranquilos y de construcci?n.'),
(201005, '2024-01-06', 'Muestra avances en su coordinaci?n motriz.'),
(201006, '2022-09-13', 'Comparte juguetes con facilidad.'),
(201007, '2023-11-09', 'Se comunica con oraciones completas.'),
(201008, '2022-08-16', 'Le gusta cantar y aprender canciones nuevas.'),
(201009, '2021-12-21', 'Muestra curiosidad por los libros e historias.'),
(201010, '2023-04-02', 'Participa en actividades de dibujo y pintura.'),
(201011, '2024-02-16', 'Le gusta ayudar a organizar los juguetes.'),
(201012, '2022-06-11', 'Demuestra habilidades en juegos de coordinaci?n.'),
(201013, '2021-10-26', 'Se relaciona f?cilmente con otros ni?os.'),
(201014, '2023-03-19', 'Muestra inter?s por aprender n?meros.'),
(201015, '2023-12-02', 'Prefiere juegos de rol y dramatizaci?n.'),
(201016, '2024-03-16', 'Se concentra en actividades por m?s tiempo.'),
(201017, '2021-09-02', 'Muestra creatividad en actividades art?sticas.'),
(201018, '2022-08-21', 'Participa en actividades deportivas con entusiasmo.'),
(201019, '2023-05-11', 'Demuestra avances en su lenguaje verbal.'),
(201020, '2023-01-31', 'Le gusta construir con bloques y materiales.'),
(201021, '2024-03-02', 'Muestra inter?s en aprender canciones nuevas.'),
(201022, '2021-07-16', 'Se muestra colaborativo en actividades grupales.'),
(201023, '2022-09-14', 'Prefiere actividades que impliquen interacci?n f?sica.'),
(201024, '2023-06-21', 'Demuestra curiosidad por aprender nuevas palabras.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hogar_comunitario`
--

CREATE TABLE `hogar_comunitario` (
  `id_jardin` int(11) NOT NULL COMMENT 'dirección única que se ingresa en la cual se ubica el jardín \n',
  `nombre_jardin` varchar(25) NOT NULL COMMENT 'Se requiere saber el nombre del ICBF para tener más aclaración del lugar y ubicación donde se ubica el jardín \n',
  `direccion_jardin` varchar(45) NOT NULL COMMENT 'dirección que se necesita para tener aclaración acerca del lugar y ubicación de donde se encuentra el jardín',
  `localidades_n_localidades` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `hogar_comunitario`
--

INSERT INTO `hogar_comunitario` (`id_jardin`, `nombre_jardin`, `direccion_jardin`, `localidades_n_localidades`) VALUES
(101, 'Los Saltarines', 'Calle 10 #15-20', 18),
(102, 'Mis Primeros Sue?os', 'Carrera 45 #89-10', 19);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `infantes`
--

CREATE TABLE `infantes` (
  `id_infantes` int(11) NOT NULL COMMENT 'se identifica el niño con el número de tarjeta de identidad \n\n',
  `primer_nombre` varchar(25) NOT NULL COMMENT 'el usuario debe ingresar el primer nombre del niño \n',
  `segundo_nombre` varchar(25) DEFAULT NULL COMMENT 'El usuario debe ingresar el segundo nombre del niño \n',
  `primer_apellido` varchar(25) NOT NULL COMMENT 'El usuario debe ingresar el primer apellido del niño \n',
  `segundo_apellido` varchar(25) DEFAULT NULL COMMENT 'El usuario debe ingresar el segundo apellido del niño',
  `edad` int(11) NOT NULL,
  `genero` varchar(10) DEFAULT NULL COMMENT 'el usuario debe aclarar el género del niño \n',
  `fecha_ingreso` date NOT NULL COMMENT 'se debe ubicar la fecha de cuando se hizo el registro de datos',
  `num_personas_conquien_vive` int(11) NOT NULL,
  `parentesco_personas_conquien_vive` varchar(200) NOT NULL,
  `tipo_vivienda` varchar(45) NOT NULL,
  `jardin_id_jardin` int(11) NOT NULL,
  `representante_legal_usuarios_id_madres_comunitarias` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `infantes`
--

INSERT INTO `infantes` (`id_infantes`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `edad`, `genero`, `fecha_ingreso`, `num_personas_conquien_vive`, `parentesco_personas_conquien_vive`, `tipo_vivienda`, `jardin_id_jardin`, `representante_legal_usuarios_id_madres_comunitarias`) VALUES
(201001, 'Juan', 'Carlos', 'G?mez', 'L?pez', 3, 'Masculino', '2022-05-10', 3, 'Pap?, Mam?, Hermano', 'Casa propia', 101, 101001),
(201002, 'Mar?a', 'Jos?', 'L?pez', 'Garc?a', 5, 'Femenino', '2021-04-15', 4, 'Mam?, Pap?, Hermana, Abuela', 'Arrendada', 102, 101002),
(201003, 'Santiago', 'Andr?s', 'P?rez', 'Mart?nez', 2, 'Masculino', '2023-03-20', 2, 'Mam?, Pap?', 'Casa propia', 101, 101003),
(201004, 'Valeria', 'Isabel', 'Morales', 'Ram?rez', 4, 'Femenino', '2022-07-10', 5, 'Mam?, Pap?, Hermano, Hermana, Abuela', 'Arrendada', 102, 101004),
(201005, 'Tom?s', 'Gabriel', 'S?nchez', 'Ortiz', 1, 'Masculino', '2024-01-05', 3, 'Pap?, Mam?, Hermano', 'Casa propia', 101, 101005),
(201006, 'Camila', 'Luc?a', 'Rodr?guez', 'Mej?a', 3, 'Femenino', '2022-09-12', 2, 'Mam?, Abuela', 'Arrendada', 102, 101006),
(201007, 'Emilio', 'Esteban', 'Ram?rez', 'G?mez', 2, 'Masculino', '2023-11-08', 6, 'Pap?, Mam?, Hermano, Hermana, Abuela, Abuelo', 'Casa propia', 101, 101007),
(201008, 'Daniela', 'Carolina', 'Valencia', 'R?os', 4, 'Femenino', '2022-08-15', 4, 'Pap?, Mam?, T?a, Hermano', 'Arrendada', 102, 101008),
(201009, 'Mateo', 'Andr?s', 'Castro', 'Zapata', 5, 'Masculino', '2021-12-20', 3, 'Pap?, Mam?, Hermana', 'Casa propia', 101, 101009),
(201010, 'Sof?a', 'Victoria', 'D?az', 'Moreno', 3, 'Femenino', '2023-04-01', 2, 'Mam?, Pap?', 'Arrendada', 102, 101010),
(201011, 'Samuel', 'David', 'Torres', 'Berm?dez', 1, 'Masculino', '2024-02-15', 2, 'Pap?, Mam?, Abuela, Abuelo, Hermano', 'Casa propia', 101, 101022),
(201012, 'Emma', 'Elena', 'Ortiz', 'Medina', 4, 'Femenino', '2022-06-10', 7, 'Mam?, Pap?, Hermano, Hermana, Abuela, Abuelo, T?o', 'Arrendada', 102, 101012),
(201013, 'Lucas', '?ngel', 'Jim?nez', 'P?rez', 5, 'Masculino', '2021-10-25', 2, 'Pap?, Mam?', 'Casa propia', 101, 101013),
(201014, 'Isabella', 'Valentina', 'Garc?a', 'Ruiz', 3, 'Femenino', '2023-03-18', 4, 'Mam?, Pap?, Hermano, Hermana', 'Arrendada', 102, 101014),
(201015, 'Mart?n', 'David', 'Ruiz', 'L?pez', 2, 'Masculino', '2023-12-01', 3, 'Pap?, Mam?, Abuela', 'Casa propia', 101, 101015),
(201016, 'Antonella', 'Beatriz', 'V?lez', 'Hern?ndez', 1, 'Femenino', '2024-03-15', 6, 'Pap?, Mam?, Hermano, Abuela, Abuelo, T?a', 'Arrendada', 102, 101016),
(201017, 'Leonardo', 'Carlos', 'Herrera', 'Mendoza', 5, 'Masculino', '2021-09-01', 2, 'Mam?, Pap?', 'Casa propia', 101, 101017),
(201018, 'Victoria', 'Andrea', 'Figueroa', 'Gonz?lez', 4, 'Femenino', '2022-08-20', 4, 'Pap?, Mam?, Hermana, Hermano', 'Arrendada', 102, 101018),
(201019, 'Diego', 'Alejandro', 'Castro', 'Rodr?guez', 3, 'Masculino', '2023-05-10', 3, 'Pap?, Mam?, T?a', 'Casa propia', 101, 101019),
(201020, 'Paulina', 'Patricia', 'Z??iga', 'Ram?rez', 2, 'Femenino', '2023-01-30', 5, 'Pap?, Mam?, Hermano, Hermana, T?o', 'Arrendada', 102, 101020),
(201021, 'Sebasti?n', 'Iv?n', 'Hern?ndez', 'Ortiz', 1, 'Masculino', '2024-03-01', 3, 'Pap?, Mam?, Hermano', 'Casa propia', 101, 101021),
(201022, 'Gabriela', 'Isabel', 'Medina', 'G?mez', 5, 'Femenino', '2021-07-15', 2, 'Mam?, Pap?', 'Arrendada', 102, 101022),
(201023, 'Carlos', 'Esteban', 'Su?rez', 'Morales', 4, 'Masculino', '2022-09-12', 4, 'Pap?, Mam?, Abuela, Hermano', 'Casa propia', 101, 101023),
(201024, 'Ana', 'Mar?a', 'Cano', 'L?pez', 3, 'Femenino', '2023-06-20', 6, 'Mam?, Pap?, Hermano, Hermana, Abuela, Abuelo', 'Arrendada', 102, 101024);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `infantes_has_planeacion`
--

CREATE TABLE `infantes_has_planeacion` (
  `infantes_id_infantes` int(11) NOT NULL,
  `planeacion_fecha_actividad` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `infantes_has_planeacion`
--

INSERT INTO `infantes_has_planeacion` (`infantes_id_infantes`, `planeacion_fecha_actividad`) VALUES
(201001, '2024-03-15'),
(201002, '2024-03-15'),
(201003, '2024-03-15'),
(201004, '2024-03-15'),
(201005, '2024-03-15'),
(201006, '2024-03-15'),
(201007, '2024-03-15'),
(201008, '2024-03-15'),
(201009, '2024-03-15'),
(201010, '2024-03-15'),
(201011, '2024-03-15'),
(201012, '2024-03-15'),
(201013, '2024-03-18'),
(201014, '2024-03-18'),
(201015, '2024-03-18'),
(201016, '2024-03-18'),
(201017, '2024-03-18'),
(201018, '2024-03-18'),
(201019, '2024-03-18'),
(201020, '2024-03-18'),
(201021, '2024-03-18'),
(201022, '2024-03-18'),
(201023, '2024-03-18'),
(201024, '2024-03-18');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `localidades`
--

CREATE TABLE `localidades` (
  `n_localidades` int(11) NOT NULL COMMENT 'se indica el nombre de la localidad donde se encuentra ubicado el jardín',
  `localidad` varchar(25) NOT NULL COMMENT 'se indica la localidad del jardín'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `localidades`
--

INSERT INTO `localidades` (`n_localidades`, `localidad`) VALUES
(18, 'Rafael Uribe Uribe'),
(19, 'Ciudad Bol?var');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `madres_comunitarias`
--

CREATE TABLE `madres_comunitarias` (
  `usuarios_id_madres_comunitarias` int(11) NOT NULL,
  `jardin_id_jardin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `madres_comunitarias`
--

INSERT INTO `madres_comunitarias` (`usuarios_id_madres_comunitarias`, `jardin_id_jardin`) VALUES
(101025, 101),
(101026, 102);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `descripcion_notificacion` varchar(45) NOT NULL,
  `hora_notificacion` time NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `notificaciones`
--

INSERT INTO `notificaciones` (`descripcion_notificacion`, `hora_notificacion`) VALUES
('Recordatorio: Juego Sensorial programado para', '08:00:00'),
('Recordatorio: Lectura de Cuentos programada p', '10:00:00');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `novedades`
--

CREATE TABLE `novedades` (
  `infantes_id_novedades` int(11) NOT NULL,
  `tipo_novedad_correspondiente` varchar(100) NOT NULL,
  `descripcion_evento` varchar(200) NOT NULL,
  `involucrados` varchar(100) DEFAULT NULL,
  `acciones_de_seguimiento` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `novedades`
--

INSERT INTO `novedades` (`infantes_id_novedades`, `tipo_novedad_correspondiente`, `descripcion_evento`, `involucrados`, `acciones_de_seguimiento`) VALUES
(201001, 'Accidente leve', 'El infante tropez? mientras jugaba en el parque.', 'Compa?eros de juego', 'Supervisar ?reas de juego y mantener vigilancia.'),
(201002, 'Falta de material', 'El infante no trajo los materiales solicitados para la actividad art?stica.', 'Madre del infante', 'Contactar a los tutores y asegurar disponibilidad para futuras actividades.'),
(201003, 'Conflicto', 'Discusi?n con un compa?ero por un juguete.', 'Un compa?ero', 'Refuerzo de normas de convivencia y trabajo en equipo.'),
(201004, 'Tardanza', 'El infante lleg? tarde al jard?n.', 'Madre comunitaria', 'Conversar con los padres para mejorar la puntualidad.'),
(201005, 'Enfermedad', 'El infante present? fiebre durante la jornada.', 'Madre comunitaria', 'Se aisl? al infante y se contact? a los padres.'),
(201006, 'Falta de uniforme', 'El infante asisti? sin el uniforme reglamentario.', 'Madre del infante', 'Notificar a los tutores sobre la importancia del uniforme.'),
(201007, 'Acto de generosidad', 'El infante comparti? su merienda con un compa?ero.', 'Un compa?ero', 'Reconocer y reforzar el buen comportamiento.'),
(201008, 'P?rdida de objeto', 'El infante perdi? su lonchera en el jard?n.', 'Ninguno', 'Buscar el objeto perdido y reforzar el cuidado de pertenencias.'),
(201009, 'Accidente leve', 'El infante se resbal? en el ?rea de lavado de manos.', 'Ninguno', 'Colocar se?alizaci?n y mejorar supervisi?n.'),
(201010, 'Comportamiento disruptivo', 'El infante interrumpi? varias veces la clase.', 'Compa?eros de clase', 'Implementar t?cnicas de disciplina positiva.'),
(201011, 'Falta de tarea', 'El infante no realiz? la actividad asignada en casa.', 'Padres del infante', 'Coordinar con los tutores para garantizar cumplimiento.'),
(201012, 'Habilidad destacada', 'El infante resolvi? un rompecabezas avanzado.', 'Madre comunitaria', 'Alentar el desarrollo de habilidades cognitivas.'),
(201013, 'Pelea', 'El infante golpe? a un compa?ero durante el recreo.', 'Un compa?ero', 'Sesi?n de mediaci?n y refuerzo de valores.'),
(201014, 'Falta de almuerzo', 'El infante olvid? traer su almuerzo.', 'Padres del infante', 'Recordar a los tutores enviar la merienda.'),
(201015, 'Cambio de comportamiento', 'El infante estuvo t?mido y callado todo el d?a.', 'Madre comunitaria', 'Comunicar a los padres para identificar posibles causas.'),
(201016, 'Dificultad para integrarse', 'El infante no quiso participar en actividades grupales.', 'Compa?eros de grupo', 'Trabajar en actividades de integraci?n social.'),
(201017, 'Desobediencia', 'El infante se neg? a recoger los juguetes despu?s de jugar.', 'Madre comunitaria', 'Motivaci?n y refuerzo positivo para obediencia.'),
(201018, 'Participaci?n destacada', 'El infante lider? la actividad de lectura.', 'Compa?eros de grupo', 'Reconocer y motivar a continuar participando.'),
(201019, 'Falta de control emocional', 'El infante llor? durante una actividad sin motivo aparente.', 'Madre comunitaria', 'Hablar con los tutores sobre posibles factores externos.'),
(201020, 'Habilidad creativa', 'El infante realiz? un dibujo avanzado para su edad.', 'Madre comunitaria', 'Promover m?s actividades de dibujo y creatividad.'),
(201021, 'Problemas de atenci?n', 'El infante mostr? dificultad para concentrarse en la actividad.', 'Madre comunitaria', 'Realizar actividades para mejorar la atenci?n.'),
(201022, 'Acto de ayuda', 'El infante ayud? a un compa?ero a recoger su material.', 'Un compa?ero', 'Reforzar el comportamiento positivo.'),
(201023, 'Falta de higiene', 'El infante olvid? lavarse las manos antes del almuerzo.', 'Madre comunitaria', 'Recordar h?bitos de higiene y supervisar su cumplimiento.'),
(201024, 'Conducta ejemplar', 'El infante sigui? todas las instrucciones sin problema.', 'Madre comunitaria', 'Felicitar al infante frente al grupo por su ejemplo.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planeacion`
--

CREATE TABLE `planeacion` (
  `fecha_actividad` date NOT NULL,
  `hora_actividad` time NOT NULL,
  `rango_edad` varchar(15) NOT NULL,
  `nombre_actividad` varchar(45) NOT NULL,
  `descripcion` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `planeacion`
--

INSERT INTO `planeacion` (`fecha_actividad`, `hora_actividad`, `rango_edad`, `nombre_actividad`, `descripcion`) VALUES
('2024-03-15', '08:00:00', '1-3 a?os', 'Juego Sensorial', 'Actividad enfocada en estimular los sentidos de los ni?os a trav?s de texturas, colores y sonidos.'),
('2024-03-17', '09:00:00', '1-3 a?os', 'Juego de Encaje', 'Actividad para desarrollar la motricidad fina y la coordinaci?n mediante juguetes de encaje.'),
('2024-03-18', '10:00:00', '4-5 a?os', 'Lectura de Cuentos', 'Se realizar? una sesi?n de lectura interactiva para fomentar la imaginaci?n y el inter?s por la lectura.'),
('2024-03-20', '11:30:00', '4-5 a?os', 'Danza Creativa', 'Sesi?n de baile libre para explorar el movimiento corporal y la expresi?n art?stica.'),
('2024-03-22', '14:00:00', '1-3 a?os', 'Taller de Pintura', 'Los ni?os experimentar?n con pinturas seguras para desarrollar su creatividad.'),
('2024-03-25', '16:00:00', '4-5 a?os', 'Cuidado de Plantas', 'Actividad educativa para ense?ar a los ni?os sobre el cuidado de la naturaleza y las plantas.');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planeacion_has_notificaciones`
--

CREATE TABLE `planeacion_has_notificaciones` (
  `planeacion_fecha_actividad` date NOT NULL,
  `notificaciones_descripcion_notificacion` varchar(45) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `planeacion_has_notificaciones`
--

INSERT INTO `planeacion_has_notificaciones` (`planeacion_fecha_actividad`, `notificaciones_descripcion_notificacion`) VALUES
('2024-03-15', 'Recordatorio: Juego Sensorial programado para'),
('2024-03-18', 'Recordatorio: Lectura de Cuentos programada p');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `roles`
--

CREATE TABLE `roles` (
  `id_roles` int(11) NOT NULL,
  `rol` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `roles`
--

INSERT INTO `roles` (`id_roles`, `rol`) VALUES
(1, 'Tutor Legal'),
(2, 'Madre Comunitaria');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutor_legal`
--

CREATE TABLE `tutor_legal` (
  `usuarios_id_tutor_legal` int(11) NOT NULL,
  `parentesco` varchar(15) NOT NULL COMMENT 'el usuario debe ingresar su dirección de residencia para cualquier inquietud acerca de la información del niño \n',
  `nomcompleto_contacto_emergencia` varchar(50) NOT NULL,
  `telefono_contacto_emergencia` int(11) NOT NULL,
  `telefono_contacto_emergencia2` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `tutor_legal`
--

INSERT INTO `tutor_legal` (`usuarios_id_tutor_legal`, `parentesco`, `nomcompleto_contacto_emergencia`, `telefono_contacto_emergencia`, `telefono_contacto_emergencia2`) VALUES
(101001, 'Pap?', 'Carlos G?mez L?pez', 2147483647, 2147483647),
(101002, 'Mam?', 'Ana Mar?a L?pez Garc?a', 2147483647, 2147483647),
(101003, 'Hermana', 'Mar?a Jos? P?rez Mart?nez', 2147483647, 2147483647),
(101004, 'T?a', 'Juana Isabel Morales Ram?rez', 2147483647, 2147483647),
(101005, 'T?o', 'Luis Fernando S?nchez Ortiz', 2147483647, 2147483647),
(101006, 'Abuela', 'Clara Luc?a Rodr?guez Mej?a', 2147483647, 2147483647),
(101007, 'Abuelo', 'Jorge Esteban Ram?rez G?mez', 2147483647, 2147483647),
(101008, 'Prima', 'Laura Carolina Valencia R?os', 2147483647, 2147483647),
(101009, 'Hermano', 'Pablo Andr?s Castro Zapata', 2147483647, 2147483647),
(101010, 'Madrina', 'Carolina Sof?a D?az Moreno', 2147483647, 2147483647),
(101011, 'Hermana', 'Luc?a Camila Torres Berm?dez', 2147483647, 2147483647),
(101012, 'T?a', 'Rosa Elena Ortiz Medina', 2147483647, 2147483647),
(101013, 'Primo', 'Miguel ?ngel Jim?nez P?rez', 2147483647, 2147483647),
(101014, 'Prima', 'Sof?a Valentina Garc?a Ruiz', 2147483647, 2147483647),
(101015, 'Pap?', 'Alejandro David Ruiz L?pez', 2147483647, 2147483647),
(101016, 'Abuela', 'Carmen Beatriz V?lez Hern?ndez', 2147483647, 2147483647),
(101017, 'T?o', 'Juan Carlos Herrera Mendoza', 2147483647, 2147483647),
(101018, 'Prima', 'Paola Andrea Figueroa Gonz?lez', 2147483647, 2147483647),
(101019, 'Mam?', 'Ver?nica Alejandra Castro Rodr?guez', 2147483647, 2147483647),
(101020, 'Abuela', 'Marta Patricia Z??iga Ram?rez', 2147483647, 2147483647),
(101021, 'Primo', 'Diego Sebasti?n Hern?ndez Ortiz', 2147483647, 2147483647),
(101022, 'T?a', 'Andrea Isabel Medina G?mez', 2147483647, 2147483647),
(101023, 'Madrina', 'Gabriela Esther Su?rez Morales', 2147483647, 2147483647),
(101024, 'Abuela', 'Patricia Mar?a Cano L?pez', 2147483647, 2147483647);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuarios` int(11) NOT NULL COMMENT 'cada usuario debe ingresar su número de documento como identificador único',
  `primer_nombre` varchar(25) NOT NULL COMMENT 'El usuario debe ingresar su primer nombre para identificarse',
  `segundo_nombre` varchar(25) DEFAULT NULL COMMENT 'El usuario debe ingresar su segundo nombre para identificarse',
  `primer_apellido` varchar(25) NOT NULL COMMENT 'El usuario debe ingresar su primer apellido para identificarse',
  `segundo_apellido` varchar(25) DEFAULT NULL COMMENT 'El usuario debe ingresar su segundo apellido para identificarse',
  `correo` varchar(45) NOT NULL COMMENT 'el usuario debe ingresar correo electrónico de contacto para recibir y enviar información',
  `direccion` varchar(45) NOT NULL,
  `telefono` bigint(20) NOT NULL COMMENT 'el usuario debe ingresar su número de contacto para mayor comunicación',
  `pasword` bigint(20) NOT NULL COMMENT 'requerimiento de seguridad para ingresar al sistema',
  `roles_id_roles` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuarios`, `primer_nombre`, `segundo_nombre`, `primer_apellido`, `segundo_apellido`, `correo`, `direccion`, `telefono`, `pasword`, `roles_id_roles`) VALUES
(101001, 'Carlos', 'Andr?s', 'G?mez', 'L?pez', 'carlos.gomez@mail.com', 'Calle 123 #45-67', 3101234567, 123456, 1),
(101002, 'Ana', 'Mar?a', 'L?pez', 'Garc?a', 'ana.lopez@mail.com', 'Carrera 12 #34-56', 3109876543, 123457, 1),
(101003, 'Mar?a', 'Jos?', 'P?rez', 'Mart?nez', 'maria.perez@mail.com', 'Avenida 45 #12-34', 3112233445, 123458, 1),
(101004, 'Juana', 'Isabel', 'Morales', 'Ram?rez', 'juana.morales@mail.com', 'Calle 67 #89-10', 3123456789, 123459, 1),
(101005, 'Luis', 'Fernando', 'S?nchez', 'Ortiz', 'luis.sanchez@mail.com', 'Carrera 78 #56-23', 3105556677, 123460, 1),
(101006, 'Clara', 'Luc?a', 'Rodr?guez', 'Mej?a', 'clara.rodriguez@mail.com', 'Avenida 12 #34-56', 3141122334, 123461, 1),
(101007, 'Jorge', 'Esteban', 'Ram?rez', 'G?mez', 'jorge.ramirez@mail.com', 'Calle 89 #12-45', 3169988776, 123462, 1),
(101008, 'Laura', 'Carolina', 'Valencia', 'R?os', 'laura.valencia@mail.com', 'Carrera 45 #67-89', 3152233445, 123463, 1),
(101009, 'Pablo', 'Andr?s', 'Castro', 'Zapata', 'pablo.castro@mail.com', 'Avenida 78 #12-34', 3177788990, 123464, 1),
(101010, 'Carolina', 'Sof?a', 'D?az', 'Moreno', 'carolina.diaz@mail.com', 'Calle 34 #56-78', 3183344556, 123465, 1),
(101011, 'Luc?a', 'Camila', 'Torres', 'Berm?dez', 'lucia.torres@mail.com', 'Carrera 12 #45-78', 3195566778, 123466, 1),
(101012, 'Rosa', 'Elena', 'Ortiz', 'Medina', 'rosa.ortiz@mail.com', 'Avenida 34 #12-45', 3206677889, 123467, 1),
(101013, 'Miguel', '?ngel', 'Jim?nez', 'P?rez', 'miguel.jimenez@mail.com', 'Calle 78 #56-23', 3221123344, 123468, 1),
(101014, 'Sof?a', 'Valentina', 'Garc?a', 'Ruiz', 'sofia.garcia@mail.com', 'Carrera 89 #12-34', 3124455667, 123469, 1),
(101015, 'Alejandro', 'David', 'Ruiz', 'L?pez', 'alejandro.ruiz@mail.com', 'Avenida 23 #45-67', 3137788990, 123470, 1),
(101016, 'Carmen', 'Beatriz', 'V?lez', 'Hern?ndez', 'carmen.velez@mail.com', 'Calle 12 #67-89', 3146677889, 123471, 1),
(101017, 'Juan', 'Carlos', 'Herrera', 'Mendoza', 'juan.herrera@mail.com', 'Carrera 78 #23-56', 3151234567, 123472, 1),
(101018, 'Paola', 'Andrea', 'Figueroa', 'Gonz?lez', 'paola.figueroa@mail.com', 'Avenida 45 #67-89', 3163456789, 123473, 1),
(101019, 'Ver?nica', 'Alejandra', 'Castro', 'Rodr?guez', 'veronica.castro@mail.com', 'Calle 34 #12-56', 3179876543, 123474, 1),
(101020, 'Marta', 'Patricia', 'Z??iga', 'Ram?rez', 'marta.zuniga@mail.com', 'Carrera 45 #78-89', 3186677889, 123475, 1),
(101021, 'Diego', 'Sebasti?n', 'Hern?ndez', 'Ortiz', 'diego.hernandez@mail.com', 'Avenida 23 #45-67', 3194455667, 123476, 1),
(101022, 'Andrea', 'Isabel', 'Medina', 'G?mez', 'andrea.medina@mail.com', 'Calle 67 #12-34', 3203344556, 123477, 1),
(101023, 'Gabriela', 'Esther', 'Su?rez', 'Morales', 'gabriela.suarez@mail.com', 'Carrera 34 #78-89', 3212233445, 123478, 1),
(101024, 'Patricia', 'Mar?a', 'Cano', 'L?pez', 'patricia.cano@mail.com', 'Avenida 12 #34-56', 3221123344, 123479, 1),
(101025, 'Elena', 'Mar?a', 'Vargas', 'Cruz', 'elena.vargas@mail.com', 'Calle 123 #45-67', 3104567890, 123480, 2),
(101026, 'Marcela', 'Beatriz', 'Ram?rez', 'L?pez', 'marcela.ramirez@mail.com', 'Avenida 78 #12-34', 3209876543, 123481, 2);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`fecha`),
  ADD KEY `fk_asistencia_niños1_idx` (`ninos_id_Ninos`);

--
-- Indices de la tabla `desarrollo_infantes`
--
ALTER TABLE `desarrollo_infantes`
  ADD PRIMARY KEY (`infantes_id_desarrollo`),
  ADD KEY `fk_desarrollo_infantes_infantes1_idx` (`infantes_id_desarrollo`);

--
-- Indices de la tabla `hogar_comunitario`
--
ALTER TABLE `hogar_comunitario`
  ADD PRIMARY KEY (`id_jardin`),
  ADD KEY `fk_jardin_localidades_idx` (`localidades_n_localidades`);

--
-- Indices de la tabla `infantes`
--
ALTER TABLE `infantes`
  ADD PRIMARY KEY (`id_infantes`),
  ADD KEY `fk_niños_jardin1_idx` (`jardin_id_jardin`),
  ADD KEY `fk_niños_representante_legal1_idx` (`representante_legal_usuarios_id_madres_comunitarias`);

--
-- Indices de la tabla `infantes_has_planeacion`
--
ALTER TABLE `infantes_has_planeacion`
  ADD PRIMARY KEY (`infantes_id_infantes`,`planeacion_fecha_actividad`),
  ADD KEY `fk_infantes_has_planeacion_planeacion1_idx` (`planeacion_fecha_actividad`),
  ADD KEY `fk_infantes_has_planeacion_infantes1_idx` (`infantes_id_infantes`);

--
-- Indices de la tabla `localidades`
--
ALTER TABLE `localidades`
  ADD PRIMARY KEY (`n_localidades`);

--
-- Indices de la tabla `madres_comunitarias`
--
ALTER TABLE `madres_comunitarias`
  ADD PRIMARY KEY (`usuarios_id_madres_comunitarias`),
  ADD KEY `fk_madres_comunitarias_jardin1_idx` (`jardin_id_jardin`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`descripcion_notificacion`);

--
-- Indices de la tabla `novedades`
--
ALTER TABLE `novedades`
  ADD PRIMARY KEY (`infantes_id_novedades`),
  ADD KEY `fk_novedades_infantes1_idx` (`infantes_id_novedades`);

--
-- Indices de la tabla `planeacion`
--
ALTER TABLE `planeacion`
  ADD PRIMARY KEY (`fecha_actividad`);

--
-- Indices de la tabla `planeacion_has_notificaciones`
--
ALTER TABLE `planeacion_has_notificaciones`
  ADD PRIMARY KEY (`planeacion_fecha_actividad`,`notificaciones_descripcion_notificacion`),
  ADD KEY `fk_planeacion_has_notificaciones_notificaciones1_idx` (`notificaciones_descripcion_notificacion`),
  ADD KEY `fk_planeacion_has_notificaciones_planeacion1_idx` (`planeacion_fecha_actividad`);

--
-- Indices de la tabla `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id_roles`);

--
-- Indices de la tabla `tutor_legal`
--
ALTER TABLE `tutor_legal`
  ADD PRIMARY KEY (`usuarios_id_tutor_legal`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuarios`),
  ADD UNIQUE KEY `correo_UNIQUE` (`correo`),
  ADD KEY `fk_usuarios_roles1_idx` (`roles_id_roles`);

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `fk_asistencia_niños1` FOREIGN KEY (`ninos_id_Ninos`) REFERENCES `infantes` (`id_infantes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `desarrollo_infantes`
--
ALTER TABLE `desarrollo_infantes`
  ADD CONSTRAINT `fk_desarrollo_infantes_infantes1` FOREIGN KEY (`infantes_id_desarrollo`) REFERENCES `infantes` (`id_infantes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `hogar_comunitario`
--
ALTER TABLE `hogar_comunitario`
  ADD CONSTRAINT `fk_jardin_localidades` FOREIGN KEY (`localidades_n_localidades`) REFERENCES `localidades` (`n_localidades`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `infantes`
--
ALTER TABLE `infantes`
  ADD CONSTRAINT `fk_niños_jardin1` FOREIGN KEY (`jardin_id_jardin`) REFERENCES `hogar_comunitario` (`id_jardin`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_niños_representante_legal1` FOREIGN KEY (`representante_legal_usuarios_id_madres_comunitarias`) REFERENCES `tutor_legal` (`usuarios_id_tutor_legal`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `infantes_has_planeacion`
--
ALTER TABLE `infantes_has_planeacion`
  ADD CONSTRAINT `fk_infantes_has_planeacion_infantes1` FOREIGN KEY (`infantes_id_infantes`) REFERENCES `infantes` (`id_infantes`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_infantes_has_planeacion_planeacion1` FOREIGN KEY (`planeacion_fecha_actividad`) REFERENCES `planeacion` (`fecha_actividad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `madres_comunitarias`
--
ALTER TABLE `madres_comunitarias`
  ADD CONSTRAINT `fk_madres_comunitarias_jardin1` FOREIGN KEY (`jardin_id_jardin`) REFERENCES `hogar_comunitario` (`id_jardin`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_madres_comunitarias_usuarios1` FOREIGN KEY (`usuarios_id_madres_comunitarias`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `novedades`
--
ALTER TABLE `novedades`
  ADD CONSTRAINT `fk_novedades_infantes1` FOREIGN KEY (`infantes_id_novedades`) REFERENCES `infantes` (`id_infantes`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `planeacion_has_notificaciones`
--
ALTER TABLE `planeacion_has_notificaciones`
  ADD CONSTRAINT `fk_planeacion_has_notificaciones_notificaciones1` FOREIGN KEY (`notificaciones_descripcion_notificacion`) REFERENCES `notificaciones` (`descripcion_notificacion`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_planeacion_has_notificaciones_planeacion1` FOREIGN KEY (`planeacion_fecha_actividad`) REFERENCES `planeacion` (`fecha_actividad`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `tutor_legal`
--
ALTER TABLE `tutor_legal`
  ADD CONSTRAINT `fk_representante_legal_usuarios1` FOREIGN KEY (`usuarios_id_tutor_legal`) REFERENCES `usuarios` (`id_usuarios`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `fk_usuarios_roles1` FOREIGN KEY (`roles_id_roles`) REFERENCES `roles` (`id_roles`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
