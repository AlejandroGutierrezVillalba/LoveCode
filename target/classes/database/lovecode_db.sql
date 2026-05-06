DROP DATABASE IF EXISTS lovecode;
CREATE DATABASE lovecode;

USE lovecode;


-- TABLAS


CREATE TABLE usuarios (
    id_usuario      INT             AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    password        VARCHAR(255)    NOT NULL,
    descripcion     TEXT,
    ciudad          VARCHAR(100),
    activo          TINYINT(1)      NOT NULL DEFAULT 1,
    premium         TINYINT(1)      NOT NULL DEFAULT 0,
    fecha_registro  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tecnologias (
    id_tecnologia   INT             AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL UNIQUE,
    categoria       ENUM('Frontend','Backend','BBDD','IA','Otro')
                                    NOT NULL DEFAULT 'Otro'
);

-- Tabla intermedia de la relacion N:M entre usuarios y tecnologias
CREATE TABLE usuarios_tecnologias (
    id_usuario      INT             NOT NULL,
    id_tecnologia   INT             NOT NULL,
    nivel           ENUM('principiante','basico','intermedio','avanzado') NOT NULL DEFAULT 'principiante',
    PRIMARY KEY (id_usuario, id_tecnologia),
    CONSTRAINT fk_ut_usuario
        FOREIGN KEY (id_usuario)    REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ut_tecnologia
        FOREIGN KEY (id_tecnologia) REFERENCES tecnologias(id_tecnologia)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE likes (
    id_like             INT         AUTO_INCREMENT PRIMARY KEY,
    id_usuario_origen   INT         NOT NULL,
    id_usuario_destino  INT         NOT NULL,
    fecha_like          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_like_origen
        FOREIGN KEY (id_usuario_origen)  REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_like_destino
        FOREIGN KEY (id_usuario_destino) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_like UNIQUE (id_usuario_origen, id_usuario_destino)
);

-- id_usuario1 siempre menor que id_usuario2 para evitar duplicados
CREATE TABLE matches (
    id_match        INT         AUTO_INCREMENT PRIMARY KEY,
    id_usuario1     INT         NOT NULL,
    id_usuario2     INT         NOT NULL,
    fecha_match     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_u1
        FOREIGN KEY (id_usuario1) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_match_u2
        FOREIGN KEY (id_usuario2) REFERENCES usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_match UNIQUE (id_usuario1, id_usuario2)
);

-- Historial de accesos al sistema
CREATE TABLE login_historial (
    id_login        INT         AUTO_INCREMENT PRIMARY KEY,
    id_usuario      INT,
    email_intento   VARCHAR(150) NOT NULL,
    resultado       ENUM('exito','fallo') NOT NULL,
    fecha_login     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_login_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- ============================================================
-- INDICES
-- ============================================================

CREATE INDEX idx_usuarios_email    ON usuarios(email);
CREATE INDEX idx_usuarios_activo   ON usuarios(activo);
CREATE INDEX idx_likes_origen      ON likes(id_usuario_origen);
CREATE INDEX idx_likes_destino     ON likes(id_usuario_destino);
CREATE INDEX idx_matches_u1        ON matches(id_usuario1);
CREATE INDEX idx_matches_u2        ON matches(id_usuario2);

-- ============================================================
-- VISTAS
-- ============================================================

-- Vista de perfiles activos con sus tecnologias
CREATE VIEW vista_perfiles AS
SELECT
    u.id_usuario,
    u.nombre,
    u.ciudad,
    u.descripcion,
    u.premium,
    GROUP_CONCAT(t.nombre ORDER BY t.nombre SEPARATOR ', ') AS tecnologias
FROM usuarios u
LEFT JOIN usuarios_tecnologias ut ON u.id_usuario = ut.id_usuario
LEFT JOIN tecnologias t           ON ut.id_tecnologia = t.id_tecnologia
WHERE u.activo = 1
GROUP BY u.id_usuario, u.nombre, u.ciudad, u.descripcion, u.premium;

-- Vista de matches con nombres de usuarios y tecnologias en comun
CREATE VIEW vista_matches AS
SELECT
    m.id_match,
    u1.nombre   AS usuario_1,
    u2.nombre   AS usuario_2,
    m.fecha_match,
    GROUP_CONCAT(DISTINCT t.nombre ORDER BY t.nombre SEPARATOR ', ') AS tecnologias_comunes
FROM matches m
JOIN usuarios u1                ON m.id_usuario1      = u1.id_usuario
JOIN usuarios u2                ON m.id_usuario2      = u2.id_usuario
JOIN usuarios_tecnologias ut1   ON ut1.id_usuario     = u1.id_usuario
JOIN usuarios_tecnologias ut2   ON ut2.id_usuario     = u2.id_usuario
                                AND ut2.id_tecnologia  = ut1.id_tecnologia
JOIN tecnologias t              ON t.id_tecnologia    = ut1.id_tecnologia
GROUP BY m.id_match, u1.nombre, u2.nombre, m.fecha_match;

-- ============================================================
-- TRIGGERS
-- ============================================================

DELIMITER //

-- Trigger: impide que un usuario se de like a si mismo
CREATE TRIGGER tr_check_autolike
BEFORE INSERT ON likes
FOR EACH ROW
BEGIN
    IF NEW.id_usuario_origen = NEW.id_usuario_destino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un usuario no puede darse like a si mismo';
    END IF;
END //

-- Trigger: genera match automaticamente cuando hay like mutuo,
-- tecnologias en comun y el like original no ha expirado (30 dias)
CREATE TRIGGER tr_generar_match
AFTER INSERT ON likes
FOR EACH ROW
BEGIN
    DECLARE like_mutuo          INT DEFAULT 0;
    DECLARE match_existe        INT DEFAULT 0;
    DECLARE tecnologias_comunes INT DEFAULT 0;

    SELECT COUNT(*) INTO like_mutuo
    FROM likes
    WHERE id_usuario_origen  = NEW.id_usuario_destino
      AND id_usuario_destino = NEW.id_usuario_origen
      AND DATEDIFF(NOW(), fecha_like) <= 30;

    IF like_mutuo > 0 THEN

        SELECT COUNT(*) INTO tecnologias_comunes
        FROM usuarios_tecnologias ut1
        JOIN usuarios_tecnologias ut2
             ON ut1.id_tecnologia = ut2.id_tecnologia
        WHERE ut1.id_usuario = NEW.id_usuario_origen
          AND ut2.id_usuario = NEW.id_usuario_destino;

        IF tecnologias_comunes > 0 THEN

            SELECT COUNT(*) INTO match_existe
            FROM matches
            WHERE id_usuario1 = LEAST(NEW.id_usuario_origen, NEW.id_usuario_destino)
              AND id_usuario2 = GREATEST(NEW.id_usuario_origen, NEW.id_usuario_destino);

            IF match_existe = 0 THEN
                INSERT INTO matches (id_usuario1, id_usuario2)
                VALUES (
                    LEAST(NEW.id_usuario_origen, NEW.id_usuario_destino),
                    GREATEST(NEW.id_usuario_origen, NEW.id_usuario_destino)
                );
            END IF;

        END IF;
    END IF;
END //

-- Trigger: borrado logico, al eliminar un usuario lo marca como inactivo
CREATE TRIGGER tr_borrado_logico
BEFORE DELETE ON usuarios
FOR EACH ROW
BEGIN
    UPDATE usuarios SET activo = 0 WHERE id_usuario = OLD.id_usuario;
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Usuario desactivado correctamente';
END //

-- ============================================================
-- PROCEDIMIENTOS ALMACENADOS
-- ============================================================

CREATE PROCEDURE pa_registrar_like(
    IN p_origen   INT,
    IN p_destino  INT
)
BEGIN
    DECLARE like_mutuo          INT DEFAULT 0;
    DECLARE match_existe        INT DEFAULT 0;
    DECLARE tecnologias_comunes INT DEFAULT 0;

    IF p_origen = p_destino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un usuario no puede darse like a si mismo';
    ELSE
        INSERT INTO likes (id_usuario_origen, id_usuario_destino)
        VALUES (p_origen, p_destino);
    END IF;
END //

CREATE PROCEDURE pa_contar_matches(
    IN p_id_usuario INT
)
BEGIN
    IF p_id_usuario IS NULL THEN
        SELECT COUNT(*) AS total_matches
        FROM matches;
    ELSE
        SELECT COUNT(*) AS total_matches
        FROM matches
        WHERE id_usuario1 = p_id_usuario
          OR  id_usuario2 = p_id_usuario;
    END IF;
END //

CREATE PROCEDURE pa_cargar_datos_usuario(
    IN p_id_usuario INT
)
BEGIN
    SELECT
        u.id_usuario,
        u.nombre,
        u.email,
        u.descripcion,
        u.ciudad,
        u.activo,
        u.premium,
        u.fecha_registro
    FROM usuarios u
    WHERE u.id_usuario = p_id_usuario;

    SELECT
        t.nombre    AS tecnologia,
        t.categoria,
        ut.nivel
    FROM usuarios_tecnologias ut
    JOIN tecnologias t ON ut.id_tecnologia = t.id_tecnologia
    WHERE ut.id_usuario = p_id_usuario
    ORDER BY t.categoria, t.nombre;

    SELECT COUNT(*) AS total_matches
    FROM matches
    WHERE id_usuario1 = p_id_usuario
      OR  id_usuario2 = p_id_usuario;
END //

CREATE PROCEDURE pa_borrar_usuario(
    IN p_id_usuario INT
)
BEGIN
    DECLARE usuario_existe INT DEFAULT 0;

    SELECT COUNT(*) INTO usuario_existe
    FROM usuarios
    WHERE id_usuario = p_id_usuario AND activo = 1;

    IF usuario_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe o ya esta inactivo';
    ELSE
        UPDATE usuarios SET activo = 0 WHERE id_usuario = p_id_usuario;
    END IF;
END //

-- Calcula la compatibilidad entre dos usuarios usando SUM(CASE WHEN)
-- Devuelve el numero de tecnologias en comun y el porcentaje de compatibilidad
CREATE PROCEDURE pa_compatibilidad(
    IN p_usuario1 INT,
    IN p_usuario2 INT
)
BEGIN
    SELECT
        SUM(CASE WHEN ut2.id_tecnologia IS NOT NULL THEN 1 ELSE 0 END) AS tecnologias_comunes,
        COUNT(ut1.id_tecnologia) AS tecnologias_usuario1,
        ROUND(
            SUM(CASE WHEN ut2.id_tecnologia IS NOT NULL THEN 1 ELSE 0 END) * 100.0
            / NULLIF(COUNT(ut1.id_tecnologia), 0)
        , 1) AS porcentaje_compatibilidad
    FROM usuarios_tecnologias ut1
    LEFT JOIN usuarios_tecnologias ut2
           ON ut1.id_tecnologia = ut2.id_tecnologia
          AND ut2.id_usuario    = p_usuario2
    WHERE ut1.id_usuario = p_usuario1;
END //

DELIMITER ;

-- ============================================================
-- USUARIOS DE BASE DE DATOS Y PERMISOS
-- ============================================================

DROP USER IF EXISTS 'root_lovecode'@'%';
CREATE USER 'root_lovecode'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON lovecode.* TO 'root_lovecode'@'%';

DROP USER IF EXISTS 'desarrollador'@'%';
CREATE USER 'desarrollador'@'%' IDENTIFIED BY 'desarrollador';
GRANT SELECT, INSERT, UPDATE, DELETE ON lovecode.* TO 'desarrollador'@'%';
GRANT EXECUTE ON lovecode.* TO 'desarrollador'@'%';

DROP USER IF EXISTS 'lector'@'%';
CREATE USER 'lector'@'%' IDENTIFIED BY 'lector';
GRANT SELECT ON lovecode.* TO 'lector'@'%';

FLUSH PRIVILEGES;

-- ============================================================
-- DATOS DE PRUEBA
-- ============================================================

INSERT INTO usuarios (nombre, email, password, descripcion, ciudad) VALUES
('Perico',  'perico@lovecode.dev', 'perico',  'Apasionado del frontend y el diseno web.',   'Madrid'),
('Javier',  'javier@lovecode.dev', 'javier',  'Amor por los datos y el bigdata.',           'Murcia'),
('Sara',    'sara@lovecode.dev',   'sara',    'Empezando en el Fullstack.',                 'Valencia'),
('Jose',    'jose@lovecode.dev',   'jose',    'DevOps y enamorado de python.',              'Sevilla'),
('Marta',   'marta@lovecode.dev',  'marta',   'IA y negocios son lo que me mueven.',       'Bilbao');

INSERT INTO tecnologias (nombre, categoria) VALUES
('HTML',         'Frontend'),
('CSS',          'Frontend'),
('JavaScript',   'Frontend'),
('React',        'Frontend'),
('Java',         'Backend'),
('Spring Boot',  'Backend'),
('Python',       'Backend'),
('MySQL',        'BBDD'),
('PostgreSQL',   'BBDD'),
('Docker',       'Otro'),
('Git',          'Otro'),
('TensorFlow',   'IA');

INSERT INTO usuarios_tecnologias (id_usuario, id_tecnologia, nivel) VALUES
(1, 1,  'avanzado'),
(1, 3,  'intermedio'),
(1, 11, 'basico'),
(2, 5,  'avanzado'),
(2, 8,  'avanzado'),
(2, 11, 'intermedio'),
(3, 1,  'principiante'),
(3, 5,  'basico'),
(3, 11, 'intermedio'),
(4, 7,  'avanzado'),
(4, 11, 'avanzado'),
(5, 7,  'intermedio'),
(5, 12, 'avanzado'),
(5, 9,  'basico');

-- Los likes se insertan directamente para que el trigger tr_generar_match los procese
INSERT INTO likes (id_usuario_origen, id_usuario_destino) VALUES (1, 2);
INSERT INTO likes (id_usuario_origen, id_usuario_destino) VALUES (2, 1);
INSERT INTO likes (id_usuario_origen, id_usuario_destino) VALUES (3, 1);
INSERT INTO likes (id_usuario_origen, id_usuario_destino) VALUES (4, 5);
INSERT INTO likes (id_usuario_origen, id_usuario_destino) VALUES (5, 4);
