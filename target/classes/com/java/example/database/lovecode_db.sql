DROP DATABASE IF EXISTS lovecode;
CREATE DATABASE lovecode;

USE lovecode;

CREATE TABLE Usuarios (
    id_usuario      INT             AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL,
    email           VARCHAR(150)    NOT NULL UNIQUE,
    password        VARCHAR(255)    NOT NULL,
    descripcion     TEXT,
    foto_url        VARCHAR(500),
    ciudad          VARCHAR(100),
    fecha_registro  DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Tecnologias (
    id_tecnologia   INT             AUTO_INCREMENT PRIMARY KEY,
    nombre          VARCHAR(100)    NOT NULL UNIQUE,
    categoria       ENUM('Frontend','Backend','BBDD','DevOps','Mobile','IA','Otro')
                                    NOT NULL DEFAULT 'Otro'
);

-- Tabla intermedia N:M entre Usuarios y Tecnologias
CREATE TABLE Usuarios_Tecnologias (
    id_usuario      INT             NOT NULL,
    id_tecnologia   INT             NOT NULL,
    nivel           ENUM('basico','intermedio','avanzado') NOT NULL DEFAULT 'basico',
    PRIMARY KEY (id_usuario, id_tecnologia),
    CONSTRAINT fk_ut_usuario
        FOREIGN KEY (id_usuario)    REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_ut_tecnologia
        FOREIGN KEY (id_tecnologia) REFERENCES Tecnologias(id_tecnologia)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Likes (
    id_like             INT         AUTO_INCREMENT PRIMARY KEY,
    id_usuario_origen   INT         NOT NULL,
    id_usuario_destino  INT         NOT NULL,
    fecha_like          DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_like_origen
        FOREIGN KEY (id_usuario_origen)  REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_like_destino
        FOREIGN KEY (id_usuario_destino) REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_like UNIQUE (id_usuario_origen, id_usuario_destino)
);

-- id_usuario1 siempre menor que id_usuario2 para evitar duplicados
CREATE TABLE Matches (
    id_match        INT         AUTO_INCREMENT PRIMARY KEY,
    id_usuario1     INT         NOT NULL,
    id_usuario2     INT         NOT NULL,
    fecha_match     DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_match_u1
        FOREIGN KEY (id_usuario1) REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_match_u2
        FOREIGN KEY (id_usuario2) REFERENCES Usuarios(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT uq_match UNIQUE (id_usuario1, id_usuario2)
);

DELIMITER $$

CREATE PROCEDURE sp_registrar_like(
    IN p_origen   INT,
    IN p_destino  INT
)
BEGIN
    DECLARE like_inverso        INT DEFAULT 0;
    DECLARE match_existe        INT DEFAULT 0;
    DECLARE tecnologias_comunes INT DEFAULT 0;

    IF p_origen = p_destino THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Un usuario no puede darse like a si mismo';
    ELSE
        INSERT INTO Likes (id_usuario_origen, id_usuario_destino)
        VALUES (p_origen, p_destino);

        SELECT COUNT(*) INTO like_inverso
        FROM   Likes
        WHERE  id_usuario_origen  = p_destino
          AND  id_usuario_destino = p_origen;

        IF like_inverso > 0 THEN

            SELECT COUNT(*) INTO tecnologias_comunes
            FROM   Usuarios_Tecnologias ut1
            JOIN   Usuarios_Tecnologias ut2
                   ON ut1.id_tecnologia = ut2.id_tecnologia
            WHERE  ut1.id_usuario = p_origen
              AND  ut2.id_usuario = p_destino;

            IF tecnologias_comunes > 0 THEN

                SELECT COUNT(*) INTO match_existe
                FROM   Matches
                WHERE  id_usuario1 = LEAST(p_origen, p_destino)
                  AND  id_usuario2 = GREATEST(p_origen, p_destino);

                IF match_existe = 0 THEN
                    INSERT INTO Matches (id_usuario1, id_usuario2)
                    VALUES (
                        LEAST(p_origen, p_destino),
                        GREATEST(p_origen, p_destino)
                    );
                END IF;

            END IF;
        END IF;
    END IF;
END$$

CREATE PROCEDURE sp_contar_matches(
    IN p_id_usuario INT
)
BEGIN
    IF p_id_usuario IS NULL THEN
        SELECT COUNT(*) AS total_matches
        FROM   Matches;
    ELSE
        SELECT COUNT(*) AS total_matches
        FROM   Matches
        WHERE  id_usuario1 = p_id_usuario
          OR   id_usuario2 = p_id_usuario;
    END IF;
END$$

CREATE PROCEDURE sp_cargar_datos_usuario(
    IN p_id_usuario INT
)
BEGIN
    SELECT
        u.id_usuario,
        u.nombre,
        u.email,
        u.descripcion,
        u.foto_url,
        u.ciudad,
        u.fecha_registro
    FROM   Usuarios u
    WHERE  u.id_usuario = p_id_usuario;

    SELECT
        t.nombre    AS tecnologia,
        t.categoria,
        ut.nivel
    FROM   Usuarios_Tecnologias ut
    JOIN   Tecnologias t ON ut.id_tecnologia = t.id_tecnologia
    WHERE  ut.id_usuario = p_id_usuario
    ORDER  BY t.categoria, t.nombre;

    SELECT COUNT(*) AS total_matches
    FROM   Matches
    WHERE  id_usuario1 = p_id_usuario
      OR   id_usuario2 = p_id_usuario;
END$$

CREATE PROCEDURE sp_borrar_usuario(
    IN p_id_usuario INT
)
BEGIN
    DECLARE usuario_existe INT DEFAULT 0;

    SELECT COUNT(*) INTO usuario_existe
    FROM   Usuarios
    WHERE  id_usuario = p_id_usuario;

    IF usuario_existe = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'El usuario no existe';
    ELSE
        DELETE FROM Usuarios
        WHERE  id_usuario = p_id_usuario;
    END IF;
END$$

DELIMITER ;

DROP USER IF EXISTS 'root_lovecode'@'localhost';
CREATE USER 'root_lovecode'@'localhost' IDENTIFIED BY 'root_pass_2024';
GRANT ALL PRIVILEGES ON lovecode.* TO 'root_lovecode'@'localhost';

DROP USER IF EXISTS 'desarrollador'@'localhost';
CREATE USER 'desarrollador'@'localhost' IDENTIFIED BY 'dev_pass_2024';
GRANT SELECT, INSERT, UPDATE, DELETE ON lovecode.* TO 'desarrollador'@'localhost';
GRANT EXECUTE ON lovecode.* TO 'desarrollador'@'localhost';

DROP USER IF EXISTS 'lector'@'localhost';
CREATE USER 'lector'@'localhost' IDENTIFIED BY 'lector_pass_2024';
GRANT SELECT ON lovecode.* TO 'lector'@'localhost';

FLUSH PRIVILEGES;

INSERT INTO Usuarios (nombre, email, password, descripcion, ciudad) VALUES
('Ana Garcia',    'ana@lovecode.dev',    'pass_ana',    'Apasionada del frontend y el diseno UX.',    'Madrid'),
('Carlos Ruiz',   'carlos@lovecode.dev', 'pass_carlos', 'Backend developer con amor por los datos.',  'Barcelona'),
('Lucia Perez',   'lucia@lovecode.dev',  'pass_lucia',  'Fullstack en constante aprendizaje.',        'Valencia'),
('Marcos Diaz',   'marcos@lovecode.dev', 'pass_marcos', 'DevOps y apasionado de la automatizacion.',  'Sevilla'),
('Sara Lopez',    'sara@lovecode.dev',   'pass_sara',   'IA y machine learning son mi mundo.',        'Bilbao');

INSERT INTO Tecnologias (nombre, categoria) VALUES
('HTML',         'Frontend'),
('CSS',          'Frontend'),
('JavaScript',   'Frontend'),
('React',        'Frontend'),
('Java',         'Backend'),
('Spring Boot',  'Backend'),
('Python',       'Backend'),
('MySQL',        'BBDD'),
('PostgreSQL',   'BBDD'),
('Docker',       'DevOps'),
('Git',          'DevOps'),
('TensorFlow',   'IA');

INSERT INTO Usuarios_Tecnologias (id_usuario, id_tecnologia, nivel) VALUES
(1, 1,  'avanzado'),
(1, 2,  'avanzado'),
(1, 3,  'intermedio'),
(1, 4,  'intermedio'),
(1, 11, 'intermedio'),
(2, 5,  'avanzado'),
(2, 6,  'intermedio'),
(2, 8,  'avanzado'),
(2, 11, 'intermedio'),
(3, 1,  'avanzado'),
(3, 3,  'avanzado'),
(3, 5,  'intermedio'),
(3, 8,  'intermedio'),
(3, 11, 'avanzado'),
(4, 10, 'avanzado'),
(4, 11, 'avanzado'),
(4, 5,  'basico'),
(5, 7,  'avanzado'),
(5, 12, 'avanzado'),
(5, 9,  'intermedio');

CALL sp_registrar_like(1, 2);
CALL sp_registrar_like(2, 1);
CALL sp_registrar_like(3, 1);
CALL sp_registrar_like(4, 5);
CALL sp_registrar_like(5, 4);