-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1
-- Tiempo de generación: 02-07-2025 a las 14:17:12
-- Versión del servidor: 10.4.32-MariaDB
-- Versión de PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `conecta_icbf`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `asistencia`
--

CREATE TABLE `asistencia` (
  `fecha` date NOT NULL,
  `asistio` enum('si','no','excusa') DEFAULT NULL,
  `ninos_id_ninos` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `desarrollo_infantes`
--

CREATE TABLE `desarrollo_infantes` (
  `infantes_id_desarrollo` int(11) NOT NULL,
  `fecha_fin_mes` date NOT NULL,
  `dimension_cognitiva` text DEFAULT NULL,
  `dimension_comunicativa` text DEFAULT NULL,
  `dimension_socio_afectiva` text DEFAULT NULL,
  `dimension_corporal` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `hogar_comunitario`
--

CREATE TABLE `hogar_comunitario` (
  `id_jardin` int(11) NOT NULL,
  `nombre_jardin` varchar(25) NOT NULL,
  `direccion_jardin` varchar(45) DEFAULT NULL,
  `localidades_n_localidades` int(11) DEFAULT NULL,
  `capacidad_maxima_infantes` int(11) DEFAULT NULL,
  `estado` enum('activo','inactivo','en_mantenimiento') DEFAULT 'activo'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `infantes`
--

CREATE TABLE `infantes` (
  `id_infantes` int(11) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `fecha_nacimiento` date NOT NULL,
  `documento` bigint(20) NOT NULL,
  `nacionalidad` varchar(30) DEFAULT NULL,
  `edad` int(11) NOT NULL CHECK (`edad` >= 0),
  `genero` enum('masculino','femenino','otro','no_especificado') DEFAULT NULL,
  `fecha_ingreso` date DEFAULT NULL,
  `num_personas_conquien_vive` int(11) DEFAULT NULL,
  `parentesco_personas_conquien_vive` varchar(45) DEFAULT NULL,
  `tipo_vivienda` varchar(45) DEFAULT NULL,
  `jardin_id_jardin` int(11) DEFAULT NULL,
  `representante_legal_id_usuario` int(11) DEFAULT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `usuario_creacion` int(11) DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `usuario_actualizacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `infantes`
--

INSERT INTO `infantes` (`id_infantes`, `nombres`, `apellidos`, `fecha_nacimiento`, `documento`, `nacionalidad`, `edad`, `genero`, `fecha_ingreso`, `num_personas_conquien_vive`, `parentesco_personas_conquien_vive`, `tipo_vivienda`, `jardin_id_jardin`, `representante_legal_id_usuario`, `fecha_creacion`, `usuario_creacion`, `fecha_actualizacion`, `usuario_actualizacion`) VALUES
(1, 'Juan', 'Pérez', '0000-00-00', 123456789, NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-01 21:08:02', NULL, '2025-07-01 21:08:02', NULL),
(2, 'yissell', 'Ramirez', '2022-11-01', 1076646804, NULL, 8, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2025-07-01 22:30:01', NULL, '2025-07-01 22:30:01', NULL),
(3, 'valentina', 'Ramirez', '2022-01-02', 1076646803, NULL, 3, NULL, NULL, NULL, NULL, NULL, NULL, 1, '2025-07-02 06:55:43', NULL, '2025-07-02 06:55:43', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `infantes_has_planeacion`
--

CREATE TABLE `infantes_has_planeacion` (
  `infantes_id_infantes` int(11) NOT NULL,
  `planeacion_fecha_actividad` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `localidades`
--

CREATE TABLE `localidades` (
  `n_localidades` int(11) NOT NULL,
  `localidad` varchar(25) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `madres_comunitarias`
--

CREATE TABLE `madres_comunitarias` (
  `id_madre` int(11) NOT NULL,
  `jardin_id_jardin` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `notificaciones`
--

CREATE TABLE `notificaciones` (
  `id_notificacion` int(11) NOT NULL,
  `descripcion_notificacion` varchar(45) NOT NULL,
  `hora_notificacion` time DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `novedades`
--

CREATE TABLE `novedades` (
  `id_novedad` int(11) NOT NULL,
  `infantes_id_novedades` int(11) DEFAULT NULL,
  `fecha_novedad` date NOT NULL,
  `tipo_novedad_correspondiente` varchar(100) DEFAULT NULL,
  `descripcion_evento` varchar(200) DEFAULT NULL,
  `involucrados` varchar(100) DEFAULT NULL,
  `acciones_de_seguimiento` varchar(500) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planeacion`
--

CREATE TABLE `planeacion` (
  `fecha_actividad` date NOT NULL,
  `hora_actividad` time DEFAULT NULL,
  `rango_edad` varchar(15) DEFAULT NULL,
  `nombre_actividad` varchar(45) DEFAULT NULL,
  `descripcion` varchar(200) DEFAULT NULL,
  `intencionalidad_pedagogica` text DEFAULT NULL,
  `materiales_utilizar` text DEFAULT NULL,
  `ambientacion` text DEFAULT NULL,
  `actividad_inicio` text DEFAULT NULL,
  `desarrollo_actividad` text DEFAULT NULL,
  `cierre_actividad` text DEFAULT NULL,
  `documentacion` blob DEFAULT NULL,
  `observacion` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `planeacion_has_notificaciones`
--

CREATE TABLE `planeacion_has_notificaciones` (
  `planeacion_fecha_actividad` date NOT NULL,
  `notificaciones_id_notificacion` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tutor_legal`
--

CREATE TABLE `tutor_legal` (
  `usuarios_id_tutor_legal` int(11) NOT NULL,
  `parentesco` varchar(15) NOT NULL,
  `nomcompleto_contacto_emergencia` varchar(45) DEFAULT NULL,
  `telefono_contacto_emergencia` bigint(20) DEFAULT NULL,
  `estrato` int(11) DEFAULT NULL,
  `ocupacion` varchar(45) DEFAULT NULL,
  `situacion_economica_hogar` varchar(45) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `id_usuarios` int(11) NOT NULL,
  `documento` bigint(20) NOT NULL,
  `nombres` varchar(50) NOT NULL,
  `apellidos` varchar(50) NOT NULL,
  `correo` varchar(45) NOT NULL,
  `direccion` varchar(45) DEFAULT NULL,
  `telefono` bigint(20) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `rol` enum('madre comunitaria','padre a cargo','administrador','personal_icbf') NOT NULL,
  `fecha_creacion` datetime DEFAULT current_timestamp(),
  `usuario_creacion` int(11) DEFAULT NULL,
  `fecha_actualizacion` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `usuario_actualizacion` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuarios`, `documento`, `nombres`, `apellidos`, `correo`, `direccion`, `telefono`, `password_hash`, `rol`, `fecha_creacion`, `usuario_creacion`, `fecha_actualizacion`, `usuario_actualizacion`) VALUES
(1, 0, 'nicolas', 'gomez', 'stivnieto14@gmail.com', 'kra 97#135a 30 SUBA', 3132646622, '5994471abb01112afcc18159f6cc74b4f511b99806da59b3caf5a9c173cacfc5', 'madre comunitaria', '2025-07-01 20:22:30', NULL, '2025-07-01 20:22:30', NULL);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD PRIMARY KEY (`fecha`,`ninos_id_ninos`),
  ADD KEY `ninos_id_ninos` (`ninos_id_ninos`);

--
-- Indices de la tabla `desarrollo_infantes`
--
ALTER TABLE `desarrollo_infantes`
  ADD PRIMARY KEY (`infantes_id_desarrollo`,`fecha_fin_mes`);

--
-- Indices de la tabla `hogar_comunitario`
--
ALTER TABLE `hogar_comunitario`
  ADD PRIMARY KEY (`id_jardin`),
  ADD KEY `localidades_n_localidades` (`localidades_n_localidades`);

--
-- Indices de la tabla `infantes`
--
ALTER TABLE `infantes`
  ADD PRIMARY KEY (`id_infantes`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD KEY `jardin_id_jardin` (`jardin_id_jardin`),
  ADD KEY `representante_legal_id_usuario` (`representante_legal_id_usuario`),
  ADD KEY `usuario_creacion` (`usuario_creacion`),
  ADD KEY `usuario_actualizacion` (`usuario_actualizacion`);

--
-- Indices de la tabla `infantes_has_planeacion`
--
ALTER TABLE `infantes_has_planeacion`
  ADD PRIMARY KEY (`infantes_id_infantes`,`planeacion_fecha_actividad`),
  ADD KEY `planeacion_fecha_actividad` (`planeacion_fecha_actividad`);

--
-- Indices de la tabla `localidades`
--
ALTER TABLE `localidades`
  ADD PRIMARY KEY (`n_localidades`);

--
-- Indices de la tabla `madres_comunitarias`
--
ALTER TABLE `madres_comunitarias`
  ADD PRIMARY KEY (`id_madre`),
  ADD KEY `jardin_id_jardin` (`jardin_id_jardin`);

--
-- Indices de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  ADD PRIMARY KEY (`id_notificacion`);

--
-- Indices de la tabla `novedades`
--
ALTER TABLE `novedades`
  ADD PRIMARY KEY (`id_novedad`),
  ADD KEY `infantes_id_novedades` (`infantes_id_novedades`);

--
-- Indices de la tabla `planeacion`
--
ALTER TABLE `planeacion`
  ADD PRIMARY KEY (`fecha_actividad`);

--
-- Indices de la tabla `planeacion_has_notificaciones`
--
ALTER TABLE `planeacion_has_notificaciones`
  ADD PRIMARY KEY (`planeacion_fecha_actividad`,`notificaciones_id_notificacion`),
  ADD KEY `notificaciones_id_notificacion` (`notificaciones_id_notificacion`);

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
  ADD UNIQUE KEY `documento` (`documento`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD KEY `usuario_creacion` (`usuario_creacion`),
  ADD KEY `usuario_actualizacion` (`usuario_actualizacion`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `hogar_comunitario`
--
ALTER TABLE `hogar_comunitario`
  MODIFY `id_jardin` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `infantes`
--
ALTER TABLE `infantes`
  MODIFY `id_infantes` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT de la tabla `notificaciones`
--
ALTER TABLE `notificaciones`
  MODIFY `id_notificacion` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `novedades`
--
ALTER TABLE `novedades`
  MODIFY `id_novedad` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuarios` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `asistencia`
--
ALTER TABLE `asistencia`
  ADD CONSTRAINT `asistencia_ibfk_1` FOREIGN KEY (`ninos_id_ninos`) REFERENCES `infantes` (`id_infantes`);

--
-- Filtros para la tabla `desarrollo_infantes`
--
ALTER TABLE `desarrollo_infantes`
  ADD CONSTRAINT `desarrollo_infantes_ibfk_1` FOREIGN KEY (`infantes_id_desarrollo`) REFERENCES `infantes` (`id_infantes`);

--
-- Filtros para la tabla `hogar_comunitario`
--
ALTER TABLE `hogar_comunitario`
  ADD CONSTRAINT `hogar_comunitario_ibfk_1` FOREIGN KEY (`localidades_n_localidades`) REFERENCES `localidades` (`n_localidades`);

--
-- Filtros para la tabla `infantes`
--
ALTER TABLE `infantes`
  ADD CONSTRAINT `infantes_ibfk_1` FOREIGN KEY (`jardin_id_jardin`) REFERENCES `hogar_comunitario` (`id_jardin`),
  ADD CONSTRAINT `infantes_ibfk_2` FOREIGN KEY (`representante_legal_id_usuario`) REFERENCES `usuarios` (`id_usuarios`),
  ADD CONSTRAINT `infantes_ibfk_3` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id_usuarios`),
  ADD CONSTRAINT `infantes_ibfk_4` FOREIGN KEY (`usuario_actualizacion`) REFERENCES `usuarios` (`id_usuarios`);

--
-- Filtros para la tabla `infantes_has_planeacion`
--
ALTER TABLE `infantes_has_planeacion`
  ADD CONSTRAINT `infantes_has_planeacion_ibfk_1` FOREIGN KEY (`infantes_id_infantes`) REFERENCES `infantes` (`id_infantes`),
  ADD CONSTRAINT `infantes_has_planeacion_ibfk_2` FOREIGN KEY (`planeacion_fecha_actividad`) REFERENCES `planeacion` (`fecha_actividad`);

--
-- Filtros para la tabla `madres_comunitarias`
--
ALTER TABLE `madres_comunitarias`
  ADD CONSTRAINT `madres_comunitarias_ibfk_1` FOREIGN KEY (`id_madre`) REFERENCES `usuarios` (`id_usuarios`),
  ADD CONSTRAINT `madres_comunitarias_ibfk_2` FOREIGN KEY (`jardin_id_jardin`) REFERENCES `hogar_comunitario` (`id_jardin`);

--
-- Filtros para la tabla `novedades`
--
ALTER TABLE `novedades`
  ADD CONSTRAINT `novedades_ibfk_1` FOREIGN KEY (`infantes_id_novedades`) REFERENCES `infantes` (`id_infantes`);

--
-- Filtros para la tabla `planeacion_has_notificaciones`
--
ALTER TABLE `planeacion_has_notificaciones`
  ADD CONSTRAINT `planeacion_has_notificaciones_ibfk_1` FOREIGN KEY (`planeacion_fecha_actividad`) REFERENCES `planeacion` (`fecha_actividad`),
  ADD CONSTRAINT `planeacion_has_notificaciones_ibfk_2` FOREIGN KEY (`notificaciones_id_notificacion`) REFERENCES `notificaciones` (`id_notificacion`);

--
-- Filtros para la tabla `tutor_legal`
--
ALTER TABLE `tutor_legal`
  ADD CONSTRAINT `tutor_legal_ibfk_1` FOREIGN KEY (`usuarios_id_tutor_legal`) REFERENCES `usuarios` (`id_usuarios`);

--
-- Filtros para la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD CONSTRAINT `usuarios_ibfk_1` FOREIGN KEY (`usuario_creacion`) REFERENCES `usuarios` (`id_usuarios`),
  ADD CONSTRAINT `usuarios_ibfk_2` FOREIGN KEY (`usuario_actualizacion`) REFERENCES `usuarios` (`id_usuarios`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
