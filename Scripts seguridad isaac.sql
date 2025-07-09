
-----------------------------------------------------------------------------------------Create_table----------------------------------------------------------------------------------------------

CREATE SEQUENCE seq_lugar START WITH 1 INCREMENT BY 1;

CREATE TABLE lugar(
  id_lugar NUMERIC DEFAULT nextval('seq_lugar') primary key,
  nombre_lugar VARCHAR(50) NOT NULL,
  tipo VARCHAR(20),
  id_jerarquia NUMERIC,
  CONSTRAINT ch_tipo CHECK(tipo IN('ciudad', 'pais')),
  CONSTRAINT fk_jerarquia FOREIGN KEY(id_jerarquia) REFERENCES LUGAR(id_lugar)
);

CREATE SEQUENCE seq_obra START WITH 1 INCREMENT BY 1;
CREATE TABLE obra(
    id_obra NUMERIC DEFAULT nextval('seq_obra') PRIMARY KEY,
    nombre_obra VARCHAR(250) NOT NULL, 
    fecha_periodo VARCHAR(100) NOT NULL,
    tipo_obra VARCHAR(9) NOT NULL,
    dimensiones VARCHAR(80) NOT NULL,
    estilo_descripcion VARCHAR(80) NOT NULL, 
    descripcion_materiales_tecnicas VARCHAR(300) NOT NULL,
    CONSTRAINT ch_tipo_obra CHECK (tipo_obra IN('pintura', 'escultura'))
);

CREATE SEQUENCE seq_artista START WITH 1 INCREMENT BY 1;
CREATE TABLE artista(
    id_artista NUMERIC DEFAULT nextval('seq_artista') primary key,
    nombre_artista VARCHAR(60),
    apellido_artista VARCHAR(60),
    fecha_nacimiento DATE, 
    apodo_artista VARCHAR(60), 
    fecha_muerte DATE,
    descripcion_estilo_tecnicas VARCHAR(300) NOT NULL
);

CREATE TABLE art_obra(
    id_artista NUMERIC NOT NULL,
    id_obra NUMERIC NOT NULL,
    CONSTRAINT fk_artista FOREIGN KEY(id_artista) REFERENCES artista(id_artista),
    CONSTRAINT fk_obra FOREIGN KEY(id_obra) REFERENCES obra(id_obra),
    PRIMARY KEY(id_artista, id_obra)
);

CREATE SEQUENCE seq_museo START WITH 1 INCREMENT BY 1;
CREATE TABLE museo(
  id_museo NUMERIC DEFAULT nextval('seq_museo') primary key,
  nombre VARCHAR(50) NOT NULL,
  mision VARCHAR(350),
  fecha_fundacion DATE NOT NULL, 
  id_lugar NUMERIC NOT NULL, 
  CONSTRAINT fk_lugar FOREIGN KEY(id_lugar) REFERENCES lugar(id_lugar)
);

CREATE TABLE resumen_hist(
    id_museo NUMERIC NOT NULL,
    ano DATE NOT NULL,
    hechos_hist VARCHAR(350) NOT NULL,
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY (id_museo, ano)
);

CREATE TABLE tipo_ticket_historico(
    id_museo NUMERIC NOT NULL,
    fecha_inicio TIMESTAMP NOT NULL,
    precio NUMERIC NOT NULL, 
    tipo_ticket VARCHAR(15) NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    CONSTRAINT ch_tipo_ticket CHECK (tipo_ticket IN('niño', 'adulto', 'tercera edad')),
    PRIMARY KEY(id_museo, fecha_inicio)
);

CREATE SEQUENCE seq_evento START WITH 1 INCREMENT BY 1;
CREATE TABLE evento(
    id_museo NUMERIC NOT NULL,
    id_evento NUMERIC DEFAULT nextval('seq_evento') NOT NULL,
    fecha_inicio_evento DATE NOT NULL,
    fecha_fin_evento DATE NOT NULL, 
    nombre_evento VARCHAR(150) NOT NULL,
    institucion_educativa VARCHAR(150), 
    cantidad_asistentes NUMERIC,
    lugar_exposicion VARCHAR(100),
    costo_persona NUMERIC,  
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY(id_museo, id_evento)
);

CREATE SEQUENCE seq_ticket START WITH 1 INCREMENT BY 1;
CREATE TABLE ticket(
    id_museo NUMERIC NOT NULL,
    id_ticket NUMERIC DEFAULT nextval('seq_ticket') NOT NULL,
    precio NUMERIC NOT NULL,
    tipo_ticket VARCHAR(20) NOT NULL,
    fecha_hora_ticket DATE NOT NULL,
    CONSTRAINT ch_tipo_ticket CHECK (tipo_ticket IN('niño', 'adulto', 'tercera edad')),
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY(id_museo, id_ticket)
);

CREATE TABLE horario(
  id_museo NUMERIC NOT NULL,
  dia NUMERIC NOT NULL,
  hora_apertura TIME NOT NULL, 
  hora_cierre TIME NOT NULL,
  CONSTRAINT id_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
  CONSTRAINT rang_dia  CHECK(dia between 1 and 7),
  PRIMARY KEY (id_museo, dia)
);

CREATE SEQUENCE seq_empleado_prof START WITH 1 INCREMENT BY 1;
CREATE TABLE empleado_profesional(
    id_empleado_prof NUMERIC DEFAULT nextval('seq_empleado_prof') primary key,
    primer_nombre VARCHAR(20) NOT NULL,
    primer_apellido VARCHAR(20) NOT NULL, 
    segundo_apellido varchar(20) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    doc_identidad NUMERIC NOT NULL,
    dato_contacto VARCHAR(100),
    segundo_nombre VARCHAR(20)
);

CREATE SEQUENCE seq_formacion START WITH 1 INCREMENT BY 1;
CREATE TABLE formacion_profesional(
    id_empleado_prof NUMERIC NOT NULL,
    id_formacion NUMERIC DEFAULT nextval('seq_formacion') NOT NULL,
    nombre_titulo VARCHAR(100) NOT NULL,
    ano DATE NOT NULL, 
    descripcion_especialidad VARCHAR(200) NOT NULL, 
    CONSTRAINT fk_empleado_prof FOREIGN KEY(id_empleado_prof) REFERENCES empleado_profesional(id_empleado_prof),
    PRIMARY KEY(id_empleado_prof, id_formacion)
);

CREATE SEQUENCE seq_idioma START WITH 1 INCREMENT BY 1;
CREATE TABLE idioma(
    id_idioma NUMERIC DEFAULT nextval('seq_idioma') PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);

CREATE TABLE emp_idi(
    id_idioma NUMERIC NOT NULL,
    id_empleado_prof NUMERIC NOT NULL,
    CONSTRAINT fk_idioma FOREIGN KEY(id_idioma) REFERENCES idioma(id_idioma),
    CONSTRAINT fk_empleado_prof FOREIGN KEY(id_empleado_prof) REFERENCES empleado_profesional(id_empleado_prof),
    PRIMARY KEY(id_idioma, id_empleado_prof)
);

CREATE SEQUENCE seq_estructura_org START WITH 1 INCREMENT BY 1;
CREATE TABLE estructura_organizacional(
    id_museo NUMERIC NOT NULL,
    id_estructura_org NUMERIC DEFAULT nextval('seq_estructura_org') NOT NULL, 
    nombre VARCHAR(100) NOT NULL,
    nivel VARCHAR(50) NOT NULL, 
    tipo VARCHAR(50) NOT NULL,
    id_jerarquia_estructura NUMERIC,
    id_jerarquia_museo NUMERIC,
    CONSTRAINT ch_nivel CHECK(nivel IN('Nivel 1', 'Nivel 2', 'Nivel 3', 'Nivel 4')),
    CONSTRAINT ch_tipo CHECK(tipo IN('direccion', 'departamento', 'seccion', 'subdepartamento', 'subseccion')),
    CONSTRAINT fk_jerarquia FOREIGN KEY(id_jerarquia_museo, id_jerarquia_estructura) REFERENCES estructura_organizacional(id_museo, id_estructura_org),
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    PRIMARY KEY(id_museo, id_estructura_org)
); 

CREATE SEQUENCE seq_coleccion START WITH 1 INCREMENT BY 1;
CREATE TABLE coleccion_permanente(
    id_museo NUMERIC NOT NULL,
    id_estructura_org NUMERIC NOT NULL,
    id_coleccion NUMERIC DEFAULT nextval('seq_coleccion') NOT NULL,
    nombre_coleccion VARCHAR(80) NOT NULL,
    descripcion_caracteristica VARCHAR(300) NOT NULL,
    palabra_clave VARCHAR(50) NOT NULL,
    orden_recorrido NUMERIC NOT NULL, 
    CONSTRAINT fk_estructura_org FOREIGN KEY(id_museo, id_estructura_org) REFERENCES estructura_organizacional(id_museo, id_estructura_org),
    PRIMARY KEY( id_museo, id_estructura_org, id_coleccion)
);

CREATE SEQUENCE seq_estructura_fisica START WITH 1 INCREMENT BY 1;
CREATE TABLE estructura_fisica(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC DEFAULT nextval('seq_estructura_fisica') NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    tipo_estructura VARCHAR(15),
    descripcion VARCHAR(150),
    direccion VARCHAR(250),
    id_jerarquia_museo NUMERIC,
    id_jerarquia_estructura NUMERIC,
    CONSTRAINT fk_jerarquia_estructura FOREIGN KEY(id_jerarquia_museo, id_jerarquia_estructura) REFERENCES estructura_fisica(id_museo, id_estructura_fisica),
    CONSTRAINT fk_museo FOREIGN KEY(id_museo) REFERENCES museo(id_museo),
    CONSTRAINT ch_tipo_estructura CHECK(tipo_estructura IN('edificio', 'piso', 'area seccion')),
    PRIMARY KEY(id_museo, id_estructura_fisica) 
);

CREATE SEQUENCE seq_sala START WITH 1 INCREMENT BY 1;
CREATE TABLE sala_exposicion(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL,
    id_sala NUMERIC DEFAULT nextval('seq_sala') NOT NULL, 
    nombre_sala VARCHAR(50),
    descripcion VARCHAR(250),
    CONSTRAINT fk_estructura_fisica FOREIGN KEY(id_museo, id_estructura_fisica) REFERENCES estructura_fisica(id_museo, id_estructura_fisica),
    PRIMARY KEY(id_museo, id_estructura_fisica, id_sala)
);

CREATE TABLE col_sal(
    id_museo_sala NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL, 
    id_sala NUMERIC NOT NULL,
    id_museo_coleccion NUMERIC NOT NULL,
    id_estructura_org NUMERIC NOT NULL, 
    id_coleccion NUMERIC NOT NULL, 
    orden_recorrido NUMERIC NOT NULL,
    CONSTRAINT fk_sala FOREIGN KEY(id_museo_sala, id_estructura_fisica, id_sala) REFERENCES sala_exposicion(id_museo, id_estructura_fisica, id_sala),
    CONSTRAINT fk_coleccion FOREIGN KEY(id_museo_coleccion, id_estructura_org, id_coleccion) REFERENCES coleccion_permanente(id_museo, id_estructura_org, id_coleccion),
    PRIMARY KEY(id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion)
);

CREATE TABLE hist_cierre(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL,
    id_sala NUMERIC NOT NULL,
    fecha_ini DATE NOT NULL,
    fecha_fin DATE,
    CONSTRAINT fk_sala_exposicion FOREIGN KEY(id_museo, id_estructura_fisica, id_sala) REFERENCES sala_exposicion(id_museo, id_estructura_fisica, id_sala),
    PRIMARY KEY(id_museo, id_estructura_fisica, id_sala)
);

CREATE SEQUENCE seq_empleado_mv START WITH 1 INCREMENT BY 1;
CREATE TABLE empleado_mantenimiento_vigilancia(
    id_empleado_mantenimiento_vigilancia NUMERIC DEFAULT nextval('seq_empleado_mv') primary key,
    nombre_empleado_mv VARCHAR(20) NOT NULL,
    apellido_empleado_mv VARCHAR(20) NOT NULL, 
    doc_identidad NUMERIC NOT NULL,
    tipo VARCHAR(20) NOT NULL,
    CONSTRAINT ch_tipo CHECK(tipo IN('vigilancia', 'mantenimiento'))
);

CREATE TABLE asignacion_mensual(
    id_museo NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL, 
    id_empleado_mantenimiento_vigilancia NUMERIC NOT NULL,
    mes_ano DATE NOT NULL,
    turno VARCHAR(15),
    CONSTRAINT ch_turno CHECK(turno IN('matutino', 'vesperino', 'nocturno')),
    CONSTRAINT fk_estructura_fisica FOREIGN KEY(id_museo, id_estructura_fisica) REFERENCES estructura_fisica(id_museo, id_estructura_fisica),
    CONSTRAINT fk_empleado_mv FOREIGN KEY(id_empleado_mantenimiento_vigilancia) REFERENCES empleado_mantenimiento_vigilancia(id_empleado_mantenimiento_vigilancia),
    PRIMARY KEY(id_museo, id_estructura_fisica, id_empleado_mantenimiento_vigilancia, mes_ano)
);

CREATE TABLE historico_empleado(
    id_empleado NUMERIC NOT NULL,
    id_museo NUMERIC NOT NULL, 
    id_estructura_org NUMERIC NOT NULL,
    fecha_inicio DATE NOT NULL,
    rol_empleado VARCHAR(70) NOT NULL,
    fecha_fin DATE, 
    CONSTRAINT fk_estructura_org FOREIGN KEY(id_museo, id_estructura_org) REFERENCES estructura_organizacional(id_museo, id_estructura_org),
    CONSTRAINT fk_empleado FOREIGN KEY(id_empleado) REFERENCES empleado_profesional(id_empleado_prof),
    CONSTRAINT ch_rol CHECK(rol_empleado IN('curador', 'restaurador', 'administrativo', 'director')),
    PRIMARY KEY(id_empleado, id_museo, id_estructura_org, fecha_inicio)
);

CREATE SEQUENCE seq_historico_obra START WITH 1 INCREMENT BY 1;
CREATE TABLE historico_obra_movimiento(
  
    id_obra NUMERIC NOT NULL,
    id_historico_obra_movimiento NUMERIC DEFAULT nextval('seq_historico_obra') NOT NULL,
    fecha_inicio DATE NOT NULL,
    tipo_obtencion VARCHAR NOT NULL,
    destacada VARCHAR(2) NOT NULL,
  
    id_museo_sala NUMERIC NOT NULL,
    id_estructura_fisica NUMERIC NOT NULL,
    id_sala NUMERIC NOT NULL,
  
    id_museo_coleccion NUMERIC NOT NULL,
    id_estructura_org_coleccion NUMERIC NOT NULL,
    id_coleccion NUMERIC NOT NULL,

    id_museo_empleado NUMERIC NOT NULL,
    id_estructura_org_empleado NUMERIC NOT NULL,
    id_empleado NUMERIC NOT NULL, 
    fecha_inicio_empleado DATE NOT NULL,
  
    fecha_fin DATE, 
    valor_obra NUMERIC NOT NULL,
    orden_recomendado NUMERIC, 

    CONSTRAINT fk_obra FOREIGN KEY(id_obra) REFERENCES obra(id_obra),
    CONSTRAINT fk_sala FOREIGN KEY(id_museo_sala, id_estructura_fisica, id_sala) REFERENCES sala_exposicion(id_museo, id_estructura_fisica, id_sala),  
    CONSTRAINT fk_coleccion FOREIGN KEY(id_museo_coleccion, id_estructura_org_coleccion, id_coleccion) REFERENCES coleccion_permanente(id_museo, id_estructura_org, id_coleccion),
    CONSTRAINT fk_historico_empleado FOREIGN KEY(id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado) REFERENCES historico_empleado(id_museo, id_estructura_org, id_empleado, fecha_inicio),
    CONSTRAINT ch_tipo_obtencion CHECK(tipo_obtencion IN('comprado', 'donado', 'comprado a otro museo', 'donado de otro museo')),
    CONSTRAINT ch_destacada CHECK(destacada IN('si', 'no')),
    primary key(id_obra, id_historico_obra_movimiento)
);

CREATE SEQUENCE seq_mantenimiento_obra START WITH 1 INCREMENT BY 1;

CREATE TABLE mantenimiento_obra(
    id_obra NUMERIC NOT NULL,
    id_historico_obra_movimiento NUMERIC NOT NULL,
    id_mantenimiento_obra NUMERIC DEFAULT nextval('seq_mantenimiento_obra') NOT NULL, 
    actividad VARCHAR(250) NOT NULL,
    frecuencia NUMERIC NOT NULL, 
    tipo_resposable VARCHAR(15), 
    CONSTRAINT ch_tipo_responsable CHECK(tipo_resposable IN('curador', 'restaurador', 'otro')),
    CONSTRAINT fk_historico_obra_movimiento FOREIGN KEY(id_obra, id_historico_obra_movimiento) REFERENCES historico_obra_movimiento(id_obra, id_historico_obra_movimiento),
    PRIMARY KEY(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra)
);

CREATE SEQUENCE seq_historico_mant_re START WITH 1 INCREMENT BY 1;
CREATE TABLE historico_mantenimiento_realizado(
    id_obra NUMERIC NOT NULL,
    id_historico_obra_movimiento NUMERIC NOT NULL,
    id_mantenimiento_obra NUMERIC NOT NULL,
    id_historico_mant_re NUMERIC DEFAULT nextval('seq_historico_mant_re') NOT NULL,
    fecha_inicio DATE NOT NULL, 
    observaciones VARCHAR(250) NOT NULL,
    id_empleado NUMERIC NOT NULL,
    id_museo NUMERIC NOT NULL, 
    id_estructura_org NUMERIC NOT NULL,
    fecha_inicio_hist_empleado DATE NOT NULL,
    fecha_fin DATE, 
    CONSTRAINT fk_historico_empleado FOREIGN KEY(id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado) REFERENCES historico_empleado(id_empleado, id_museo, id_estructura_org, fecha_inicio),
    CONSTRAINT fk_mantenimiento_obra FOREIGN KEY(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra) REFERENCES mantenimiento_obra(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra),
    PRIMARY KEY(id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, id_historico_mant_re)
);

SET datestyle = 'ISO, MDY';

-----------------------------------------------------------------------------------------------Inserts--------------------------------------------------------------------------------------------

INSERT INTO lugar (nombre_lugar, tipo, id_jerarquia) VALUES
('canada', 'pais', NULL),
('mexico', 'pais', NULL),
('china', 'pais', NULL),
('australia', 'pais', NULL);

INSERT INTO lugar (nombre_lugar, tipo, id_jerarquia) VALUES
('vancouver', 'ciudad', 1),
('montreal', 'ciudad', 1),
('ciudad de mexico', 'ciudad', 2),
('monterrey', 'ciudad', 2),
('nanjing', 'ciudad', 3),
('guangzhou', 'ciudad', 3),
('canberra', 'ciudad', 4),
('melbourne', 'ciudad', 4);

-- Sentencias INSERT para la tabla artista
INSERT INTO artista (nombre_artista, apellido_artista, fecha_nacimiento, apodo_artista, fecha_muerte, descripcion_estilo_tecnicas) VALUES
('Emily', 'Carr', '1871-12-13', NULL, '1945-03-02', 'Pintora canadiense conocida por sus paisajes del noroeste del Pacífico y sus representaciones de la cultura indígena.'),
('Vincent', 'van Gogh', '1853-03-30', NULL, '1890-07-29', 'Pintor neerlandés, una de las figuras más influyentes en la historia del arte occidental, precursor del expresionismo.'),
('Henri', 'Matisse', '1869-12-31', NULL, '1954-11-03', 'Pintor francés, líder del movimiento fauvista, conocido por su uso del color y el dibujo fluido.'),
('Amedeo', 'Modigliani', '1884-07-12', NULL, '1920-01-24', 'Pintor y escultor italiano, conocido por sus retratos y desnudos con caras alargadas y figuras estilizadas.'),
('José María', 'Velasco', '1840-07-06', NULL, '1912-02-17', 'Pintor paisajista mexicano, considerado uno de los artistas más destacados del siglo XIX en México, maestro del paisaje académico.'),
('Raúl', 'Anguiano', '1915-02-26', NULL, '2006-01-13', 'Pintor y muralista mexicano, figura clave de la segunda generación de la Escuela Mexicana de Pintura, con fuerte compromiso social.'),
('Ricardo', 'Mazal', '1963-02-17', NULL, NULL, 'Pintor mexicano contemporáneo conocido por sus grandes lienzos abstractos y el uso de la cera, explorando la espiritualidad y la naturaleza.'),
('Manuel', 'Felguérez', '1928-12-12', NULL, '2020-06-08', 'Escultor y pintor abstracto mexicano, pionero del arte abstracto en México, integrante de la Generación de la Ruptura.'),
('Gabriel', 'Orozco', '1962-04-27', NULL, NULL, 'Artista conceptual mexicano conocido por sus instalaciones, fotografía, escultura y dibujo, a menudo utilizando objetos cotidianos y la intervención del espacio.'),
('Fan', 'Zeng', '1938-07-05', NULL, NULL, 'Pintor y calígrafo chino, conocido por sus figuras y su estilo tradicional con un toque moderno, maestro de la pintura de personajes.'),
('Wu', 'Guanzhong', '1919-08-29', NULL, '2010-06-25', 'Uno de los pintores más importantes de China del siglo XX, conocido por sus paisajes que combinan la técnica china con la occidental y su estilo impresionista.'),
('Xu', 'Bing', '1955-02-08', NULL, NULL, 'Artista conceptual chino conocido por sus trabajos que exploran el lenguaje, la caligrafía y la relación entre culturas, con un enfoque en la palabra escrita.'),
('Gao', 'Jianfu', '1879-10-12', NULL, '1951-06-22', 'Fundador de la Escuela Lingnan de pintura, que buscaba modernizar la pintura china fusionándola con influencias occidentales.'),
('Chen', 'Shuren', '1884-03-03', NULL, '1962-04-10', 'Cofundador de la Escuela Lingnan, conocido por sus paisajes y representaciones de animales y plantas, con un estilo innovador y vibrante.'),
('Arthur', 'Streeton', '1867-04-08', NULL, '1943-09-01', 'Pintor impresionista australiano, figura clave de la Escuela de Heidelberg, famoso por sus paisajes soleados y escenas rurales.'),
('Jean-Baptiste-Camille', 'Corot', '1796-07-17', NULL, '1875-02-22', 'Pintor paisajista francés, figura clave de la Escuela de Barbizon, conocido por sus atmósferas poéticas y el uso sutil de la luz.'),
('Mark', 'Rothko', '1903-09-25', NULL, '1970-02-25', 'Pintor estadounidense de origen letón, pionero del Expresionismo Abstracto y la Pintura de Campos de Color, famoso por sus grandes campos de color que evocan emociones.');


-- Sentencias INSERT para la tabla obra
INSERT INTO obra (nombre_obra, fecha_periodo, tipo_obra, dimensiones, estilo_descripcion, descripcion_materiales_tecnicas) VALUES
-- Museo de Arte de Vancouver
('The Crazy One', '1937', 'pintura', '112.4 x 69.8 cm', 'Modernismo Canadiense, Post-Impresionismo', 'Óleo sobre papel pegado a tablero'),
('Forest, British Columbia', '1932', 'pintura', '108 x 68 cm', 'Modernismo Canadiense, Expresionismo', 'Óleo sobre lienzo'),
('Indian Church', '1929', 'pintura', '109 x 68 cm', 'Modernismo Canadiense', 'Óleo sobre lienzo'),

-- Museo de Arte de Montreal
('Vase of Sunflowers', '1888', 'pintura', '92.1 x 73 cm', 'Post-Impresionismo', 'Óleo sobre lienzo'),
('The Reading', '1905-1906', 'pintura', '65.4 x 80.6 cm', 'Fauvismo', 'Óleo sobre lienzo'),
('Nude with Raised Arms', '1918', 'pintura', '92 x 60 cm', 'Modernismo, Expresionismo', 'Óleo sobre lienzo'),

-- Museo de la Ciudad de México
('Visión de la Ciudad de México', '1877', 'pintura', 'Mural, 300 x 500 cm', 'Paisajismo Mexicano, Academicismo', 'Óleo sobre muro'),
('Murales del Patio Central', '1961', 'pintura', 'Mural, variable', 'Muralismo Mexicano', 'Fresco sobre muro'),
('Maqueta de la antigua Tenochtitlán', 'Siglo XX', 'escultura', '500 x 300 cm', 'Realismo, Reconstrucción histórica', 'Plástico, madera, pigmentos'), -- Autor desconocido

-- Museo De Arte Contemporáneo De Monterrey (MARCO)
('Cabeza Vaca', '2000', 'pintura', '200 x 200 cm', 'Abstracción Lírica', 'Óleo y cera sobre lienzo'),
('Paisaje con nubes', '1970', 'pintura', '150 x 180 cm', 'Abstracción geométrica', 'Óleo sobre lienzo'),
('Sin Título (Serie Columnas)', '1995', 'escultura', '250 x 50 x 50 cm', 'Arte Conceptual, Escultura Minimalista', 'Acero, madera reciclada'),

-- Jiangsu Art Museum
('Montañas y Ríos de Nanjing', '2010', 'pintura', '180 x 90 cm', 'Pintura tradicional china, paisajismo contemporáneo', 'Tinta y color sobre papel de arroz'),
('El Jardín Secreto', '1985', 'pintura', '120 x 120 cm', 'Modernismo chino, fusión de tradición y abstracción', 'Óleo sobre lienzo'),
('Armonía Urbana', '2005', 'escultura', '300 x 100 x 100 cm', 'Arte conceptual, instalación contemporánea', 'Instalación de elementos reciclados y luz'),

-- Museo de Guangdong
('Pintura de Flor y Pájaro (Estilo Lingnan)', '1930', 'pintura', '90 x 45 cm', 'Escuela Lingnan, Tinta y color', 'Tinta y color sobre papel de arroz'),
('Paisaje con Cascada', '1925', 'pintura', '110 x 55 cm', 'Escuela Lingnan, Realismo', 'Tinta y color sobre seda'),
('Jarrón de Cerámica de Guangdong', 'Dinastía Qing (Siglo XVIII)', 'escultura', '40 cm de alto, 20 cm de diámetro', 'Cerámica de Shiwan, Estilo clásico', 'Cerámica esmaltada'), -- Autor desconocido

-- Museo Nacional de Australia
('Canoa de corteza indígena', 'Siglo XIX', 'escultura', '500 x 80 x 60 cm', 'Arte indígena australiano, funcional', 'Corteza de árbol, pigmentos naturales'), -- Autor desconocido
('Wandjina (Pintura Rupestre)', 'Antigüedad a Siglo XX', 'pintura', 'Variable (ej. 150 x 100 cm)', 'Arte indígena australiano, espiritual', 'Pigmentos naturales sobre roca o lienzo'), -- Autor desconocido
('Boomerang Ceremonial con Grabados', 'Principios del Siglo XX', 'escultura', '80 x 30 x 5 cm', 'Arte aborigen, utilitario y ceremonial', 'Madera tallada y grabada'), -- Autor desconocido

-- Galería Nacional de Victoria
('The Bridal Party', '1889', 'pintura', '92.1 x 152.4 cm', 'Impresionismo Australiano (Heidelberg School)', 'Óleo sobre lienzo'),
('The Bath of Diana', '1855', 'pintura', '130.2 x 98.4 cm', 'Realismo, Paisajismo', 'Óleo sobre lienzo'),
('Untitled (Large Blue)', '1959', 'pintura', '200 x 200 cm', 'Expresionismo Abstracto, Pintura de Campos de Color', 'Óleo sobre lienzo');


-- Sentencias INSERT para la tabla art_obra
INSERT INTO art_obra (id_artista, id_obra) VALUES
-- Museo de Arte de Vancouver (Emily Carr)
(1, 1),
(1, 2),
(1, 3),

-- Museo de Arte de Montreal
(2, 4), -- Vincent van Gogh
(3, 5), -- Henri Matisse
(4, 6), -- Amedeo Modigliani

-- Museo de la Ciudad de México (Obras con autor conocido)
(5, 7), -- José María Velasco
(6, 8), -- Raúl Anguiano
-- Nota: La obra con id_obra 9 ('Maqueta de la antigua Tenochtitlán') no tiene un autor conocido, por lo tanto no se incluye en art_obra.

-- Museo De Arte Contemporáneo De Monterrey (MARCO)
(7, 10), -- Ricardo Mazal
(8, 11), -- Manuel Felguérez
(9, 12), -- Gabriel Orozco

-- Jiangsu Art Museum
(10, 13), -- Fan Zeng
(11, 14), -- Wu Guanzhong
(12, 15), -- Xu Bing

-- Museo de Guangdong
(13, 16), -- Gao Jianfu
(14, 17), -- Chen Shuren
-- Nota: La obra con id_obra 18 ('Jarrón de Cerámica de Guangdong') no tiene un autor conocido, por lo tanto no se incluye en art_obra.

-- Museo Nacional de Australia
-- Nota: Las obras con id_obra 19, 20, 21 no tienen autores conocidos, por lo tanto no se incluyen en art_obra.

-- Galería Nacional de Victoria
(15, 22), -- Arthur Streeton
(16, 23), -- Jean-Baptiste-Camille Corot
(17, 24); -- Mark Rothko


INSERT INTO museo (nombre, mision, fecha_fundacion, id_lugar) VALUES
('Museo de Arte de Vancouvert', 'Fomentar el arte de la costa oeste de Canada', '1931-01-01', 5),
('Museo de Arte de Montreal', 'Preservar y compartir arte de todas las epocas', '1860-04-23', 6),
('Museo de la Ciudad de México', 'Narrar la historia de la ciudad', '1964-10-31', 7),
('Museo De Arte Contemporáneo De Monterrey', 'Promover el arte contemporáneo', '1991-06-28', 8),
('Jiangsu Art Museum', 'Exhibir arte contemporáneo chino', '1936-01-01', 9),
('Museo de Guangdong', 'Difundir la cultura y arte de Guangdong', '1959-01-01', 10),
('Museo Nacional de Australia', 'Explorar la historia australiana', '2001-03-11', 11),
('Galería Nacional de Victoria', 'Ser un epicentro de la creatividad y la innovación artística', '1861-01-01', 12);

INSERT INTO resumen_hist (id_museo, ano, hechos_hist) VALUES
(1, '1931-01-01', 'Fundación del Museo de Arte de Vancouver, con la misión de fomentar el arte de la costa oeste de Canadá.'),
(1, '1955-01-01', 'El museo inauguró una importante exposición sobre el modernismo canadiense, atrayendo a visitantes de todo el país.'),
(2, '1860-04-23', 'Establecimiento del Museo de Arte de Montreal, iniciando su misión de preservar y compartir arte de todas las épocas.'),
(2, '1900-01-01', 'El museo expandió sus galerías para acomodar una creciente colección de arte europeo y canadiense.'),
(3, '1964-10-31', 'Inauguración del Museo de la Ciudad de México, con el propósito de narrar la rica historia de la capital.'),
(3, '1980-01-01', 'El museo implementó un programa educativo innovador para escuelas, enfocándose en la arqueología y la vida colonial de la ciudad.'),
(4, '1991-06-28', 'Fundación del Museo de Arte Contemporáneo de Monterrey, marcando un hito en la promoción del arte contemporáneo en México.'),
(4, '2005-01-01', 'El museo fue sede de la Bienal de Arte Contemporáneo de Monterrey, consolidando su reputación internacional.'),
(5, '1936-01-01', 'El Jiangsu Art Museum fue establecido, con el objetivo de exhibir y promover el arte contemporáneo chino.'),
(5, '1978-01-01', 'El museo organizó la primera gran exposición de arte de vanguardia post-revolucionario en la región.'),
(6, '1959-01-01', 'Apertura del Museo de Guangdong, dedicado a difundir la rica cultura y arte de la provincia de Guangdong.'),
(6, '1990-01-01', 'El museo lanzó un proyecto de digitalización de sus colecciones para hacerlas accesibles a un público global.'),
(7, '2001-03-11', 'Inauguración del Museo Nacional de Australia, diseñado para explorar y celebrar la historia australiana en todas sus facetas.'),
(7, '2015-01-01', 'El museo recibió un premio por su compromiso con la reconciliación y la exhibición de la cultura indígena australiana.'),
(8, '1861-01-01', 'Establecimiento de la Galería Nacional de Victoria, con la visión de ser un epicentro de la creatividad y la innovación artística.'),
(8, '1920-01-01', 'La galería adquirió importantes obras de artistas impresionistas australianos, enriqueciendo significativamente su colección.');

INSERT INTO evento (id_museo, fecha_inicio_evento, fecha_fin_evento, nombre_evento, institucion_educativa, cantidad_asistentes, lugar_exposicion, costo_persona) VALUES
(1, '2025-06-05', '2025-06-25', 'Taller de Pintura Abstracta para Jóvenes', 'Escuela de Arte de Vancouver', NULL, 'Sala de Talleres Creativos', 25.00), -- Fecha de inicio modificada
(1, '2024-04-15', '2024-06-30', 'Exposición de Esculturas Modernas: Formas y Volúmenes', NULL, 300, 'Galería Principal', 15.00),
(2, '2025-06-03', '2025-06-23', 'Ciclo de Conferencias: Maestros del Renacimiento', 'Universidad de Montreal', NULL, 'Auditorio Principal', 10.00), -- Fecha de inicio modificada
(2, '2024-05-01', '2024-07-31', 'Retrospectiva Impresionista: Luz y Color', NULL, 450, 'Sala Impresionista', 18.00),
(3, '2025-06-02', '2025-06-20', 'Seminario de Historia Colonial Mexicana', 'El Colegio de México', NULL, 'Auditorio Principal', 30.00), -- Fecha de inicio modificada
(3, '2024-03-05', '2024-05-15', 'La Ciudad a Través del Tiempo: Exposición Fotográfica', NULL, 280, 'Sala de Orígenes', 12.00),
(4, '2025-06-07', '2025-06-27', 'Diplomado en Curaduría de Arte Contemporáneo', 'Tecnológico de Monterrey', NULL, 'Salas de Capacitación', 150.00), -- Fecha de inicio modificada
(4, '2024-06-10', '2024-08-20', 'Bienal de Arte Digital y Nuevos Medios', NULL, 600, 'Galería Norte y Sur', 20.00),
(5, '2025-06-06', '2025-06-24', 'Clase Magistral de Caligrafía China Antigua', 'Universidad de Nanjing', NULL, 'Sala de Caligrafía', 40.00), -- Fecha de inicio modificada
(5, '2024-05-05', '2024-07-10', 'Exposición de Dinastías Cerámicas Chinas', NULL, 350, 'Sala de Cerámica', 16.00),
(6, '2025-06-04', '2025-06-21', 'Foro de Intercambio Cultural Cantonés', 'Universidad de Sun Yat-sen', NULL, 'Sala de Arte Cantonés', 5.00), -- Fecha de inicio modificada
(6, '2024-04-01', '2024-06-01', 'Muestra de Reliquias Ancestrales de Guangdong', NULL, 290, 'Sala de Cultura Ancestral', 10.00),
(7, '2025-06-08', '2025-06-26', 'Programa Educativo sobre Arte Aborigen', 'Universidad Nacional de Australia', NULL, 'Galería Aborigen', 20.00), -- Fecha de inicio modificada
(7, '2024-03-10', '2024-05-25', 'Exposición Centenario de la Federación Australiana', NULL, 400, 'Sala de la Federación', 14.00),
(8, '2025-06-09', '2025-06-29', 'Taller de Historia del Arte Europeo para Estudiantes', 'Universidad de Melbourne', NULL, 'Galería Europea', 35.00), -- Fecha de inicio modificada
(8, '2024-04-05', '2024-06-15', 'Festival Internacional de Fotografía Artística', NULL, 500, 'Sala de Fotografía', 22.00);


INSERT INTO HORARIO (id_museo, dia, hora_apertura, hora_cierre) VALUES
(1,1,'09:00','18:00'),
(1,2,'09:00','18:00'),
(1,3,'09:00','18:00'),
(1,4,'09:00','18:00'),
(1,5,'09:00','20:00'),
(1,6,'10:00','20:00'),
(1,7,'10:00','18:00');


INSERT INTO IDIOMA (nombre) VALUES
('Chino Mandarín'),
('Español'),
('Inglés'),
('Hindi'),
('Árabe'),
('Bengalí'),
('Portugués'),
('Ruso'),
('Japonés'),
('Lahnda (Punjabi)'),
('Javanés'),
('Alemán'),
('Coreano'),
('Francés'),
('Telugu'),
('Marathi'),
('Turco'),
('Tamil'),
('Urdu'),
('Vietnamita');

INSERT INTO EMPLEADO_PROFESIONAL (primer_nombre, primer_apellido, segundo_nombre, segundo_apellido, fecha_nacimiento, doc_identidad, dato_contacto) VALUES
('Amby', 'Vasnev', 'Ethelin', 'Mannix', '7/26/1965', 37199014, 'emannix0@cdc.gov'),
('Phillida', 'Millward', 'Anissa', 'Boggas', '4/25/1988', 98720528, 'aboggas1@last.fm'),
('Audra', 'Anders', 'Howey', 'Dauby', '3/27/1992', 3577167, 'hdauby2@uiuc.edu'),
('Marcy', 'Lotte', 'Izzy', 'Upcott', '8/26/1965', 62756151, 'iupcott3@ted.com'),
('Kriste', 'Dowd', 'Valentina', 'Antonucci', '8/17/1986', 84191792, 'vantonucci4@creativecommons.org'),
('Illa', 'Maddy', 'Clim', 'Jilliss', '4/13/2003', 76188238, 'cjilliss5@cpanel.net'),
('Deny', 'Wandrack', 'Karlee', 'Tutill', '10/8/1977', 11723682, 'ktutill6@nasa.gov'),
('Alanson', 'Khosa', 'Ferne', 'Wolvey', '2/21/2003', 70089698, 'fwolvey7@bigcartel.com'),
('Antony', 'Kelwaybamber', 'Cassandra', 'Kempster', '11/4/1990', 14461178, 'ckempster8@bbc.co.uk'),
('Ame', 'Weatherall', 'Juanita', 'Tinman', '2/1/1967', 46210895, 'jtinman9@fastcompany.com'),
('Samaria', 'Ouldcott', 'Orville', 'Haw', '11/25/1972', 80969176, 'ohawa@seesaa.net'),
('Lonnie', 'Staniforth', 'Melisa', 'Kumar', '11/25/1973', 75595309, 'mkumarb@comcast.net'),
('Wadsworth', 'Brannigan', 'Sammie', 'Balasin', '2/27/1977', 24585802, 'sbalasinc@marketwatch.com'),
('Chere', 'Sorbie', 'Rozalin', 'McCahill', '11/15/1980', 16540658, 'rmccahilld@netvibes.com'),
('Binky', 'Sedman', 'Erny', 'Duffie', '1/31/1971', 25003704, 'eduffiee@gov.uk'),
('Luella', 'Dugmore', 'Audrye', 'Vescovini', '2/20/1971', 35887091, 'avescovinif@ow.ly'),
('Amalita', 'Sandyford', 'Vladamir', 'MacGray', '7/3/1985', 33916912, 'vmacgrayg@webnode.com'),
('Francklyn', 'Posthill', 'Carol', 'Roylance', '5/23/1981', 39481127, 'croylanceh@issuu.com'),
('Ephrayim', 'Loins', 'Gottfried', 'Perren', '12/25/1972', 68820889, 'gperreni@github.io'),
('Oliy', 'Leander', 'Ursulina', 'Langelay', '5/7/1986', 31800030, 'ulangelayj@tripadvisor.com'),
('Ingra', 'Snaddon', 'Cam', 'Raywood', '5/26/1978', 9485591, 'craywoodk@sourceforge.net'),
('Alecia', 'Kingcott', 'Karleen', 'Chatelot', '5/11/1994', 56219159, 'kchatelotl@4shared.com'),
('Connor', 'Fyfield', 'Kipp', 'Lurcock', '6/18/1986', 73216351, 'klurcockm@github.io'),
('Laney', 'Emanuelov', 'Chanda', 'McAllan', '10/12/1987', 61107397, 'cmcallann@dion.ne.jp'),
('Trevor', 'Iglesias', 'Sophia', 'Wadham', '6/30/2000', 4318989, 'swadhamo@uiuc.edu'),
('Inger', 'Laite', 'Rawley', 'Kempshall', '11/26/1964', 62349446, 'rkempshallp@who.int'),
('Daisi', 'Newborn', 'Tate', 'Dewer', '8/29/1996', 83959955, 'tdewerq@state.gov'),
('Marcille', 'Haborn', 'Tanya', 'Polley', '12/5/1984', 64120783, 'tpolleyr@yelp.com'),
('Dolf', 'Sandal', 'Ddene', 'Este', '9/20/1965', 36553430, 'destes@latimes.com'),
('Kaylyn', 'Blader', 'Dolf', 'Mulcock', '4/1/1965', 76810772, 'dmulcockt@photobucket.com'),
('Pooh', 'Parkey', 'Parry', 'Bikker', '4/22/1974', 9110987, 'pbikkeru@theglobeandmail.com'),
('Riane', 'Dodson', 'Mikey', 'Pace', '9/29/1990', 54248052, 'mpacev@mit.edu'),
('Harwell', 'Grigore', 'Allix', 'Couche', '8/2/1989', 67729855, 'acouchew@delicious.com'),
('Concettina', 'Deschlein', 'Alonzo', 'Ixer', '7/15/1983', 86901830, 'aixerx@php.net'),
('Olga', 'Dumphries', 'Elianora', 'Caris', '8/6/1972', 69560630, 'ecarisy@prnewswire.com'),
('Mindy', 'Pratten', 'Noach', 'Bairnsfather', '6/17/1992', 87951313, 'nbairnsfatherz@booking.com'),
('Edd', 'Anten', 'Zachariah', 'Snelle', '11/10/1979', 13958779, 'zsnelle10@ibm.com'),
('Oralee', 'Szabo', 'Joela', 'Top', '7/4/1985', 39712868, 'jtop11@lycos.com'),
('Ive', 'Sultan', 'Margalo', 'Late', '8/6/1968', 68001922, 'mlate12@chron.com'),
('Agosto', 'Shevlane', 'Vida', 'Selkirk', '6/9/1969', 86983568, 'vselkirk13@ucoz.ru'),
('Zerk', 'Perassi', 'Blanch', 'Creed', '7/30/1976', 99920354, 'bcreed14@wikipedia.org'),
('Joni', 'Habron', 'Netta', 'Baldry', '3/26/1979', 73689447, 'nbaldry15@un.org'),
('Cybill', 'Rimour', 'Janette', 'Monroe', '7/9/1992', 95766817, 'jmonroe16@archive.org'),
('Nicky', 'Kenen', 'Klement', 'O''Geneay', '8/19/1973', 94199855, 'kogeneay17@webmd.com'),
('Imelda', 'Gillard', 'Aleen', 'Mantrup', '12/12/1971', 19023592, 'amantrup18@posterous.com'),
('Margarita', 'Fishbourn', 'Lorena', 'Looney', '8/24/2001', 8057751, 'llooney19@state.tx.us'),
('Raymund', 'McLarty', 'Burgess', 'Reubel', '12/5/1983', 92672845, 'breubel1a@blogs.com'),
('Geno', 'McOnie', 'Dre', 'Jeandeau', '12/7/1996', 98416475, 'djeandeau1b@moonfruit.com'),
('Giovanna', 'Featherby', 'Jorgan', 'Philliskirk', '7/24/1971', 1588698, 'jphilliskirk1c@buzzfeed.com'),
('Gard', 'Scandred', 'Eliza', 'Towey', '2/13/1974', 87309340, 'etowey1d@bloglovin.com'),
('Phyllida', 'Biasioli', 'Rog', 'Cordel', '11/6/1994', 27435442, 'rcordel1e@imgur.com'),
('Sean', 'Aleksandrikin', 'Merrilee', 'Kochl', '7/27/1984', 14399168, 'mkochl1f@cbc.ca'),
('Sena', 'Tallon', 'Ashlie', 'Hedaux', '1/23/1980', 92188237, 'ahedaux1g@sfgate.com'),
('Haze', 'Haley', 'Patti', 'Newvill', '1/7/1976', 60924864, 'pnewvill1h@businessinsider.com'),
('Patin', 'Poznanski', 'Ashton', 'Ogan', '8/20/1990', 80438553, 'aogan1i@chicagotribune.com'),
('Sydney', 'Houlston', 'Cortie', 'Gofford', '4/7/1969', 34071060, 'cgofford1j@msn.com'),
('Pamelina', 'Ivashov', 'Gayle', 'Harbison', '10/14/1966', 64090908, 'gharbison1k@ca.gov'),
('Renault', 'Wildblood', 'Rozamond', 'Phin', '6/21/1999', 86487467, 'rphin1l@imageshack.us'),
('Cointon', 'Tommasuzzi', 'Aubrie', 'Beckett', '12/2/1988', 57368415, 'abeckett1m@usnews.com'),
('Menard', 'Degoe', 'Martynne', 'Redrup', '11/3/1975', 73630413, 'mredrup1n@google.co.uk'),
('Theresa', 'Ellison', 'Bryana', 'Pawel', '1/13/2002', 82852819, 'bpawel1o@imgur.com'),
('Urban', 'Shire', 'Ladonna', 'Sharer', '2/3/1966', 6032421, 'lsharer1p@mozilla.org'),
('Adrianne', 'Newland', 'Shirlene', 'Dart', '4/1/1987', 39355796, 'sdart1q@hp.com'),
('Early', 'Wackly', 'Mariellen', 'Cobello', '3/4/2005', 11970919, 'mcobello1r@shop-pro.jp'),
('Megan', 'MacCurley', 'Nev', 'Friday', '8/21/1993', 79991413, 'nfriday1s@bbc.co.uk'),
('Hana', 'Todarini', 'Philippa', 'Craufurd', '5/5/1993', 41040935, 'pcraufurd1t@friendfeed.com'),
('Rodrigo', 'Kenwyn', 'Lodovico', 'Cornelis', '2/3/1974', 29573757, 'lcornelis1u@nymag.com'),
('Trevor', 'Terbrug', 'Rebecka', 'Clampett', '6/30/1973', 30463135, 'rclampett1v@washingtonpost.com'),
('Kelsy', 'Geerdts', 'Raquela', 'Strutz', '2/26/1998', 14065028, 'rstrutz1w@chronoengine.com'),
('Tanner', 'Carsberg', 'Fonsie', 'Bruhnke', '1/24/1983', 75932398, 'fbruhnke1x@bloglines.com'),
('Charlotte', 'Alasdair', 'Jackqueline', 'Kelbie', '3/25/1968', 10756490, 'jkelbie1y@bandcamp.com'),
('Levin', 'Feragh', 'Bearnard', 'Wooff', '7/18/1983', 69904701, 'bwooff1z@facebook.com'),
('Wynn', 'Jean', 'Cassandra', 'Boutwell', '9/30/1967', 71620106, 'cboutwell20@macromedia.com'),
('Tonya', 'Gully', 'Erastus', 'Philpot', '6/7/1996', 14017075, 'ephilpot21@cnn.com'),
('Scott', 'Dinnage', 'Spenser', 'Trundle', '7/3/1964', 70042173, 'strundle22@icq.com'),
('Myrta', 'Benediktsson', 'Thacher', 'Demange', '8/3/2004', 10732182, 'tdemange23@bbb.org'),
('Mariellen', 'Gerrard', 'Janaye', 'Gilyatt', '6/26/2001', 83494777, 'jgilyatt24@about.me'),
('Gearard', 'Goodding', 'Nara', 'Stronack', '9/19/1973', 83728547, 'nstronack25@nytimes.com'),
('Case', 'Chesterfield', 'Wileen', 'Rodolf', '7/1/1987', 73883122, 'wrodolf26@loc.gov'),
('Webster', 'Coutthart', 'Perla', 'Wakes', '8/3/1982', 2840559, 'pwakes27@webeden.co.uk'),
('Leah', 'Yelyashev', 'Rhea', 'Mortel', '7/7/1975', 84133153, 'rmortel28@hexun.com'),
('Jamey', 'Shawley', 'Mozelle', 'Corradeschi', '3/18/1987', 87040195, 'mcorradeschi29@cbslocal.com'),
('Torie', 'Barcroft', 'Jeannine', 'Tanton', '12/7/1975', 88042923, 'jtanton2a@ifeng.com'),
('Babette', 'Tylor', 'Kandace', 'Letherbury', '5/10/1985', 54959418, 'kletherbury2b@istockphoto.com'),
('Sidnee', 'Hawtin', 'Candra', 'Van Brug', '11/22/1994', 73371005, 'cvanbrug2c@amazon.co.jp'),
('Anica', 'Watsam', 'Valentin', 'Slyde', '3/6/1985', 22335186, 'vslyde2d@skype.com'),
('Elroy', 'Booij', 'Lucille', 'McMackin', '2/28/1992', 26560145, 'lmcmackin2e@seesaa.net'),
('Erna', 'Coulthard', 'Rutter', 'Rabbitts', '7/20/1990', 33462118, 'rrabbitts2f@stumbleupon.com'),
('Lamar', 'Coult', 'Magdalene', 'Heine', '3/14/1971', 23593509, 'mheine2g@buzzfeed.com'),
('Gayla', 'Dailly', 'Cornall', 'Brisset', '3/4/1986', 79368846, 'cbrisset2h@sbwire.com'),
('Putnem', 'Cornforth', 'Agnese', 'Comiam', '3/4/1988', 97934565, 'acomiam2i@sakura.ne.jp'),
('Lynette', 'Pengilly', 'Johnnie', 'Munkley', '6/25/1995', 39277718, 'jmunkley2j@weather.com'),
('Harriet', 'Voisey', 'Mathilde', 'Colston', '9/1/1979', 98499867, 'mcolston2k@nyu.edu'),
('Elroy', 'Mauger', 'Abba', 'Nestoruk', '8/20/1977', 66392294, 'anestoruk2l@gnu.org'),
('Quill', 'Eastmond', 'Reube', 'Chantrell', '11/12/1995', 30244655, 'rchantrell2m@goo.gl'),
('Skyler', 'Fetherstonhaugh', 'Noam', 'Womack', '6/9/1966', 40847902, 'nwomack2n@un.org'),
('Shaine', 'Comley', 'Prinz', 'Van Haeften', '1/16/1999', 5100504, 'pvanhaeften2o@unicef.org'),
('Berti', 'Checklin', 'Leland', 'Frostdicke', '6/1/1983', 15978800, 'lfrostdicke2p@exblog.jp'),
('Ruttger', 'Wolpert', 'Paige', 'Jeynes', '7/19/1998', 87503451, 'pjeynes2q@so-net.ne.jp'),
('Hamel', 'Seeney', 'Fredek', 'Buske', '9/2/1990', 13541151, 'fbuske2r@patch.com'),
('Kelvin', 'Pieche', 'Esteban', 'Corden', '11/17/1986', 97862915, 'ecorden2s@skyrock.com'),
('May', 'Pyzer', 'Theodore', 'Danher', '7/15/1972', 43393188, 'tdanher2t@yolasite.com'),
('Karie', 'Maymand', 'Viola', 'Ivy', '10/17/1988', 75295006, 'vivy2u@bluehost.com'),
('See', 'Wintersgill', 'Fredericka', 'Zanetto', '12/21/1979', 20393814, 'fzanetto2v@hud.gov'),
('Casie', 'Toppin', 'Gizela', 'Cromb', '11/11/1975', 38009356, 'gcromb2w@arstechnica.com'),
('Ines', 'Tivers', 'Lock', 'O''Donnelly', '7/31/1977', 13774010, 'lodonnelly2x@icio.us'),
('Eddie', 'Brian', 'Rollo', 'Berney', '8/24/1981', 43162133, 'rberney2y@businessinsider.com'),
('Ryley', 'Barmadier', 'Morton', 'Antushev', '4/8/1986', 4847718, 'mantushev2z@bravesites.com'),
('Bronny', 'Logue', 'Rafaelita', 'Flag', '11/13/2000', 48349335, 'rflag30@europa.eu'),
('Layne', 'Meese', 'Eugen', 'Breward', '10/19/1972', 48574848, 'ebreward31@springer.com'),
('Susan', 'Worwood', 'Katerine', 'Simony', '1/1/1974', 21756369, 'ksimony32@vk.com'),
('Anson', 'Rosone', 'Hube', 'Spykings', '12/18/2000', 40994312, 'hspykings33@gizmodo.com'),
('Adora', 'Gerbi', 'Duffy', 'McMenamy', '7/17/1964', 20930410, 'dmcmenamy34@mozilla.org'),
('Danny', 'Scandwright', 'Deedee', 'Saunderson', '1/21/1971', 40469472, 'dsaunderson35@alibaba.com'),
('Ethyl', 'Havesides', 'Skippie', 'Ellingworth', '9/12/1982', 30187072, 'sellingworth36@shutterfly.com'),
('Berkeley', 'Siddle', 'Lorne', 'Fosberry', '2/11/1982', 92386958, 'lfosberry37@businessinsider.com'),
('Valentine', 'Priditt', 'Augustine', 'Chesters', '11/26/1966', 20769162, 'achesters38@webeden.co.uk'),
('Grover', 'Whelpton', 'Zedekiah', 'Bonanno', '6/11/2002', 65464708, 'zbonanno39@bigcartel.com'),
('Ola', 'Dinzey', 'Chrysler', 'Pigdon', '7/17/2001', 2163110, 'cpigdon3a@fda.gov'),
('Reggy', 'MacGaughy', 'Wallache', 'Ottam', '4/13/2004', 69593875, 'wottam3b@wsj.com'),
('Bernardo', 'Crusham', 'Lonna', 'Fawssett', '9/19/2002', 26438734, 'lfawssett3c@jimdo.com'),
('Alberta', 'Swinden', 'Brear', 'Lanfranconi', '4/16/2003', 26650659, 'blanfranconi3d@ucoz.ru'),
('Braden', 'Cheese', 'Monty', 'Pountain', '2/4/1980', 13177378, 'mpountain3e@admin.ch'),
('Davide', 'Wildsmith', 'Xylia', 'Stokoe', '1/3/1992', 93010574, 'xstokoe3f@epa.gov'),
('Bendite', 'Nasey', 'Janean', 'Horry', '5/14/1967', 26099952, 'jhorry3g@reference.com'),
('Keslie', 'Yokley', 'Nomi', 'Biaggiotti', '12/17/1976', 56420426, 'nbiaggiotti3h@forbes.com'),
('Thatch', 'Diboll', 'Eran', 'Keaves', '8/11/2003', 28499733, 'ekeaves3i@blogs.com'),
('Wilton', 'Baum', 'Rudie', 'Trevorrow', '8/14/1995', 74234661, 'rtrevorrow3j@drupal.org'),
('Bennie', 'Luetchford', 'Harlene', 'Patrie', '11/11/1992', 79569943, 'hpatrie3k@hud.gov'),
('Worthy', 'Obal', 'Shepherd', 'Pemberton', '4/28/1981', 91689680, 'spemberton3l@bloomberg.com'),
('Torr', 'Bentame', 'Blinny', 'Hender', '1/23/2000', 79847252, 'bhender3m@nature.com'),
('Maegan', 'Littlemore', 'Rickie', 'L''Episcopio', '2/13/1980', 74071679, 'rlepiscopio3n@github.io'),
('Elihu', 'Gurys', 'Doroteya', 'Stemp', '12/12/2003', 67329231, 'dstemp3o@google.co.jp'),
('Rana', 'Ashleigh', 'Lucas', 'Comber', '4/24/1969', 1804441, 'lcomber3p@weather.com'),
('Sarene', 'Pealing', 'Joachim', 'Thundercliffe', '2/27/2004', 31413758, 'jthundercliffe3q@jiathis.com'),
('Corrinne', 'Watkins', 'Meagan', 'Frowen', '12/3/1971', 92787151, 'mfrowen3r@prnewswire.com'),
('Glenine', 'Astle', 'Nollie', 'Enders', '7/11/1977', 57299985, 'nenders3s@wix.com'),
('Bertha', 'Mallam', 'Flinn', 'Chappell', '6/29/1980', 92275842, 'fchappell3t@microsoft.com'),
('Stewart', 'Steadman', 'Kenyon', 'Rampley', '2/23/2001', 96570502, 'krampley3u@nba.com'),
('Lucas', 'Robertet', 'Noell', 'Vasyutin', '3/31/2005', 6903042, 'nvasyutin3v@princeton.edu'),
('Emyle', 'Melsom', 'Johnathan', 'Tythacott', '9/13/1991', 38176865, 'jtythacott3w@uol.com.br'),
('Haskell', 'Penwarden', 'Shirleen', 'Jasiak', '8/22/1998', 70834184, 'sjasiak3x@zimbio.com'),
('Alaster', 'Weippert', 'Ephrem', 'Temprell', '10/20/1977', 9067699, 'etemprell3y@epa.gov'),
('Austin', 'MacVanamy', 'Homere', 'Cherry', '5/27/1968', 98183048, 'hcherry3z@cpanel.net'),
('Anatola', 'Baskerfield', 'Kingston', 'Haville', '1/14/1989', 20200442, 'khaville40@posterous.com'),
('Bear', 'Kristof', 'Kalvin', 'Kirkham', '5/30/1982', 87441231, 'kkirkham41@miitbeian.gov.cn'),
('Tudor', 'Hallex', 'Ody', 'Abrahami', '4/11/1966', 55047468, 'oabrahami42@simplemachines.org'),
('Milena', 'Padilla', 'Theodosia', 'Spadollini', '8/1/1997', 22527711, 'tspadollini43@nps.gov'),
('Eugene', 'Cowl', 'Carlo', 'Reeve', '9/15/1980', 60726574, 'creeve44@booking.com'),
('Kakalina', 'Eastup', 'Robinette', 'Peirson', '3/19/1985', 96013233, 'rpeirson45@europa.eu'),
('Sarajane', 'Seton', 'Laureen', 'Paolicchi', '10/19/2004', 57606503, 'lpaolicchi46@usa.gov'),
('Rube', 'Giddins', 'Gertie', 'Moberley', '6/22/1984', 89414948, 'gmoberley47@mediafire.com'),
('Rodd', 'Luddy', 'Cordy', 'Luxmoore', '1/21/1999', 31023335, 'cluxmoore48@meetup.com'),
('Dalt', 'Gateman', 'Tatiana', 'Perse', '6/30/1982', 14195540, 'tperse49@gov.uk'),
('Brandyn', 'Burde', 'Marcellina', 'Tattershaw', '8/31/2003', 4500411, 'mtattershaw4a@sbwire.com'),
('Mollie', 'Pilfold', 'Devora', 'Wayon', '5/2/1994', 68515666, 'dwayon4b@twitpic.com'),
('Dane', 'Vernazza', 'Ortensia', 'Berrisford', '2/10/1984', 34143310, 'oberrisford4c@google.co.jp'),
('Bastien', 'Hencke', 'Lexine', 'Arondel', '5/19/1979', 47248101, 'larondel4d@ebay.co.uk'),
('Peta', 'Rittmeyer', 'Wernher', 'Dibdall', '6/11/1973', 26565035, 'wdibdall4e@t.co'),
('Elwyn', 'Klosterman', 'Corrianne', 'Housegoe', '5/31/1969', 66099096, 'chousegoe4f@timesonline.co.uk');

insert into EMP_IDI (id_idioma, id_empleado_prof) values 
(8, 141),
(6, 14),
(6, 75),
(18, 78),
(18, 157),
(5, 5),
(19, 30),
(11, 99),
(5, 20),
(20, 96),
(14, 99),
(17, 54),
(3, 33),
(19, 143),
(1, 124),
(3, 100),
(9, 103),
(5, 149),
(8, 29),
(12, 107),
(20, 98),
(2, 44),
(13, 139),
(16, 97),
(10, 110),
(14, 62),
(6, 138),
(8, 50),
(17, 3),
(19, 129),
(11, 13),
(16, 124),
(7, 80),
(15, 66),
(1, 113),
(18, 129),
(11, 44),
(13, 60),
(20, 140),
(4, 137),
(20, 77),
(6, 28),
(1, 117),
(2, 14),
(3, 146),
(18, 109),
(2, 130),
(8, 118),
(8, 82),
(18, 10),
(13, 85),
(20, 30),
(20, 23),
(2, 12),
(13, 14),
(13, 83),
(8, 21),
(12, 80),
(1, 25),
(1, 88),
(13, 91),
(3, 97),
(2, 51),
(3, 70),
(20, 26),
(6, 153),
(8, 91),
(7, 8),
(11, 38),
(8, 112),
(10, 106),
(2, 47),
(19, 27),
(12, 12),
(9, 93),
(3, 89),
(3, 84),
(5, 109),
(2, 79),
(20, 107),
(12, 44),
(19, 38),
(11, 82),
(1, 150),
(4, 82),
(20, 24),
(17, 103),
(2, 158),
(13, 145),
(6, 134),
(4, 12),
(5, 68),
(2, 96),
(11, 41),
(17, 70),
(11, 151),
(4, 84),
(14, 157),
(16, 48),
(9, 105),
(7, 159),
(18, 95),
(16, 42),
(6, 119),
(14, 85),
(20, 108),
(14, 14),
(1, 23),
(12, 75),
(10, 21),
(19, 3),
(18, 130),
(15, 139),
(2, 92),
(4, 51),
(17, 94),
(15, 125),
(8, 100),
(15, 34),
(1, 11),
(2, 74),
(14, 142),
(12, 26),
(16, 125),
(8, 3),
(16, 100),
(17, 132),
(3, 78),
(5, 153),
(20, 147),
(1, 147),
(2, 85),
(10, 25),
(7, 71),
(16, 12),
(10, 131),
(9, 26),
(1, 116),
(13, 112),
(2, 81),
(9, 13),
(4, 44),
(7, 3),
(5, 30),
(16, 53),
(13, 150),
(6, 26),
(20, 67),
(10, 76),
(8, 20),
(1, 141),
(5, 62),
(6, 35),
(2, 28),
(4, 141),
(5, 154),
(6, 7),
(4, 77),
(20, 110),
(9, 152),
(8, 146),
(2, 133),
(4, 36),
(18, 89),
(9, 120),
(14, 138),
(3, 158),
(14, 7),
(15, 43),
(7, 103),
(1, 80),
(17, 15),
(10, 59),
(14, 150),
(10, 38),
(7, 90),
(16, 138),
(1, 144),
(20, 1),
(8, 132),
(17, 156),
(12, 74),
(18, 74),
(15, 94),
(6, 90),
(14, 1),
(20, 61),
(5, 158),
(6, 83),
(15, 149),
(6, 85),
(7, 27),
(14, 15),
(18, 24),
(3, 61),
(8, 77),
(14, 113),
(15, 13),
(5, 63),
(16, 136),
(19, 51),
(3, 75),
(7, 53),
(7, 29),
(13, 19),
(18, 62),
(17, 48),
(2, 109),
(7, 73),
(16, 143),
(8, 61),
(8, 48),
(16, 137),
(20, 150),
(9, 133),
(16, 54),
(3, 22),
(13, 146),
(3, 77),
(17, 2),
(10, 138),
(3, 153),
(12, 149),
(18, 14),
(10, 42),
(5, 39),
(20, 136),
(11, 140),
(2, 7);

insert into EMPLEADO_MANTENIMIENTO_VIGILANCIA (nombre_empleado_mv, apellido_empleado_mv, doc_identidad, tipo) values 
('Mira', 'Folder', 51174186, 'vigilancia'),
('Auberta', 'Fuchs', 26953561, 'mantenimiento'),
('Linc', 'Kennet', 1179298, 'vigilancia'),
('Farleigh', 'Claydon', 54780476, 'mantenimiento'),
('Aubrie', 'Dearth', 88501895, 'vigilancia'),
('Pascale', 'Ferschke', 62468660, 'mantenimiento'),
('Tansy', 'Vernay', 83107391, 'mantenimiento'),
('Edik', 'Hopewell', 3718806, 'vigilancia'),
('Alyse', 'Bannerman', 71772853, 'vigilancia'),
('Donica', 'McGlew', 20744975, 'vigilancia'),
('Nara', 'Point', 76042964, 'mantenimiento'),
('Duke', 'Sapwell', 23213194, 'vigilancia'),
('Nike', 'Fedynski', 45663684, 'vigilancia'),
('Rudyard', 'Butson', 67886612, 'vigilancia'),
('Sigfried', 'Manneville', 60756094, 'mantenimiento'),
('Adolf', 'Pautot', 18379753, 'vigilancia'),
('Travers', 'Motto', 9123269, 'mantenimiento'),
('Marley', 'Jeandin', 57427347, 'mantenimiento'),
('Alastair', 'Rubinfajn', 59739477, 'vigilancia'),
('Nan', 'Attarge', 60146158, 'vigilancia'),
('Ola', 'Skoyles', 10676993, 'vigilancia'),
('Karmen', 'Piddock', 87772909, 'vigilancia'),
('Sonni', 'Daleman', 77434190, 'vigilancia'),
('Shandeigh', 'Bone', 27240577, 'vigilancia'),
('Karalee', 'Vyvyan', 54961264, 'mantenimiento'),
('Augustine', 'Savell', 80828674, 'vigilancia'),
('Kiley', 'Zimmer', 15288606, 'vigilancia'),
('Zita', 'Corwood', 22974337, 'mantenimiento'),
('Gran', 'Bullan', 84710816, 'mantenimiento'),
('Pail', 'Odd', 33865961, 'vigilancia'),
('Sabine', 'Venediktov', 2643931, 'mantenimiento'),
('Darrick', 'Sommerville', 64394613, 'mantenimiento');

insert into TICKET (precio, tipo_ticket, fecha_hora_ticket, id_museo) values 
(7, 'tercera edad', '2007-02-19 09:15:00', 1),
(7, 'tercera edad', '2005-02-08 10:30:00', 2),
(7, 'tercera edad', '2012-01-23 11:45:00', 3),
(7, 'tercera edad', '2005-08-27 08:20:00', 4),
(0, 'niño', '2010-09-17 13:10:00', 5),
(0, 'niño', '2020-10-23 14:25:00', 6),
(7, 'tercera edad', '1999-05-18 09:50:00', 7),
(7, 'tercera edad', '2016-08-07 12:40:00', 8),
(0, 'niño', '2012-01-24 10:15:00', 1),
(15, 'adulto', '1999-08-29 08:30:00', 2),
(7, 'tercera edad', '2009-02-21 13:20:00', 3),
(15, 'adulto', '2021-03-24 11:10:00', 4),
(0, 'niño', '2009-09-30 14:45:00', 5),
(0, 'niño', '2016-03-31 09:25:00', 6),
(7, 'tercera edad', '1999-03-22 10:50:00', 7),
(7, 'tercera edad', '2019-12-27 12:15:00', 8),
(0, 'niño', '2007-12-23 08:40:00', 1),
(7, 'tercera edad', '2000-09-24 13:30:00', 2),
(0, 'niño', '2022-06-13 11:55:00', 3),
(15, 'adulto', '2025-03-16 14:10:00', 4),
(7, 'tercera edad', '2004-07-28 09:35:00', 5),
(15, 'adulto', '2002-05-06 10:00:00', 6),
(0, 'niño', '2007-07-15 12:25:00', 7),
(7, 'tercera edad', '2008-04-19 13:50:00', 8),
(7, 'tercera edad', '2012-08-24 08:15:00', 1),
(7, 'tercera edad', '2012-01-16 10:40:00', 2),
(0, 'niño', '2017-08-09 14:05:00', 3),
(15, 'adulto', '1999-09-09 11:30:00', 4),
(0, 'niño', '2024-01-13 09:55:00', 5),
(0, 'niño', '2014-06-21 12:20:00', 6),
(0, 'niño', '2013-11-03 13:45:00', 7),
(7, 'tercera edad', '2017-07-25 08:10:00', 8),
(15, 'adulto', '2015-08-14 10:35:00', 1),
(0, 'niño', '2023-04-18 14:00:00', 2),
(7, 'tercera edad', '2019-03-18 11:25:00', 3),
(0, 'niño', '2003-09-30 09:50:00', 4),
(7, 'tercera edad', '2024-11-17 12:15:00', 5),
(15, 'adulto', '2020-08-27 13:40:00', 6),
(7, 'tercera edad', '2022-09-22 08:05:00', 7),
(0, 'niño', '2019-05-07 10:30:00', 8),
(7, 'tercera edad', '2009-08-18 14:55:00', 1),
(15, 'adulto', '2003-04-16 11:20:00', 2),
(15, 'adulto', '2003-01-20 09:45:00', 3),
(7, 'tercera edad', '2009-02-13 12:10:00', 4),
(15, 'adulto', '2011-08-14 13:35:00', 5),
(0, 'niño', '2016-04-14 08:00:00', 6),
(7, 'tercera edad', '2011-04-19 10:25:00', 7),
(15, 'adulto', '2014-10-26 14:50:00', 8),
(15, 'adulto', '2004-02-03 11:15:00', 1),
(15, 'adulto', '2003-12-09 09:40:00', 2),
(15, 'adulto', '2005-06-06 12:05:00', 3),
(7, 'tercera edad', '2011-02-10 13:30:00', 4),
(7, 'tercera edad', '2011-08-15 08:55:00', 5),
(0, 'niño', '2019-03-17 10:20:00', 6),
(7, 'tercera edad', '2024-03-12 14:45:00', 7),
(15, 'adulto', '2003-03-07 11:10:00', 8),
(7, 'tercera edad', '2008-06-16 09:35:00', 1),
(0, 'niño', '1999-01-11 12:00:00', 2),
(0, 'niño', '1999-03-03 13:25:00', 3),
(7, 'tercera edad', '2002-12-11 08:50:00', 4),
(0, 'niño', '2003-09-01 10:15:00', 5),
(0, 'niño', '2015-06-17 14:40:00', 6),
(0, 'niño', '2021-03-05 11:05:00', 7),
(15, 'adulto', '2000-05-17 09:30:00', 8),
(7, 'tercera edad', '2001-08-09 12:55:00', 1),
(15, 'adulto', '2017-03-12 13:20:00', 2),
(0, 'niño', '2012-06-13 08:45:00', 3),
(0, 'niño', '2014-03-06 10:10:00', 4),
(7, 'tercera edad', '2011-01-17 14:35:00', 5),
(7, 'tercera edad', '2023-04-26 11:00:00', 6),
(15, 'adulto', '2012-03-03 09:25:00', 7),
(0, 'niño', '2020-02-10 12:50:00', 8);

INSERT INTO tipo_ticket_historico (id_museo, fecha_inicio, precio, tipo_ticket, fecha_fin) VALUES

(1, '2022-01-01 09:00:00', 0.00, 'niño', '2023-12-31'), 
(1, '2024-01-01 09:00:00', 10.00, 'tercera edad', NULL),
(1, '2023-01-01 09:00:00', 15.00, 'adulto', NULL),   
(2, '2021-06-01 10:00:00', 15.00, 'adulto', '2024-05-31'), 
(2, '2024-06-01 10:00:00', 5.00, 'niño', NULL),
(2, '2025-01-01 09:00:00', 10.00, 'tercera edad', NULL),   
(3, '2020-01-01 08:00:00', 8.00, 'tercera edad', '2023-06-30'), 
(3, '2023-07-01 08:00:00', 20.00, 'adulto', NULL),
(3, '2024-01-01 09:00:00', 10.00, 'niño', NULL),   
(4, '2022-03-15 09:30:00', 22.00, 'adulto', '2024-02-29'), 
(4, '2024-03-01 09:30:00', 0.00,  'niño', NULL),
(4, '2021-03-01 09:30:00', 15.00,  'tercera edad', NULL),  
(5, '2020-11-20 11:00:00', 7.50, 'tercera edad', '2023-10-31'), 
(5, '2023-11-01 11:00:00', 25.00, 'adulto', NULL),
(5, '2024-03-01 09:30:00', 0.00,  'niño', NULL),  
(6, '2019-05-01 09:00:00', 5.00, 'niño', '2022-12-31'), 
(6, '2023-01-01 09:00:00', 12.00, 'tercera edad', NULL),
(6, '2024-03-01 09:30:00', 18.00,  'adulto', NULL), 
(7, '2021-02-01 10:30:00', 18.00, 'adulto', '2023-08-31'), 
(7, '2023-09-01 10:30:00', 0.00,  'niño', NULL),
(7, '2024-09-01 10:30:00', 0.00,  'tercera edad', NULL), 
(8, '2022-07-20 12:00:00', 9.00, 'tercera edad', '2024-06-30'), 
(8, '2024-07-01 12:00:00', 30.00, 'adulto', NULL),
(8, '2023-07-01 12:00:00', 00.00, 'niño', NULL);

insert into FORMACION_PROFESIONAL (id_empleado_prof, nombre_titulo, ano, descripcion_especialidad) values 
(1, 'Conservación de Obras de Arte', '12/12/2020', 'Especialización en técnicas de conservación y restauración de pinturas al óleo en museos de arte clásico'),
(2, 'Gestión de Colecciones Museísticas', '11/02/2013', 'Catalogación y gestión digital de colecciones en museos de historia natural'),
(3, 'Curaduría de Arte Contemporáneo', '11/08/2016', 'Desarrollo de exposiciones temporales y gestión de artistas emergentes para museos de arte moderno'),
(4, 'Museografía Interactiva', '02/09/2019', 'Diseño de experiencias interactivas y tecnología aplicada a exposiciones museísticas'),
(5, 'Arqueología Museística', '05/04/2015', 'Conservación y exhibición de artefactos arqueológicos en museos nacionales'),
(6, 'Educación en Museos', '08/22/2013', 'Desarrollo de programas educativos para públicos escolares en museos de ciencia'),
(7, 'Restauración de Esculturas', '12/29/2013', 'Técnicas avanzadas de restauración de esculturas en mármol y bronce para museos de bellas artes'),
(8, 'Diseño de Exposiciones', '09/14/2013', 'Planificación y diseño de espacios expositivos para museos de arte e historia'),
(9, 'Conservación Preventiva', '03/08/2016', 'Control de condiciones ambientales para la preservación de colecciones museísticas'),
(10, 'Documentación de Arte', '01/16/2022', 'Catalogación y documentación de obras de arte para archivos museísticos digitales'),
(11, 'Gestión de Museos Comunitarios', '05/17/2020', 'Desarrollo de estrategias para la participación comunitaria en museos locales'),
(12, 'Paleontología Museística', '04/12/2012', 'Preparación y exhibición de fósiles para museos de historia natural'),
(13, 'Iluminación en Espacios Museísticos', '08/18/2018', 'Diseño de sistemas de iluminación para la exhibición de obras de arte'),
(14, 'Conservación de Textiles Históricos', '05/31/2017', 'Técnicas de preservación y restauración de textiles en museos de indumentaria'),
(15, 'Digitalización de Colecciones', '11/15/2023', 'Técnicas de fotografía y escaneo 3D para la digitalización de patrimonio museístico'),
(16, 'Gestión de Riesgos en Museos', '02/15/2020', 'Planificación de protocolos de emergencia para la protección de colecciones'),
(17, 'Curaduría de Fotografía', '05/25/2020', 'Selección y organización de exposiciones fotográficas para museos especializados'),
(18, 'Interpretación del Patrimonio', '06/24/2024', 'Desarrollo de contenidos narrativos para exposiciones en museos históricos'),
(19, 'Restauración de Cerámica Arqueológica', '03/03/2023', 'Técnicas de reconstrucción y conservación de cerámica precolombina'),
(20, 'Diseño de Museos Virtuales', '12/21/2020', 'Creación de experiencias museísticas en entornos digitales y realidad aumentada'),
(21, 'Gestión de Préstamos Museísticos', '10/17/2021', 'Coordinación de préstamos internacionales de obras de arte entre instituciones'),
(22, 'Conservación de Papel y Grabados', '09/28/2021', 'Técnicas de preservación de obras gráficas y documentos históricos en papel'),
(23, 'Museología Crítica', '02/05/2010', 'Estudio de teorías contemporáneas sobre la función social de los museos'),
(24, 'Exhibiciones Itinerantes', '09/07/2017', 'Logística y planificación de exposiciones itinerantes para museos regionales'),
(25, 'Restauración de Mobiliario Histórico', '12/22/2010', 'Conservación y restauración de muebles antiguos para museos de artes decorativas'),
(26, 'Gestión de Públicos en Museos', '11/06/2015', 'Estrategias para la diversificación y fidelización de audiencias museísticas'),
(27, 'Curaduría de Arte Digital', '12/03/2013', 'Selección y exhibición de obras de arte generativo y nuevas tecnologías'),
(28, 'Conservación de Metales', '10/16/2011', 'Técnicas para prevenir la corrosión en objetos metálicos de colecciones museísticas'),
(29, 'Diseño de Museos para Niños', '08/05/2012', 'Creación de espacios interactivos y educativos para museos infantiles'),
(30, 'Gestión de Fondos Museísticos', '03/03/2016', 'Administración de recursos económicos y financieros para instituciones museísticas'),
(31, 'Restauración de Pintura Mural', '08/19/2017', 'Técnicas especializadas para la conservación de murales en museos al aire libre'),
(32, 'Realidad Virtual en Museos', '02/08/2021', 'Desarrollo de experiencias inmersivas para la interpretación del patrimonio'),
(33, 'Curaduría de Arte Precolombino', '06/11/2010', 'Estudio y exhibición de colecciones de arte indígena americano'),
(34, 'Conservación de Materiales Orgánicos', '07/22/2010', 'Técnicas para la preservación de objetos en madera, cuero y fibras naturales'),
(35, 'Diseño de Señalética Museística', '12/18/2018', 'Creación de sistemas de orientación y comunicación visual para museos'),
(36, 'Gestión de Voluntariado Cultural', '07/31/2014', 'Coordinación de programas de voluntariado en instituciones museísticas'),
(37, 'Restauración de Vidrieras Históricas', '08/14/2024', 'Técnicas de conservación de vitrales para museos y edificios patrimoniales'),
(38, 'Curaduría de Arte Africano', '12/19/2018', 'Estudio y exhibición de colecciones de arte tradicional africano'),
(39, 'Conservación de Fotografía Antigua', '05/30/2016', 'Técnicas para la preservación de daguerrotipos y primeros procesos fotográficos'),
(40, 'Museos y Accesibilidad', '09/17/2018', 'Diseño de programas y espacios inclusivos para públicos con discapacidad'),
(41, 'Gestión de Exposiciones Temporales', '05/29/2020', 'Planificación y ejecución de muestras temporales en museos de arte'),
(42, 'Restauración de Instrumentos Musicales', '05/08/2013', 'Conservación de instrumentos históricos para museos de música'),
(43, 'Curaduría de Arte Asiático', '04/09/2011', 'Estudio y exhibición de colecciones de arte oriental en museos especializados'),
(44, 'Diseño de Almacenes Museísticos', '02/20/2024', 'Planificación de espacios de reserva para colecciones no exhibidas'),
(45, 'Conservación de Materiales Contemporáneos', '09/01/2021', 'Desafíos en la preservación de obras con materiales no tradicionales'),
(46, 'Gestión de Patrocinios Culturales', '09/15/2014', 'Desarrollo de alianzas con empresas para financiamiento de proyectos museísticos'),
(47, 'Restauración de Pergaminos', '11/11/2024', 'Técnicas especializadas para la conservación de documentos medievales'),
(48, 'Curaduría de Arte Latinoamericano', '05/02/2016', 'Estudio y puesta en valor de colecciones de arte latinoamericano'),
(49, 'Museos y Redes Sociales', '06/11/2014', 'Estrategias de comunicación digital para la promoción de museos'),
(50, 'Conservación de Arte Rupestre', '07/11/2011', 'Técnicas de documentación y preservación de pinturas rupestres in situ'),
(51, 'Gestión de Colecciones Museísticas', '06/04/2019', 'Especialización en catalogación, conservación y gestión de colecciones en instituciones museísticas'),
(52, 'Museografía y Diseño de Exposiciones', '03/19/2010', 'Diseño y planificación de espacios expositivos y montaje de exhibiciones museográficas'),
(53, 'Conservación Preventiva en Museos', '04/10/2019', 'Técnicas de conservación preventiva para bienes culturales en entornos museísticos'),
(54, 'Educación y Mediación Cultural en Museos', '02/17/2018', 'Desarrollo de programas educativos y estrategias de mediación cultural para públicos diversos'),
(55, 'Administración de Instituciones Museísticas', '01/07/2011', 'Gestión administrativa y financiera de museos y centros culturales'),
(56, 'Documentación de Bienes Culturales', '10/20/2022', 'Sistemas de registro y documentación de colecciones museísticas'),
(57, 'Curaduría de Arte Contemporáneo', '07/29/2016', 'Investigación y desarrollo de proyectos curatoriales para arte contemporáneo'),
(58, 'Museología Digital', '10/01/2022', 'Aplicación de tecnologías digitales en la gestión y difusión de colecciones museísticas'),
(59, 'Patrimonio Cultural y Museos', '03/17/2022', 'Gestión del patrimonio cultural en el contexto de instituciones museísticas'),
(60, 'Seguridad en Museos', '07/05/2015', 'Protocolos de seguridad y prevención de riesgos para bienes culturales en museos'),
(61, 'Diseño de Iluminación para Espacios Museísticos', '08/12/2024', 'Técnicas de iluminación para la exhibición y conservación de obras en museos'),
(62, 'Gestión de Públicos en Museos', '10/07/2018', 'Estrategias para el estudio y desarrollo de públicos en instituciones museísticas'),
(63, 'Restauración de Bienes Muebles', '10/08/2015', 'Técnicas de restauración aplicadas a bienes culturales en colecciones museísticas'),
(64, 'Comunicación y Marketing para Museos', '06/13/2019', 'Estrategias de comunicación y marketing para instituciones museísticas'),
(65, 'Gestión de Proyectos Culturales en Museos', '01/02/2016', 'Planificación y ejecución de proyectos culturales en el ámbito museístico'),
(66, 'Conservación de Materiales Arqueológicos', '08/07/2024', 'Técnicas especializadas en conservación de materiales arqueológicos para museos'),
(67, 'Derecho y Legislación para Museos', '10/19/2010', 'Marco legal y normativa aplicable a la gestión de instituciones museísticas'),
(68, 'Interpretación del Patrimonio en Museos', '07/03/2018', 'Estrategias de interpretación del patrimonio cultural para exposiciones museísticas'),
(69, 'Gestión de Riesgos en Colecciones Museísticas', '06/27/2023', 'Identificación y gestión de riesgos para la preservación de colecciones'),
(70, 'Museos y Tecnologías Interactivas', '11/10/2015', 'Implementación de tecnologías interactivas en experiencias museísticas'),
(71, 'Catalogación de Obras de Arte', '01/26/2014', 'Sistemas y metodologías para la catalogación de obras artísticas en museos'),
(72, 'Diseño de Espacios Educativos en Museos', '05/31/2013', 'Planificación y diseño de áreas educativas dentro de instituciones museísticas'),
(73, 'Gestión de Exposiciones Itinerantes', '10/22/2016', 'Organización y coordinación de exposiciones itinerantes entre instituciones museísticas'),
(74, 'Conservación de Pintura de Caballete', '05/29/2019', 'Técnicas especializadas en conservación y restauración de pintura en museos'),
(75, 'Museos y Accesibilidad Universal', '01/30/2022', 'Diseño de programas y espacios accesibles en instituciones museísticas'),
(76, 'Gestión de Depósitos Museísticos', '06/03/2010', 'Organización y administración de áreas de reserva y depósitos en museos'),
(77, 'Curaduría de Arte Precolombino', '03/11/2019', 'Especialización en investigación y exposición de arte precolombino en museos'),
(78, 'Museos y Comunidades Locales', '11/29/2013', 'Estrategias de vinculación entre museos y comunidades locales'),
(79, 'Conservación de Fotografía Histórica', '11/25/2021', 'Técnicas de conservación y preservación de colecciones fotográficas en museos'),
(80, 'Gestión de Calidad en Museos', '03/12/2015', 'Implementación de sistemas de calidad en la gestión museística'),
(81, 'Museos y Redes Sociales', '01/28/2017', 'Estrategias de comunicación digital y redes sociales para museos'),
(82, 'Diseño de Señalética Museográfica', '07/11/2017', 'Planificación y diseño de sistemas de señalética para espacios museísticos'),
(83, 'Gestión de Préstamos Internacionales', '01/07/2014', 'Coordinación y logística de préstamos internacionales entre instituciones museísticas'),
(84, 'Conservación de Textiles Históricos', '01/31/2014', 'Técnicas especializadas en conservación de colecciones textiles en museos'),
(85, 'Museos y Turismo Cultural', '01/16/2017', 'Estrategias para la vinculación entre museos y el turismo cultural'),
(86, 'Diseño de Experiencias Inmersivas', '08/25/2012', 'Creación de experiencias inmersivas y multimedia para exposiciones museísticas'),
(87, 'Gestión de Colecciones Científicas', '10/18/2023', 'Administración y conservación de colecciones científicas en museos'),
(88, 'Museología Crítica', '03/19/2021', 'Enfoques teóricos y críticos contemporáneos sobre la museología'),
(89, 'Conservación de Metales Arqueológicos', '08/05/2020', 'Técnicas especializadas en conservación de objetos metálicos en museos'),
(90, 'Museos y Realidad Aumentada', '10/01/2019', 'Aplicación de realidad aumentada en experiencias museísticas y exposiciones'),
(91, 'Gestión de Archivos Museísticos', '08/02/2011', 'Organización y administración de archivos históricos en instituciones museísticas'),
(92, 'Diseño de Catálogos de Exposiciones', '09/05/2018', 'Planificación y diseño de publicaciones y catálogos para exposiciones museísticas'),
(93, 'Museos y Educación No Formal', '05/17/2019', 'Desarrollo de programas educativos no formales en contextos museísticos'),
(94, 'Conservación de Cerámica Arqueológica', '10/20/2023', 'Técnicas especializadas en conservación de cerámica histórica en museos'),
(95, 'Museos y Políticas Culturales', '01/18/2024', 'Análisis del rol de los museos en el marco de las políticas culturales'),
(96, 'Gestión de Espacios Públicos en Museos', '07/21/2021', 'Administración y programación de espacios públicos dentro de museos'),
(97, 'Curaduría de Arte Moderno', '11/06/2018', 'Investigación y desarrollo de proyectos expositivos sobre arte moderno'),
(98, 'Museos y Sostenibilidad', '04/08/2023', 'Estrategias de sostenibilidad ambiental y económica para instituciones museísticas'),
(99, 'Conservación de Documentos Históricos', '02/21/2020', 'Técnicas de preservación y conservación de fondos documentales en museos'),
(100, 'Museos Virtuales y Digitalización', '12/01/2021', 'Creación y gestión de museos virtuales y procesos de digitalización de colecciones'),
(100, 'Digitalización de Colecciones Museísticas', '12/01/2021', 'Técnicas y procesos para la digitalización de acervos en instituciones museísticas'),
(101, 'Gestión de Exposiciones Temporales', '03/10/2021', 'Planificación y coordinación de exposiciones temporales en museos e instituciones culturales'),
(102, 'Conservación de Esculturas en Museos', '03/28/2015', 'Técnicas especializadas en conservación y restauración de esculturas en colecciones museísticas'),
(103, 'Museos y Educación Inclusiva', '04/15/2011', 'Diseño de programas educativos inclusivos para diversos públicos en museos'),
(104, 'Gestión de Riesgos en Museos', '05/19/2019', 'Identificación y prevención de riesgos para colecciones en entornos museísticos'),
(105, 'Curaduría de Arte Digital', '06/24/2019', 'Investigación y exposición de obras de arte digital en contextos museísticos'),
(106, 'Museología Participativa', '10/14/2019', 'Enfoques participativos y comunitarios en la gestión y programación de museos'),
(107, 'Conservación de Materiales Contemporáneos', '01/17/2010', 'Técnicas de conservación para obras de arte con materiales no tradicionales'),
(108, 'Gestión de Fondos Museísticos', '01/20/2018', 'Administración y control de fondos económicos en instituciones museísticas'),
(109, 'Diseño de Itinerarios Museográficos', '09/21/2011', 'Planificación de recorridos y narrativas expositivas en espacios museísticos'),
(110, 'Museos y Realidad Virtual', '04/08/2013', 'Aplicación de tecnologías de realidad virtual en experiencias museísticas'),
(111, 'Catalogación de Arte Moderno', '04/23/2015', 'Sistemas y metodologías para la catalogación de obras de arte moderno'),
(112, 'Gestión de Voluntariado en Museos', '09/13/2022', 'Coordinación y formación de programas de voluntariado en instituciones museísticas'),
(113, 'Conservación Preventiva de Pintura', '09/26/2023', 'Protocolos de conservación preventiva aplicados a colecciones pictóricas en museos'),
(114, 'Museos y Comunidades Indígenas', '02/14/2013', 'Estrategias de colaboración entre museos y comunidades indígenas'),
(115, 'Diseño de Almacenes Museísticos', '12/16/2015', 'Planificación y organización de espacios de almacenamiento para colecciones museísticas'),
(116, 'Gestión de Derechos de Autor en Museos', '10/09/2013', 'Aspectos legales sobre derechos de autor y reproducción de obras en museos'),
(117, 'Conservación de Fotografía Contemporánea', '04/30/2024', 'Técnicas especializadas en conservación de obras fotográficas contemporáneas'),
(118, 'Museos y Neuroeducación', '12/05/2019', 'Aplicación de principios de neuroeducación en experiencias museísticas'),
(119, 'Gestión de Espacios Multifuncionales', '03/09/2020', 'Administración de espacios multifuncionales en instituciones museísticas'),
(120, 'Curaduría de Arte Sonoro', '07/20/2019', 'Investigación y exposición de obras de arte sonoro en contextos museísticos'),
(121, 'Museos y Economía Creativa', '03/25/2016', 'Modelos de economía creativa aplicados a la gestión museística'),
(122, 'Conservación de Arte Efímero', '06/30/2014', 'Técnicas de documentación y conservación de obras de arte efímero en museos'),
(123, 'Gestión de Colecciones Etnográficas', '09/23/2018', 'Administración y conservación de colecciones etnográficas en museos'),
(124, 'Museos y Perspectiva de Género', '05/31/2012', 'Enfoques de género en la interpretación y gestión de colecciones museísticas'),
(125, 'Diseño de Experiencias Táctiles', '03/28/2017', 'Creación de experiencias táctiles y multisensoriales en exposiciones museísticas'),
(126, 'Gestión de Proyectos Internacionales', '02/24/2016', 'Coordinación de proyectos de cooperación internacional entre instituciones museísticas'),
(127, 'Conservación de Arte Contemporáneo', '05/29/2021', 'Técnicas especializadas en conservación de obras de arte contemporáneo'),
(128, 'Museos y Cambio Climático', '10/28/2012', 'Estrategias de sostenibilidad y concienciación ambiental en museos'),
(129, 'Gestión de Archivos Fotográficos', '02/08/2010', 'Organización y conservación de archivos fotográficos en instituciones museísticas'),
(130, 'Curaduría de Arte Latinoamericano', '09/16/2013', 'Investigación y exposición de arte latinoamericano en contextos museísticos'),
(131, 'Museos y Tecnologías Emergentes', '01/07/2012', 'Implementación de tecnologías emergentes en experiencias museísticas'),
(132, 'Conservación de Arte en Papel', '01/08/2012', 'Técnicas especializadas en conservación de obras sobre papel en museos'),
(133, 'Gestión de Audiencias Digitales', '04/25/2022', 'Estrategias para el desarrollo y fidelización de audiencias digitales en museos'),
(134, 'Museos y Arte Público', '03/29/2020', 'Gestión de proyectos de arte público vinculados a instituciones museísticas'),
(135, 'Diseño de Aplicaciones Museísticas', '01/18/2018', 'Desarrollo de aplicaciones móviles para la mediación cultural en museos'),
(136, 'Conservación de Arte Cinético', '10/31/2023', 'Técnicas especializadas en conservación de obras de arte cinético'),
(137, 'Gestión de Espacios Expositivos', '02/23/2012', 'Planificación y administración de espacios expositivos en museos'),
(138, 'Museos y Memoria Histórica', '03/27/2020', 'Gestión de colecciones y narrativas sobre memoria histórica en museos'),
(139, 'Curaduría de Arte Asiático', '03/20/2024', 'Investigación y exposición de arte asiático en contextos museísticos'),
(140, 'Conservación de Arte Conceptual', '01/21/2022', 'Técnicas de documentación y conservación de obras de arte conceptual'),
(141, 'Gestión de Colecciones Científico-Técnicas', '05/24/2021', 'Administración de colecciones científico-técnicas en museos especializados'),
(142, 'Museos y Gamificación', '07/20/2022', 'Aplicación de estrategias de gamificación en experiencias museísticas'),
(143, 'Diseño de Exposiciones Itinerantes', '01/18/2023', 'Planificación y montaje de exposiciones diseñadas para itinerancia'),
(144, 'Conservación de Arte Digital', '10/09/2015', 'Protocolos de preservación y conservación de obras de arte digital'),
(145, 'Gestión de Programas Públicos', '05/12/2012', 'Coordinación de programas públicos y actividades culturales en museos'),
(146, 'Museos y Arte Relacional', '07/14/2015', 'Gestión de proyectos de arte relacional en contextos museísticos'),
(147, 'Curaduría de Arte Africano', '09/08/2014', 'Investigación y exposición de arte africano en contextos museísticos'),
(148, 'Conservación de Arte Textil Contemporáneo', '02/06/2024', 'Técnicas especializadas en conservación de obras textiles contemporáneas'),
(149, 'Gestión de Colecciones de Historia Natural', '11/27/2015', 'Administración de colecciones de historia natural en museos científicos'),
(150, 'Museos y Arte de Nuevos Medios', '05/22/2024', 'Exhibición y conservación de obras de nuevos medios en museos'),
(151, 'Diseño de Espacios Sensoriales', '04/05/2022', 'Creación de espacios expositivos sensoriales para públicos diversos'),
(152, 'Gestión de Colecciones de Diseño', '03/07/2020', 'Administración y conservación de colecciones de diseño en museos'),
(153, 'Conservación de Arte Callejero', '03/12/2012', 'Técnicas de documentación y conservación de arte urbano para museos'),
(154, 'Museos y Arte Participativo', '02/27/2014', 'Gestión de proyectos de arte participativo en instituciones museísticas'),
(155, 'Curaduría de Arte Oceánico', '09/05/2023', 'Investigación y exposición de arte oceánico en contextos museísticos'),
(156, 'Gestión de Colecciones de Moda', '02/14/2012', 'Administración y conservación de colecciones de indumentaria y moda'),
(157, 'Museos y Arte Biotecnológico', '09/19/2010', 'Exhibición y conservación de obras que incorporan elementos biotecnológicos'),
(158, 'Conservación de Arte Sonoro', '07/10/2017', 'Técnicas de preservación y documentación de obras de arte sonoro'),
(159, 'Gestión de Colecciones de Cine', '07/09/2013', 'Administración de colecciones cinematográficas y audiovisuales en museos'),
(160, 'Museos y Arte de Inteligencia Artificial', '01/31/2021', 'Exhibición y conservación de obras creadas con inteligencia artificial');

-- INSERT ESTRUCTURA_ORGANIZACIONAL
-- Nivel 1:
INSERT INTO estructura_organizacional (id_museo, nombre, nivel, tipo, id_jerarquia_estructura, id_jerarquia_museo) VALUES
(1, 'Dirección General del Museo de Arte Moderno', 'Nivel 1', 'direccion', NULL, NULL),
(2, 'Dirección General del Museo Nacional de Bellas Artes', 'Nivel 1', 'direccion', NULL, NULL),
(3, 'Dirección de la Galería de Arte Contemporáneo', 'Nivel 1', 'direccion', NULL, NULL),
(4, 'Dirección Ejecutiva del Centro de Arte Digital', 'Nivel 1', 'direccion', NULL, NULL),
(5, 'Dirección del Museo de Arte Clásico', 'Nivel 1', 'direccion', NULL, NULL),
(6, 'Dirección General del Museo de Arte Latinoamericano', 'Nivel 1', 'direccion', NULL, NULL),
(7, 'Dirección del Museo de Arte Abstracto', 'Nivel 1', 'direccion', NULL, NULL),
(8, 'Dirección del Museo de Arte Oriental', 'Nivel 1', 'direccion', NULL, NULL);

-- Nivel 2:
INSERT INTO estructura_organizacional (id_museo, nombre, nivel, tipo, id_jerarquia_estructura, id_jerarquia_museo) VALUES
(1, 'Departamento de Conservación y Restauración', 'Nivel 2', 'departamento', 1, 1),
(1, 'Departamento de Educación y Programas', 'Nivel 2', 'departamento', 1, 1),
(1, 'Departamento de Curaduría', 'Nivel 2', 'departamento', 1, 1),
(2, 'Departamento de Marketing y Comunicación', 'Nivel 2', 'departamento', 2, 2),
(2, 'Departamento de Investigación y Publicaciones', 'Nivel 2', 'departamento', 2, 2),
(2, 'Departamento de Colecciones', 'Nivel 2', 'departamento', 2, 2),
(3, 'Departamento de Desarrollo y Patrocinios', 'Nivel 2', 'departamento', 3, 3),
(3, 'Departamento de Exposiciones', 'Nivel 2', 'departamento', 3, 3),
(4, 'Departamento de Experiencias Interactivas', 'Nivel 2', 'departamento', 4, 4),
(4, 'Departamento de Innovación Tecnológica', 'Nivel 2', 'departamento', 4, 4),
(5, 'Departamento de Arte Romano', 'Nivel 2', 'departamento', 5, 5),
(5, 'Departamento de Antigüedades', 'Nivel 2', 'departamento', 5, 5),
(6, 'Departamento de Programas Comunitarios', 'Nivel 2', 'departamento', 6, 6),
(6, 'Departamento de Arte Colonial', 'Nivel 2', 'departamento', 6, 6),
(6, 'Departamento de Arte Moderno Latinoamericano', 'Nivel 2', 'departamento', 6, 6),
(7, 'Departamento de Expresionismo Abstracto', 'Nivel 2', 'departamento', 7, 7),
(7, 'Departamento de Geometría Abstracta', 'Nivel 2', 'departamento', 7, 7),
(8, 'Departamento de Arte Chino', 'Nivel 2', 'departamento', 8, 8),
(8, 'Departamento de Arte Japonés', 'Nivel 2', 'departamento', 8, 8);

-- Nivel 3:
INSERT INTO estructura_organizacional (id_museo, nombre, nivel, tipo, id_jerarquia_estructura, id_jerarquia_museo) VALUES
(1, 'Subdepartamento de Talleres Infantiles', 'Nivel 3', 'subdepartamento', 10, 1),
(1, 'Sección de Arte Contemporáneo', 'Nivel 3', 'seccion', 11, 1),
(2, 'Subdepartamento de Biblioteca y Archivo', 'Nivel 3', 'subdepartamento', 13, 2),
(2, 'Sección de Pintura Europea', 'Nivel 3', 'seccion', 14, 2),
(3, 'Subdepartamento de Eventos Especiales', 'Nivel 3', 'subdepartamento', 15, 3),
(3, 'Sección de Nuevos Medios', 'Nivel 3', 'seccion', 16, 3),
(4, 'Subdepartamento de Diseño de Interfaces', 'Nivel 3', 'subdepartamento', 17, 4),
(4, 'Sección de Realidad Virtual', 'Nivel 3', 'seccion', 18, 4),
(5, 'Sección de Escultura Griega', 'Nivel 3', 'seccion', 20, 5),
(5, 'Subdepartamento de Numismática', 'Nivel 3', 'subdepartamento', 20, 5),
(6, 'Subdepartamento de Proyectos Educativos Rurales', 'Nivel 3', 'subdepartamento', 21, 6),
(6, 'Sección de Muralismo', 'Nivel 3', 'seccion', 23, 6),
(7, 'Sección de Arte Minimalista', 'Nivel 3', 'seccion', 25, 7),
(7, 'Subdepartamento de Arte Óptico', 'Nivel 3', 'subdepartamento', 25, 7),
(8, 'Subdepartamento de Caligrafía y Pintura', 'Nivel 3', 'subdepartamento', 26, 8),
(8, 'Sección de Cerámica y Porcelana', 'Nivel 3', 'seccion', 27, 8);

-- Nivel 4:
INSERT INTO estructura_organizacional (id_museo, nombre, nivel, tipo, id_jerarquia_estructura, id_jerarquia_museo) VALUES
(1, 'Subsección de Exposiciones Itinerantes', 'Nivel 4', 'subseccion', 29, 1),
(2, 'Subsección de Manuscritos Antiguos', 'Nivel 4', 'subseccion', 30, 2),
(3, 'Subsección de Proyectos Digitales', 'Nivel 4', 'subseccion', 33, 3),
(4, 'Subsección de Desarrollo de Contenido VR', 'Nivel 4', 'subseccion', 35, 4),
(5, 'Subsección de Cerámica Clásica', 'Nivel 4', 'subseccion', 36, 5),
(6, 'Subsección de Arte Indígena Contemporáneo', 'Nivel 4', 'subseccion', 39, 6),
(7, 'Subsección de Instalaciones Luminosas', 'Nivel 4', 'subseccion', 40, 7),
(8, 'Subsección de Textiles Antiguos', 'Nivel 4', 'subseccion', 43, 8);


INSERT INTO historico_empleado (id_empleado, id_museo, id_estructura_org, fecha_inicio, rol_empleado, fecha_fin) VALUES
(1, 1, 1, '2023-01-15', 'director', NULL),
(2, 1, 11, '2023-03-01', 'curador', NULL),
(3, 1, 10, '2023-05-10', 'administrativo', NULL),
(4, 1, 9, '2022-02-20', 'restaurador', '2024-02-28'),
(5, 2, 2, '2023-02-01', 'director', NULL),
(6, 2, 14, '2023-04-10', 'curador', NULL),
(7, 2, 12, '2023-06-20', 'administrativo', NULL),
(8, 2, 13, '2022-03-05', 'curador', '2023-04-15'),
(9, 3, 3, '2023-03-10', 'director', NULL),
(10, 3, 16, '2023-05-01', 'curador', NULL),
(11, 3, 15, '2023-07-01', 'administrativo', NULL),
(12, 3, 33, '2022-04-15', 'curador', '2023-07-30'),
(13, 4, 4, '2023-04-01', 'director', NULL),
(14, 4, 18, '2023-06-05', 'curador', NULL),
(15, 4, 17, '2023-08-15', 'administrativo', NULL),
(16, 4, 35, '2022-05-20', 'curador', '2023-06-30'),
(17, 5, 5, '2023-05-01', 'director', NULL),
(18, 5, 20, '2023-07-10', 'restaurador', NULL),
(19, 5, 19, '2023-09-01', 'administrativo', NULL),
(20, 5, 36, '2022-06-01', 'curador', '2023-09-15'),
(21, 6, 6, '2023-06-01', 'director', NULL),
(22, 6, 23, '2023-08-05', 'curador', NULL),
(23, 6, 21, '2023-10-10', 'administrativo', NULL),
(24, 6, 22, '2022-07-20', 'curador', '2023-12-31'),
(25, 7, 7, '2023-07-01', 'director', NULL),
(26, 7, 25, '2023-09-01', 'curador', NULL),
(27, 7, 24, '2023-11-05', 'administrativo', NULL),
(28, 7, 40, '2022-08-10', 'curador', '2023-11-25'),
(29, 8, 8, '2023-08-01', 'director', NULL),
(30, 8, 27, '2023-10-15', 'restaurador', NULL),
(31, 8, 26, '2023-12-01', 'administrativo', NULL),
(32, 8, 43, '2022-09-01', 'curador', '2023-10-30');


-- Nivel 1: Insertar Edificios (no tienen padres dentro de esta tabla)
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 1, 'Edificio Principal', 'edificio', 'Edificio principal del Museo de Arte de Vancouver.', '750 Hornby St, Vancouver, BC V6Z 2H7, Canadá', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 2, 'Edificio Central', 'edificio', 'Edificio principal del Museo de Arte de Montreal.', '1380 Sherbrooke St W, Montreal, QC H3G 1J5, Canadá', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (3, 3, 'Edificio Histórico', 'edificio', 'Edificio principal del Museo de la Ciudad de México.', 'José María Pino Suárez 30, Centro Histórico, CDMX, México', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (4, 4, 'Edificio Principal', 'edificio', 'Edificio principal del Museo de Arte Contemporáneo de Monterrey.', 'Av. Constitución 445, Centro, Monterrey, N.L., México', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 5, 'Edificio Principal', 'edificio', 'Edificio principal del Jiangsu Art Museum.', '135 Changjiang Rd, Xuanwu District, Nanjing, Jiangsu, China', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (6, 6, 'Edificio Principal', 'edificio', 'Edificio principal del Museo de Guangdong.', '2 Zhujiang E Rd, Tianhe District, Guangzhou, Guangdong, China', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 7, 'Edificio Principal', 'edificio', 'Edificio principal del Museo Nacional de Australia.', 'Lawson Cres, Acton ACT 2601, Australia', NULL, NULL);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 8, 'Edificio Histórico', 'edificio', 'Edificio principal de la Galería Nacional de Victoria.', '180 St Kilda Rd, Melbourne VIC 3006, Australia', NULL, NULL);

-- Nivel 2: Insertar Pisos (referencian a los edificios)
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 9, 'Planta Baja', 'piso', 'Piso principal con exposiciones temporales.', NULL, 1, 1);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 10, 'Primer Piso', 'piso', 'Piso dedicado a colecciones permanentes.', NULL, 1, 1);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 11, 'Segundo Piso', 'piso', 'Piso con oficinas administrativas y salas de eventos.', NULL, 1, 1);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 12, 'Planta Baja', 'piso', 'Piso de entrada y exposiciones principales.', NULL, 2, 2);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 13, 'Primer Piso', 'piso', 'Piso con galerías de arte europeo.', NULL, 2, 2);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 14, 'Segundo Piso', 'piso', 'Piso con galerías de arte canadiense.', NULL, 2, 2);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 15, 'Tercer Piso', 'piso', 'Piso de arte contemporáneo y oficinas.', NULL, 2, 2);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (3, 16, 'Planta Baja', 'piso', 'Piso de exposiciones históricas y tienda.', NULL, 3, 3);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (3, 17, 'Primer Piso', 'piso', 'Piso con colecciones de arte colonial.', NULL, 3, 3);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (4, 18, 'Planta Baja', 'piso', 'Piso de entrada y galerías de arte contemporáneo.', NULL, 4, 4);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (4, 19, 'Primer Piso', 'piso', 'Piso con exposiciones temporales y auditorio.', NULL, 4, 4);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 20, 'Planta Baja', 'piso', 'Piso de exposiciones de arte tradicional chino.', NULL, 5, 5);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 21, 'Primer Piso', 'piso', 'Piso de arte contemporáneo y galerías internacionales.', NULL, 5, 5);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 22, 'Segundo Piso', 'piso', 'Piso de investigación y biblioteca.', NULL, 5, 5);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (6, 23, 'Planta Baja', 'piso', 'Piso de arte local y exposiciones temporales.', NULL, 6, 6);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (6, 24, 'Primer Piso', 'piso', 'Piso de colecciones históricas y culturales.', NULL, 6, 6);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 25, 'Planta Baja', 'piso', 'Piso de exposiciones aborígenes y tienda.', NULL, 7, 7);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 26, 'Primer Piso', 'piso', 'Piso de historia colonial y moderna.', NULL, 7, 7);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 27, 'Segundo Piso', 'piso', 'Piso de investigación y archivos.', NULL, 7, 7);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 28, 'Planta Baja', 'piso', 'Piso de entrada y galerías de arte australiano.', NULL, 8, 8);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 29, 'Primer Piso', 'piso', 'Piso de arte internacional y exposiciones especiales.', NULL, 8, 8);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 30, 'Segundo Piso', 'piso', 'Piso de arte contemporáneo y diseño.', NULL, 8, 8);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 31, 'Tercer Piso', 'piso', 'Piso de oficinas administrativas y conservación.', NULL, 8, 8);

-- Nivel 3: Insertar Áreas/Secciones (referencian a pisos o edificios)
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 32, 'Galería Principal', 'area seccion', 'Área de exhibición de obras destacadas.', NULL, 1, 9);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 33, 'Sala de Esculturas', 'area seccion', 'Espacio dedicado a esculturas modernas.', NULL, 1, 10);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (1, 34, 'Oficinas Curaduría', 'area seccion', 'Oficinas del equipo de curaduría.', NULL, 1, 11);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 35, 'Sala Renacimiento', 'area seccion', 'Galería de arte del Renacimiento.', NULL, 2, 13);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 36, 'Sala Impresionista', 'area seccion', 'Galería de obras impresionistas.', NULL, 2, 13);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (2, 37, 'Sala Contemporánea', 'area seccion', 'Espacio para arte actual.', NULL, 2, 15);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (3, 38, 'Sala de Orígenes', 'area seccion', 'Exhibición de la fundación de la ciudad.', NULL, 3, 16);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (3, 39, 'Sala Virreinal', 'area seccion', 'Colección de arte del virreinato.', NULL, 3, 17);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (3, 40, 'Auditorio Principal', 'area seccion', 'Espacio para conferencias y eventos.', NULL, 3, 16);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (4, 41, 'Galería Norte', 'area seccion', 'Galería de arte contemporáneo.', NULL, 4, 18);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (4, 42, 'Galería Sur', 'area seccion', 'Galería de exposiciones temporales.', NULL, 4, 19);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 43, 'Sala de Caligrafía', 'area seccion', 'Exhibición de caligrafía y pintura tradicional.', NULL, 5, 20);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 44, 'Sala de Cerámica', 'area seccion', 'Colección de cerámica histórica.', NULL, 5, 20);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (5, 45, 'Sala de Arte Moderno', 'area seccion', 'Galería de arte moderno chino.', NULL, 5, 21);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (6, 46, 'Sala de Arte Cantonés', 'area seccion', 'Exhibición de arte de la región de Cantón.', NULL, 6, 23);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (6, 47, 'Sala de Cultura Ancestral', 'area seccion', 'Colección de artefactos antiguos.', NULL, 6, 24);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (6, 48, 'Sala de Exposiciones Temporales', 'area seccion', 'Espacio para muestras rotativas.', NULL, 6, 23);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 49, 'Galería Aborigen', 'area seccion', 'Exhibición de arte y cultura aborigen.', NULL, 7, 25);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 50, 'Sala de la Federación', 'area seccion', 'Exhibición de la historia de la federación australiana.', NULL, 7, 26);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (7, 51, 'Centro de Investigación', 'area seccion', 'Área de estudio y consulta de archivos.', NULL, 7, 27);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 52, 'Gran Salón', 'area seccion', 'Espacio principal de exhibición.', NULL, 8, 28);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 53, 'Galería Europea', 'area seccion', 'Colección de arte europeo.', NULL, 8, 29);
INSERT INTO estructura_fisica (id_museo, id_estructura_fisica, nombre, tipo_estructura, descripcion, direccion, id_jerarquia_museo, id_jerarquia_estructura) VALUES (8, 54, 'Sala de Fotografía', 'area seccion', 'Galería dedicada a la fotografía.', NULL, 8, 30);

INSERT INTO asignacion_mensual (id_museo, id_estructura_fisica, id_empleado_mantenimiento_vigilancia, mes_ano, turno) VALUES
(1, 1, 1, '2025-06-01', 'matutino'),
(1, 1, 3, '2025-04-01', 'matutino'),
(1, 1, 4, '2025-05-01', 'matutino'),
(1, 9, 2, '2025-06-01', 'vesperino'),
(1, 10, 1, '2025-05-01', 'vesperino'),
(1, 11, 4, '2025-04-01', 'vesperino'),
(1, 32, 3, '2025-06-01', 'nocturno'),
(1, 33, 2, '2025-05-01', 'nocturno'),
(2, 2, 5, '2025-06-01', 'matutino'),
(2, 2, 7, '2025-04-01', 'matutino'),
(2, 2, 8, '2025-05-01', 'matutino'),
(2, 12, 6, '2025-06-01', 'vesperino'),
(2, 13, 5, '2025-05-01', 'vesperino'),
(2, 14, 8, '2025-04-01', 'vesperino'),
(2, 35, 7, '2025-06-01', 'nocturno'),
(2, 36, 6, '2025-05-01', 'nocturno'),
(3, 3, 9, '2025-06-01', 'matutino'),
(3, 3, 11, '2025-04-01', 'matutino'),
(3, 3, 12, '2025-05-01', 'matutino'),
(3, 16, 10, '2025-06-01', 'vesperino'),
(3, 17, 9, '2025-05-01', 'vesperino'),
(3, 38, 11, '2025-06-01', 'nocturno'),
(3, 39, 10, '2025-05-01', 'nocturno'),
(3, 40, 12, '2025-04-01', 'vesperino'),
(4, 4, 13, '2025-06-01', 'matutino'),
(4, 4, 15, '2025-04-01', 'matutino'),
(4, 4, 16, '2025-05-01', 'matutino'),
(4, 18, 14, '2025-06-01', 'vesperino'),
(4, 18, 16, '2025-04-01', 'vesperino'),
(4, 19, 13, '2025-05-01', 'vesperino'),
(4, 41, 15, '2025-06-01', 'nocturno'),
(4, 42, 14, '2025-05-01', 'nocturno'),
(5, 5, 17, '2025-06-01', 'matutino'),
(5, 5, 19, '2025-04-01', 'matutino'),
(5, 5, 20, '2025-05-01', 'matutino'),
(5, 20, 18, '2025-06-01', 'vesperino'),
(5, 21, 17, '2025-05-01', 'vesperino'),
(5, 22, 20, '2025-04-01', 'vesperino'),
(5, 43, 19, '2025-06-01', 'nocturno'),
(5, 44, 18, '2025-05-01', 'nocturno'),
(6, 6, 21, '2025-06-01', 'matutino'),
(6, 6, 23, '2025-04-01', 'matutino'),
(6, 6, 24, '2025-05-01', 'matutino'),
(6, 23, 22, '2025-06-01', 'vesperino'),
(6, 23, 24, '2025-04-01', 'vesperino'),
(6, 24, 21, '2025-05-01', 'vesperino'),
(6, 46, 23, '2025-06-01', 'nocturno'),
(6, 47, 22, '2025-05-01', 'nocturno'),
(7, 7, 25, '2025-06-01', 'matutino'),
(7, 7, 27, '2025-04-01', 'matutino'),
(7, 7, 28, '2025-05-01', 'matutino'),
(7, 25, 26, '2025-06-01', 'vesperino'),
(7, 26, 25, '2025-05-01', 'vesperino'),
(7, 27, 28, '2025-04-01', 'vesperino'),
(7, 49, 27, '2025-06-01', 'nocturno'),
(7, 50, 26, '2025-05-01', 'nocturno'),
(8, 8, 29, '2025-06-01', 'matutino'),
(8, 8, 31, '2025-04-01', 'matutino'),
(8, 8, 32, '2025-05-01', 'matutino'),
(8, 28, 30, '2025-06-01', 'vesperino'),
(8, 29, 29, '2025-05-01', 'vesperino'),
(8, 30, 32, '2025-04-01', 'vesperino'),
(8, 52, 31, '2025-06-01', 'nocturno'),
(8, 53, 30, '2025-05-01', 'nocturno');


INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (1, 32, 'Galería Principal', 'Sala principal para obras destacadas.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (1, 33, 'Sala de Esculturas', 'Espacio dedicado a exhibir esculturas modernas.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (2, 35, 'Sala Renacimiento', 'Galería de arte del período Renacentista.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (2, 36, 'Sala Impresionista', 'Galería dedicada a obras impresionistas.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (2, 37, 'Sala de Arte Contemporáneo', 'Espacio para la exhibición de arte actual.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (3, 38, 'Sala de Orígenes', 'Exhibición sobre la fundación de la ciudad.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (3, 39, 'Sala Virreinal', 'Colección de arte del período virreinal.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (4, 41, 'Galería Norte', 'Galería de arte contemporáneo en la sección norte.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (4, 42, 'Galería Sur', 'Galería para exposiciones temporales en la sección sur.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (5, 43, 'Sala de Caligrafía', 'Exhibición de caligrafía y pintura tradicional china.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (5, 44, 'Sala de Cerámica', 'Colección de cerámica histórica de China.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (5, 45, 'Sala de Arte Moderno', 'Galería de arte moderno chino.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (6, 46, 'Sala de Arte Cantonés', 'Exhibición de arte de la región de Cantón.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (6, 47, 'Sala de Cultura Ancestral', 'Colección de artefactos antiguos y culturales.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (6, 48, 'Sala de Exposiciones Temporales', 'Espacio dedicado a muestras y exhibiciones rotativas.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (7, 49, 'Galería Aborigen', 'Exhibición de arte y cultura aborigen australiana.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (7, 50, 'Sala de la Federación', 'Exhibición sobre la historia de la federación australiana.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (8, 52, 'Gran Salón', 'Espacio principal de exhibición de la galería.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (8, 53, 'Galería Europea', 'Colección de arte europeo de diversas épocas.');
INSERT INTO sala_exposicion (id_museo, id_estructura_fisica, nombre_sala, descripcion) VALUES (8, 54, 'Sala de Fotografía', 'Galería dedicada a la exhibición de fotografía.');


INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (1, 32, 1, '2023-01-10', '2023-01-20');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (1, 33, 2, '2024-05-01', NULL);
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (2, 35, 3, '2022-11-15', '2022-11-30'); 
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (2, 36, 4, '2023-09-01', '2023-09-10'); 
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (3, 38, 6, '2023-03-01', '2023-03-05');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (3, 39, 7, '2024-01-15', NULL);
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (4, 41, 8, '2022-07-01', '2022-07-10');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (4, 42, 9, '2023-04-20', '2023-04-25');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (5, 43, 10, '2023-10-01', '2023-10-15'); 
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (5, 44, 11, '2024-03-10', NULL);
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (6, 46, 13, '2022-05-01', '2022-05-07'); 
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (6, 47, 14, '2023-08-01', '2023-08-05');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (7, 49, 16, '2023-02-01', '2023-02-14');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (7, 50, 17, '2024-01-01', '2024-01-07');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (8, 52, 18, '2022-10-01', '2022-10-03');
INSERT INTO hist_cierre (id_museo, id_estructura_fisica, id_sala, fecha_ini, fecha_fin) VALUES (8, 53, 19, '2023-06-10', '2023-06-15');

-- Inserciones para la tabla coleccion_permanente

-- Museo de Arte Moderno (id_museo: 1)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(1, 11, 'Colección de Arte Contemporáneo', 'Obras representativas del arte global desde 1960 hasta la actualidad.', 'contemporáneo', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(1, 29, 'Arte del Siglo XX', 'Pinturas y esculturas clave del siglo XX, incluyendo movimientos como el cubismo y el surrealismo.', 'siglo XX', 2);

-- Museo Nacional de Bellas Artes (id_museo: 2)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(2, 14, 'Maestros Europeos', 'Colección de obras de grandes maestros de la pintura europea desde el Renacimiento hasta el siglo XIX.', 'europeo', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(2, 31, 'Pintura Latinoamericana', 'Panorama de la pintura latinoamericana, desde el periodo colonial hasta las vanguardias del siglo XX.', 'latinoamericano', 2);

-- Galería de Arte Contemporáneo (id_museo: 3)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(3, 16, 'Nuevos Medios y Digital', 'Obras que exploran la intersección del arte con la tecnología, incluyendo videoarte e instalaciones digitales.', 'digital', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(3, 33, 'Arte Urbano y Grafitis', 'Colección dedicada al arte callejero y las expresiones urbanas contemporáneas.', 'urbano', 2);

-- Centro de Arte Digital (id_museo: 4)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(4, 18, 'Realidad Virtual y Aumentada', 'Experiencias inmersivas y obras de arte creadas con tecnologías de realidad virtual y aumentada.', 'VR', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(4, 35, 'Net Art y Arte Generativo', 'Obras de arte digital que utilizan algoritmos y la web como medio principal.', 'net art', 2);

-- Museo de Arte Clásico (id_museo: 5)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(5, 19, 'Escultura Romana', 'Colección de esculturas romanas, incluyendo retratos y relieves históricos.', 'romano', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(5, 36, 'Cerámica Griega', 'Vasijas y fragmentos de cerámica griega que ilustran la mitología y la vida cotidiana.', 'griego', 2);

-- Museo de Arte Latinoamericano (id_museo: 6)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(6, 23, 'Arte Moderno Latinoamericano', 'Obras de artistas latinoamericanos que definieron los movimientos modernos del siglo XX.', 'moderno', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(6, 39, 'Muralismo Mexicano', 'Fragmentos y estudios de murales icónicos del movimiento muralista mexicano.', 'muralismo', 2);

-- Museo de Arte Abstracto (id_museo: 7)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(7, 24, 'Expresionismo Abstracto', 'Pinturas de gran formato que representan la expresión emocional a través del color y la forma.', 'expresionismo', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(7, 40, 'Minimalismo y Arte Conceptual', 'Obras que exploran la reducción a lo esencial y la primacía de la idea sobre la forma.', 'minimalismo', 2);

-- Museo de Arte Oriental (id_museo: 8)
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(8, 26, 'Pintura y Caligrafía China', 'Rollos, álbumes y obras de caligrafía que muestran la rica tradición artística china.', 'chino', 1);
INSERT INTO coleccion_permanente (id_museo, id_estructura_org, nombre_coleccion, descripcion_caracteristica, palabra_clave, orden_recorrido) VALUES
(8, 43, 'Cerámica y Porcelana Japonesa', 'Ejemplos exquisitos de la cerámica y porcelana japonesa, desde periodos antiguos hasta modernos.', 'japonés', 2);

-- Sentencias INSERT para la tabla col_sal
-- Se asocia cada colección a un mínimo de dos y un máximo de cuatro salas del mismo museo,
-- con un orden de recorrido interno para cada sala.

-- Colección 1: Colección de Arte Contemporáneo (Museo 1)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(1, 32, 1, 1, 11, 1, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(1, 33, 2, 1, 11, 1, 2);

-- Colección 2: Arte del Siglo XX (Museo 1)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(1, 32, 1, 1, 29, 2, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(1, 33, 2, 1, 29, 2, 2);

-- Colección 3: Maestros Europeos (Museo 2)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(2, 35, 3, 2, 14, 3, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(2, 36, 4, 2, 14, 3, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(2, 37, 5, 2, 14, 3, 3);

-- Colección 4: Pintura Latinoamericana (Museo 2)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(2, 35, 3, 2, 31, 4, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(2, 36, 4, 2, 31, 4, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(2, 37, 5, 2, 31, 4, 3);

-- Colección 5: Nuevos Medios y Digital (Museo 3)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(3, 38, 6, 3, 16, 5, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(3, 39, 7, 3, 16, 5, 2);

-- Colección 6: Arte Urbano y Grafitis (Museo 3)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(3, 38, 6, 3, 33, 6, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(3, 39, 7, 3, 33, 6, 2);

-- Colección 7: Realidad Virtual y Aumentada (Museo 4)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(4, 41, 8, 4, 18, 7, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(4, 42, 9, 4, 18, 7, 2);

-- Colección 8: Net Art y Arte Generativo (Museo 4)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(4, 41, 8, 4, 35, 8, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(4, 42, 9, 4, 35, 8, 2);

-- Colección 9: Escultura Romana (Museo 5)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(5, 43, 10, 5, 19, 9, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(5, 44, 11, 5, 19, 9, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(5, 45, 12, 5, 19, 9, 3);

-- Colección 10: Cerámica Griega (Museo 5)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(5, 43, 10, 5, 36, 10, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(5, 44, 11, 5, 36, 10, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(5, 45, 12, 5, 36, 10, 3);

-- Colección 11: Arte Moderno Latinoamericano (Museo 6)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(6, 46, 13, 6, 23, 11, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(6, 47, 14, 6, 23, 11, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(6, 48, 15, 6, 23, 11, 3);

-- Colección 12: Muralismo Mexicano (Museo 6)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(6, 46, 13, 6, 39, 12, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(6, 47, 14, 6, 39, 12, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(6, 48, 15, 6, 39, 12, 3);

-- Colección 13: Expresionismo Abstracto (Museo 7)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(7, 49, 16, 7, 24, 13, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(7, 50, 17, 7, 24, 13, 2);

-- Colección 14: Minimalismo y Arte Conceptual (Museo 7)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(7, 49, 16, 7, 40, 14, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(7, 50, 17, 7, 40, 14, 2);

-- Colección 15: Pintura y Caligrafía China (Museo 8)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(8, 52, 18, 8, 26, 15, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(8, 53, 19, 8, 26, 15, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(8, 54, 20, 8, 26, 15, 3);

-- Colección 16: Cerámica y Porcelana Japonesa (Museo 8)
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(8, 52, 18, 8, 43, 16, 1);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(8, 53, 19, 8, 43, 16, 2);
INSERT INTO col_sal (id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org, id_coleccion, orden_recorrido) VALUES
(8, 54, 20, 8, 43, 16, 3);



-- Sentencias INSERT para la tabla historico_obra_movimiento
-- Cada obra tiene tres registros: dos movimientos históricos con fecha_fin y uno actual con fecha_fin NULL.
-- El 'orden_recomendado' es ascendente (desde 1) solo para las obras 'destacada = si' en su registro actual.
-- Para obras no destacadas o registros históricos, 'orden_recomendado' es NULL.

-- Obra 1: The Crazy One (Museo de Arte de Vancouvert)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(1, '1982-10-09', 'comprado', 'no', 1, 32, 1, 1, 11, 1, 1, 1, 1, '2023-01-15', '1987-10-09', 248698, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(1, '1987-11-20', 'donado de otro museo', 'no', 1, 32, 1, 1, 11, 1, 1, 1, 1, '2023-01-15', '1995-09-29', 204689, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(1, '2024-10-06', 'comprado', 'si', 1, 32, 1, 1, 11, 1, 1, 1, 1, '2023-01-15', NULL, 308709, 1);

-- Obra 2: Forest, British Columbia (Museo de Arte de Vancouvert)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(2, '1970-07-28', 'donado', 'no', 1, 32, 1, 1, 11, 1, 1, 11, 2, '2023-03-01', '1973-10-18', 431268, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(2, '1974-06-13', 'comprado', 'si', 1, 32, 1, 1, 11, 1, 1, 11, 2, '2023-03-01', '1979-11-20', 337678, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(2, '2025-01-22', 'comprado a otro museo', 'si', 1, 32, 1, 1, 11, 1, 1, 11, 2, '2023-03-01', NULL, 484394, 2);

-- Obra 3: Indian Church (Museo de Arte de Vancouvert)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(3, '1978-08-01', 'donado de otro museo', 'no', 1, 32, 1, 1, 29, 2, 1, 10, 3, '2023-05-10', '1982-12-16', 323067, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(3, '1983-05-24', 'comprado', 'si', 1, 32, 1, 1, 29, 2, 1, 10, 3, '2023-05-10', '1990-09-08', 356499, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(3, '2024-12-13', 'donado', 'si', 1, 32, 1, 1, 29, 2, 1, 10, 3, '2023-05-10', NULL, 477123, 3);

-- Obra 4: Vase of Sunflowers (Museo de Arte de Montreal)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(4, '1973-03-01', 'donado', 'si', 2, 35, 3, 2, 14, 3, 2, 2, 5, '2023-02-01', '1977-10-18', 198424, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(4, '1978-01-09', 'comprado a otro museo', 'si', 2, 35, 3, 2, 14, 3, 2, 2, 5, '2023-02-01', '1984-06-21', 400508, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(4, '2024-06-12', 'donado de otro museo', 'no', 2, 35, 3, 2, 14, 3, 2, 2, 5, '2023-02-01', NULL, 150035, NULL);

-- Obra 5: The Reading (Museo de Arte de Montreal)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(5, '1979-05-18', 'comprado a otro museo', 'no', 2, 35, 3, 2, 31, 4, 2, 14, 6, '2023-04-10', '1984-06-25', 188806, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(5, '1985-05-19', 'donado', 'si', 2, 35, 3, 2, 31, 4, 2, 14, 6, '2023-04-10', '1990-03-01', 376999, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(5, '2024-09-02', 'comprado', 'si', 2, 35, 3, 2, 31, 4, 2, 14, 6, '2023-04-10', NULL, 477123, 1);

-- Obra 6: Nude with Raised Arms (Museo de Arte de Montreal)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(6, '1970-12-07', 'donado', 'no', 2, 35, 3, 2, 14, 3, 2, 12, 7, '2023-06-20', '1972-04-16', 466827, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(6, '1972-10-22', 'comprado a otro museo', 'no', 2, 35, 3, 2, 14, 3, 2, 12, 7, '2023-06-20', '1978-08-20', 216776, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(6, '2024-11-20', 'comprado', 'si', 2, 35, 3, 2, 14, 3, 2, 12, 7, '2023-06-20', NULL, 300407, 2);

-- Obra 7: Visión de la Ciudad de México (Museo de la Ciudad de México)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(7, '1971-08-01', 'donado', 'si', 3, 38, 6, 3, 16, 5, 3, 3, 9, '2023-03-10', '1976-02-14', 450000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(7, '1976-08-20', 'comprado', 'si', 3, 38, 6, 3, 16, 5, 3, 3, 9, '2023-03-10', '1983-05-10', 480000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(7, '2024-11-20', 'donado de otro museo', 'no', 3, 38, 6, 3, 16, 5, 3, 3, 9, '2023-03-10', NULL, 390000, NULL);

-- Obra 8: Murales del Patio Central (Museo de la Ciudad de México)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(8, '1980-02-28', 'comprado', 'no', 3, 38, 6, 3, 33, 6, 3, 16, 10, '2023-05-01', '1984-07-09', 280000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(8, '1985-01-15', 'donado de otro museo', 'si', 3, 38, 6, 3, 33, 6, 3, 16, 10, '2023-05-01', '1992-03-25', 310000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(8, '2024-07-28', 'comprado', 'si', 3, 38, 6, 3, 33, 6, 3, 16, 10, '2023-05-01', NULL, 420000, 1);

-- Obra 9: Maqueta de la antigua Tenochtitlán (Museo de la Ciudad de México)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(9, '1975-04-10', 'comprado a otro museo', 'no', 3, 38, 6, 3, 16, 5, 3, 15, 11, '2023-07-01', '1979-09-01', 150000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(9, '1980-03-05', 'donado', 'no', 3, 38, 6, 3, 16, 5, 3, 15, 11, '2023-07-01', '1987-11-30', 200000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(9, '2024-06-13', 'comprado', 'si', 3, 38, 6, 3, 16, 5, 3, 15, 11, '2023-07-01', NULL, 250000, 2);

-- Obra 10: Cabeza Vaca (Museo De Arte Contemporáneo De Monterrey)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(10, '1972-11-15', 'donado de otro museo', 'si', 4, 41, 8, 4, 18, 7, 4, 4, 13, '2023-04-01', '1977-03-20', 350000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(10, '1977-09-01', 'comprado', 'no', 4, 41, 8, 4, 18, 7, 4, 4, 13, '2023-04-01', '1985-01-10', 400000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(10, '2024-06-12', 'donado', 'si', 4, 41, 8, 4, 18, 7, 4, 4, 13, '2023-04-01', NULL, 450000, 1);

-- Obra 11: Paisaje con nubes (Museo De Arte Contemporáneo De Monterrey)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(11, '1978-01-01', 'comprado', 'si', 4, 41, 8, 4, 35, 8, 4, 18, 14, '2023-06-05', '1982-06-15', 210000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(11, '1983-02-10', 'donado', 'no', 4, 41, 8, 4, 35, 8, 4, 18, 14, '2023-06-05', '1990-04-01', 250000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(11, '2024-06-13', 'comprado a otro museo', 'no', 4, 41, 8, 4, 35, 8, 4, 18, 14, '2023-06-05', NULL, 300000, NULL);

-- Obra 12: Sin Título (Serie Columnas) (Museo De Arte Contemporáneo De Monterrey)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(12, '1970-05-20', 'comprado a otro museo', 'no', 4, 41, 8, 4, 18, 7, 4, 17, 15, '2023-08-15', '1975-01-01', 380000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(12, '1975-08-15', 'donado de otro museo', 'si', 4, 41, 8, 4, 18, 7, 4, 17, 15, '2023-08-15', '1982-10-25', 420000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(12, '2024-06-12', 'comprado', 'si', 4, 41, 8, 4, 18, 7, 4, 17, 15, '2023-08-15', NULL, 490000, 2);

-- Obra 13: Montañas y Ríos de Nanjing (Jiangsu Art Museum)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(13, '1974-03-01', 'comprado', 'si', 5, 43, 10, 5, 19, 9, 5, 5, 17, '2023-05-01', '1979-05-10', 120000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(13, '1979-11-20', 'donado', 'no', 5, 43, 10, 5, 19, 9, 5, 5, 17, '2023-05-01', '1987-07-01', 180000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(13, '2024-06-12', 'comprado a otro museo', 'si', 5, 43, 10, 5, 19, 9, 5, 5, 17, '2023-05-01', NULL, 250000, 1);

-- Obra 14: El Jardín Secreto (Jiangsu Art Museum)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(14, '1971-01-01', 'donado de otro museo', 'no', 5, 43, 10, 5, 36, 10, 5, 20, 18, '2023-07-10', '1976-06-30', 90000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(14, '1977-01-15', 'comprado', 'si', 5, 43, 10, 5, 36, 10, 5, 20, 18, '2023-07-10', '1985-09-01', 150000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(14, '2024-06-12', 'donado', 'no', 5, 43, 10, 5, 36, 10, 5, 20, 18, '2023-07-10', NULL, 200000, NULL);

-- Obra 15: Armonía Urbana (Jiangsu Art Museum)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(15, '1979-08-01', 'comprado', 'no', 5, 43, 10, 5, 19, 9, 5, 19, 19, '2023-09-01', '1984-02-28', 100000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(15, '1984-09-10', 'donado de otro museo', 'si', 5, 43, 10, 5, 19, 9, 5, 19, 19, '2023-09-01', '1992-01-01', 130000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(15, '2024-06-12', 'comprado a otro museo', 'si', 5, 43, 10, 5, 19, 9, 5, 19, 19, '2023-09-01', NULL, 180000, 2);

-- Obra 16: Pintura de Flor y Pájaro (Estilo Lingnan) (Museo de Guangdong)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(16, '1970-02-10', 'comprado', 'si', 6, 46, 13, 6, 23, 11, 6, 6, 21, '2023-06-01', '1974-07-20', 80000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(16, '1975-01-05', 'donado de otro museo', 'no', 6, 46, 13, 6, 23, 11, 6, 6, 21, '2023-06-01', '1983-03-15', 120000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(16, '2024-06-12', 'donado', 'si', 6, 46, 13, 6, 23, 11, 6, 6, 21, '2023-06-01', NULL, 170000, 1);

-- Obra 17: Paisaje con Cascada (Museo de Guangdong)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(17, '1972-04-01', 'donado', 'no', 6, 46, 13, 6, 39, 12, 6, 23, 22, '2023-08-05', '1977-09-30', 70000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(17, '1978-05-10', 'comprado a otro museo', 'si', 6, 46, 13, 6, 39, 12, 6, 23, 22, '2023-08-05', '1986-02-20', 110000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(17, '2024-06-12', 'comprado', 'no', 6, 46, 13, 6, 39, 12, 6, 23, 22, '2023-08-05', NULL, 150000, NULL);

-- Obra 18: Jarrón de Cerámica de Guangdong (Museo de Guangdong)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(18, '1970-01-01', 'comprado', 'si', 6, 46, 13, 6, 23, 11, 6, 21, 23, '2023-10-10', '1973-08-01', 50000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(18, '1974-02-15', 'donado', 'no', 6, 46, 13, 6, 23, 11, 6, 21, 23, '2023-10-10', '1980-11-20', 80000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(18, '2024-06-12', 'comprado a otro museo', 'si', 6, 46, 13, 6, 23, 11, 6, 21, 23, '2023-10-10', NULL, 120000, 2);

-- Obra 19: Canoa de corteza indígena (Museo Nacional de Australia)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(19, '1973-05-20', 'comprado', 'no', 7, 49, 16, 7, 24, 13, 7, 7, 25, '2023-07-01', '1978-01-01', 60000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(19, '1978-08-10', 'donado de otro museo', 'si', 7, 49, 16, 7, 24, 13, 7, 7, 25, '2023-07-01', '1986-06-30', 90000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(19, '2024-06-12', 'comprado a otro museo', 'no', 7, 49, 16, 7, 24, 13, 7, 7, 25, '2023-07-01', NULL, 130000, NULL);

-- Obra 20: Wandjina (Pintura Rupestre) (Museo Nacional de Australia)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(20, '1970-01-01', 'donado', 'si', 7, 49, 16, 7, 40, 14, 7, 25, 26, '2023-09-01', '1975-02-28', 100000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(20, '1975-09-10', 'comprado', 'no', 7, 49, 16, 7, 40, 14, 7, 25, 26, '2023-09-01', '1984-05-01', 150000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(20, '2024-06-12', 'donado de otro museo', 'si', 7, 49, 16, 7, 40, 14, 7, 25, 26, '2023-09-01', NULL, 200000, 1);

-- Obra 21: Boomerang Ceremonial con Grabados (Museo Nacional de Australia)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(21, '1976-03-01', 'comprado a otro museo', 'no', 7, 49, 16, 7, 24, 13, 7, 24, 27, '2023-11-05', '1981-10-01', 40000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(21, '1982-04-20', 'donado', 'no', 7, 49, 16, 7, 24, 13, 7, 24, 27, '2023-11-05', '1989-11-30', 60000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(21, '2024-06-12', 'comprado', 'no', 7, 49, 16, 7, 24, 13, 7, 24, 27, '2023-11-05', NULL, 80000, NULL);

-- Obra 22: The Bridal Party (Galería Nacional de Victoria)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(22, '1975-01-01', 'donado de otro museo', 'si', 8, 52, 18, 8, 26, 15, 8, 8, 29, '2023-08-01', '1980-05-15', 300000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(22, '1980-11-20', 'comprado', 'no', 8, 52, 18, 8, 26, 15, 8, 8, 29, '2023-08-01', '1988-02-28', 350000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(22, '2024-06-12', 'donado', 'si', 8, 52, 18, 8, 26, 15, 8, 8, 29, '2023-08-01', NULL, 400000, 1);

-- Obra 23: The Bath of Diana (Galería Nacional de Victoria)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(23, '1972-06-01', 'comprado a otro museo', 'no', 8, 52, 18, 8, 43, 16, 8, 27, 30, '2023-10-15', '1977-11-30', 250000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(23, '1978-06-20', 'donado', 'si', 8, 52, 18, 8, 43, 16, 8, 27, 30, '2023-10-15', '1986-09-01', 300000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(23, '2024-06-12', 'comprado', 'no', 8, 52, 18, 8, 43, 16, 8, 27, 30, '2023-10-15', NULL, 350000, NULL);

-- Obra 24: Untitled (Large Blue) (Galería Nacional de Victoria)
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(24, '1970-01-01', 'comprado', 'si', 8, 52, 18, 8, 26, 15, 8, 26, 31, '2023-12-01', '1974-03-01', 450000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(24, '1974-09-10', 'donado', 'no', 8, 52, 18, 8, 26, 15, 8, 26, 31, '2023-12-01', '1982-12-05', 490000, NULL);
INSERT INTO historico_obra_movimiento (id_obra, fecha_inicio, tipo_obtencion, destacada, id_museo_sala, id_estructura_fisica, id_sala, id_museo_coleccion, id_estructura_org_coleccion, id_coleccion, id_museo_empleado, id_estructura_org_empleado, id_empleado, fecha_inicio_empleado, fecha_fin, valor_obra, orden_recomendado) VALUES
(24, '2024-06-12', 'comprado a otro museo', 'si', 8, 52, 18, 8, 26, 15, 8, 26, 31, '2023-12-01', NULL, 500000, 2);


-- Sentencias INSERT para la tabla mantenimiento_obra
-- Cada obra activa (con fecha_fin NULL en historico_obra_movimiento) tendrá registros de mantenimiento.

-- Obra 1: The Crazy One (Activa, id_historico_obra_movimiento = 3)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(1, 3, 'Inspección visual periódica', 12, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(1, 3, 'Limpieza superficial mensual', 1, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(1, 3, 'Revisión de iluminación de sala', 6, 'otro');

-- Obra 2: Forest, British Columbia (Activa, id_historico_obra_movimiento = 6)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(2, 6, 'Chequeo de condiciones ambientales', 3, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(2, 6, 'Tratamiento preventivo contra plagas', 24, 'restaurador');

-- Obra 3: Indian Church (Activa, id_historico_obra_movimiento = 9)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(3, 9, 'Revisión del estado de conservación', 12, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(3, 9, 'Inventario y verificación de ubicación', 6, 'curador');

-- Obra 4: Vase of Sunflowers (Activa, id_historico_obra_movimiento = 12)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(4, 12, 'Inspección de pigmentos', 6, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(4, 12, 'Rotación de exhibición', 24, 'curador');

-- Obra 5: The Reading (Activa, id_historico_obra_movimiento = 15)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(5, 15, 'Limpieza y desempolvado semanal', 1, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(5, 15, 'Evaluación de daños menores', 3, 'restaurador');

-- Obra 6: Nude with Raised Arms (Activa, id_historico_obra_movimiento = 18)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(6, 18, 'Inspección de marco y soporte', 12, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(6, 18, 'Reporte de condiciones de sala', 6, 'otro');

-- Obra 7: Visión de la Ciudad de México (Activa, id_historico_obra_movimiento = 21)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(7, 21, 'Monitoreo de humedad y temperatura', 1, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(7, 21, 'Limpieza y mantenimiento general', 3, 'otro');

-- Obra 8: Murales del Patio Central (Activa, id_historico_obra_movimiento = 24)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(8, 24, 'Revisión estructural del mural', 60, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(8, 24, 'Documentación fotográfica anual', 12, 'curador');

-- Obra 9: Maqueta de la antigua Tenochtitlán (Activa, id_historico_obra_movimiento = 27)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(9, 27, 'Limpieza de elementos pequeños', 3, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(9, 27, 'Verificación de la integridad de la maqueta', 12, 'curador');

-- Obra 10: Cabeza Vaca (Activa, id_historico_obra_movimiento = 30)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(10, 30, 'Mantenimiento del pedestal y base', 6, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(10, 30, 'Inspección de corrosión o desgaste', 12, 'restaurador');

-- Obra 11: Paisaje con nubes (Activa, id_historico_obra_movimiento = 33)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(11, 33, 'Inspección de posibles decoloraciones', 12, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(11, 33, 'Limpieza del cristal protector', 3, 'otro');

-- Obra 12: Sin Título (Serie Columnas) (Activa, id_historico_obra_movimiento = 36)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(12, 36, 'Revisión de estabilidad de la estructura', 6, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(12, 36, 'Chequeo de posibles grietas o fisuras', 12, 'restaurador');

-- Obra 13: Montañas y Ríos de Nanjing (Activa, id_historico_obra_movimiento = 39)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(13, 39, 'Inspección detallada de la seda', 12, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(13, 39, 'Control de humedad en vitrina', 1, 'curador');

-- Obra 14: El Jardín Secreto (Activa, id_historico_obra_movimiento = 42)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(14, 42, 'Limpieza suave de la superficie', 3, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(14, 42, 'Revisión de la iluminación ambiental', 6, 'curador');

-- Obra 15: Armonía Urbana (Activa, id_historico_obra_movimiento = 45)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(15, 45, 'Inspección de la capa pictórica', 12, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(15, 45, 'Evaluación de la condición del lienzo', 24, 'restaurador');

-- Obra 16: Pintura de Flor y Pájaro (Estilo Lingnan) (Activa, id_historico_obra_movimiento = 48)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(16, 48, 'Monitoreo de la estabilidad del papel', 6, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(16, 48, 'Limpieza de partículas de polvo', 1, 'curador');

-- Obra 17: Paisaje con Cascada (Activa, id_historico_obra_movimiento = 51)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(17, 51, 'Revisión de la exposición a la luz', 3, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(17, 51, 'Mantenimiento del enmarcado', 12, 'restaurador');

-- Obra 18: Jarrón de Cerámica de Guangdong (Activa, id_historico_obra_movimiento = 54)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(18, 54, 'Limpieza de superficie cerámica', 6, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(18, 54, 'Inspección de posibles grietas o chips', 12, 'restaurador');

-- Obra 19: Canoa de corteza indígena (Activa, id_historico_obra_movimiento = 57)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(19, 57, 'Tratamiento de conservación de la corteza', 24, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(19, 57, 'Inspección de estabilidad y soporte', 12, 'curador');

-- Obra 20: Wandjina (Pintura Rupestre) (Activa, id_historico_obra_movimiento = 60)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(20, 60, 'Monitoreo de microclima de la cueva', 1, 'curador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(20, 60, 'Registro de posibles deterioros', 6, 'restaurador');

-- Obra 21: Boomerang Ceremonial con Grabados (Activa, id_historico_obra_movimiento = 63)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(21, 63, 'Limpieza y pulido de la madera', 3, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(21, 63, 'Inspección de grabados y decoraciones', 12, 'restaurador');

-- Obra 22: The Bridal Party (Activa, id_historico_obra_movimiento = 66)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(22, 66, 'Inspección de la capa de barniz', 12, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(22, 66, 'Revisión de la tensión del lienzo', 6, 'curador');

-- Obra 23: The Bath of Diana (Activa, id_historico_obra_movimiento = 69)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(23, 69, 'Limpieza de polvo y suciedad acumulada', 1, 'otro');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(23, 69, 'Monitoreo de posibles cambios de color', 3, 'curador');

-- Obra 24: Untitled (Large Blue) (Activa, id_historico_obra_movimiento = 72)
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(24, 72, 'Inspección de la superficie pintada', 12, 'restaurador');
INSERT INTO mantenimiento_obra (id_obra, id_historico_obra_movimiento, actividad, frecuencia, tipo_resposable) VALUES
(24, 72, 'Chequeo de la estabilidad del material', 6, 'restaurador');

-- Sentencias INSERT para la tabla historico_mantenimiento_realizado
-- Cada actividad de mantenimiento se asocia a una obra activa y a un empleado activo

-- Obra 1: The Crazy One
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(1, 3, 1, '2024-10-24', 'Se detectó un leve desgaste, se aplicó tratamiento preventivo.', 2, 1, 11, '2023-03-01', '2024-10-27');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(1, 3, 2, '2024-11-20', 'Mantenimiento completado satisfactoriamente.', 3, 1, 10, '2023-05-10', '2024-11-26');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(1, 3, 3, '2025-02-19', 'Actividad programada realizada sin incidencias.', 3, 1, 10, '2023-05-10', '2025-02-23');

-- Obra 2: Forest, British Columbia
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(2, 6, 4, '2025-02-09', 'Condiciones óptimas después del mantenimiento.', 2, 1, 11, '2023-03-01', '2025-02-11');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(2, 6, 5, '2025-04-09', 'Se retrasó por coordinación de personal.', 3, 1, 10, '2023-05-10', '2025-04-12');

-- Obra 3: Indian Church
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(3, 9, 6, '2025-05-17', 'Revisión de rutina sin hallazgos inusuales.', 3, 1, 10, '2023-05-10', '2025-05-19');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(3, 9, 7, '2025-03-24', 'Actividad programada realizada sin incidencias.', 2, 1, 11, '2023-03-01', '2025-03-28');

-- Obra 4: Vase of Sunflowers
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(4, 12, 8, '2024-07-06', 'Mantenimiento completado satisfactoriamente.', 7, 2, 12, '2023-06-20', '2024-07-10');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(4, 12, 9, '2024-10-18', 'Pequeñas imperfecciones corregidas.', 6, 2, 14, '2023-04-10', '2024-10-23');

-- Obra 5: The Reading
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(5, 15, 10, '2025-04-17', 'Se ajustaron los parámetros de conservación.', 7, 2, 12, '2023-06-20', '2025-04-20');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(5, 15, 11, '2024-10-13', 'No se encontraron anomalías durante la revisión.', 7, 2, 12, '2023-06-20', '2024-10-16');

-- Obra 6: Nude with Raised Arms
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(6, 18, 12, '2025-05-19', 'Requiere seguimiento en la próxima revisión.', 6, 2, 14, '2023-04-10', '2025-05-26');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(6, 18, 13, '2025-01-20', 'Mantenimiento extendido 2 días por necesidad de ajuste adicional.', 7, 2, 12, '2023-06-20', '2025-01-22');

-- Obra 7: Visión de la Ciudad de México
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(7, 21, 14, '2025-03-03', 'La obra está en excelente estado.', 10, 3, 16, '2023-05-01', '2025-03-05');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(7, 21, 15, '2025-01-08', 'Sin observaciones relevantes.', 11, 3, 15, '2023-07-01', '2025-01-13');

-- Obra 8: Murales del Patio Central
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(8, 24, 16, '2025-03-04', 'Condiciones óptimas después del mantenimiento.', 11, 3, 15, '2023-07-01', '2025-03-05');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(8, 24, 17, '2024-12-07', 'Mantenimiento extendido 2 días por necesidad de ajuste adicional.', 10, 3, 16, '2023-05-01', '2024-12-13');

-- Obra 9: Maqueta de la antigua Tenochtitlán
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(9, 27, 18, '2024-07-04', 'Mantenimiento completado satisfactoriamente.', 11, 3, 15, '2023-07-01', '2024-07-08');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(9, 27, 19, '2025-01-12', 'Se ajustaron los parámetros de conservación.', 10, 3, 16, '2023-05-01', '2025-01-14');

-- Obra 10: Cabeza Vaca
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(10, 30, 20, '2025-01-08', 'Revisión de rutina sin hallazgos inusuales.', 15, 4, 17, '2023-08-15', '2025-01-11');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(10, 30, 21, '2024-08-07', 'Requiere seguimiento en la próxima revisión.', 15, 4, 17, '2023-08-15', '2024-08-12');

-- Obra 11: Paisaje con nubes
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(11, 33, 22, '2024-10-14', 'La obra está en excelente estado.', 14, 4, 18, '2023-06-05', '2024-10-18');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(11, 33, 23, '2025-02-14', 'Mantenimiento completado satisfactoriamente.', 15, 4, 17, '2023-08-15', '2025-02-19');

-- Obra 12: Sin Título (Serie Columnas)
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(12, 36, 24, '2024-09-02', 'Se detectó un leve desgaste, se aplicó tratamiento preventivo.', 15, 4, 17, '2023-08-15', '2024-09-03');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(12, 36, 25, '2025-03-22', 'Mantenimiento extendido 2 días por necesidad de ajuste adicional.', 15, 4, 17, '2023-08-15', '2025-03-24');

-- Obra 13: Montañas y Ríos de Nanjing
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(13, 39, 26, '2024-10-09', 'Sin observaciones relevantes.', 18, 5, 20, '2023-07-10', '2024-10-13');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(13, 39, 27, '2025-01-27', 'Requiere seguimiento en la próxima revisión.', 19, 5, 19, '2023-09-01', '2025-02-02');

-- Obra 14: El Jardín Secreto
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(14, 42, 28, '2024-08-27', 'Pequeñas imperfecciones corregidas.', 19, 5, 19, '2023-09-01', '2024-08-30');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(14, 42, 29, '2024-11-09', 'Condiciones óptimas después del mantenimiento.', 19, 5, 19, '2023-09-01', '2024-11-13');

-- Obra 15: Armonía Urbana
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(15, 45, 30, '2025-04-10', 'Necesaria supervisión continua.', 18, 5, 20, '2023-07-10', '2025-04-14');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(15, 45, 31, '2024-07-28', 'Mantenimiento completado satisfactoriamente.', 18, 5, 20, '2023-07-10', '2024-08-01');

-- Obra 16: Pintura de Flor y Pájaro (Estilo Lingnan)
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(16, 48, 32, '2024-11-20', 'Actividad programada realizada sin incidencias.', 23, 6, 21, '2023-10-10', '2024-11-23');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(16, 48, 33, '2025-05-18', 'Retraso de un día por falta de material específico.', 22, 6, 23, '2023-08-05', '2025-05-24');

-- Obra 17: Paisaje con Cascada
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(17, 51, 34, '2024-07-08', 'La obra está en excelente estado.', 22, 6, 23, '2023-08-05', '2024-07-10');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(17, 51, 35, '2024-10-18', 'Se detectó un leve desgaste, se aplicó tratamiento preventivo.', 23, 6, 21, '2023-10-10', '2024-10-23');

-- Obra 18: Jarrón de Cerámica de Guangdong
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(18, 54, 36, '2025-01-26', 'Mantenimiento completado satisfactoriamente.', 23, 6, 21, '2023-10-10', '2025-01-30');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(18, 54, 37, '2024-09-08', 'Revisión de rutina sin hallazgos inusuales.', 23, 6, 21, '2023-10-10', '2024-09-10');

-- Obra 19: Canoa de corteza indígena
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(19, 57, 38, '2025-03-24', 'Necesaria supervisión continua.', 27, 7, 24, '2023-11-05', '2025-03-29');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(19, 57, 39, '2024-09-17', 'Se ajustaron los parámetros de conservación.', 26, 7, 25, '2023-09-01', '2024-09-21');

-- Obra 20: Wandjina (Pintura Rupestre)
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(20, 60, 40, '2025-01-05', 'No se encontraron anomalías durante la revisión.', 26, 7, 25, '2023-09-01', '2025-01-11');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(20, 60, 41, '2024-10-28', 'Pendiente de suministro de herramienta especial.', 27, 7, 24, '2023-11-05', '2024-11-01');

-- Obra 21: Boomerang Ceremonial con Grabados
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(21, 63, 42, '2024-12-14', 'Actividad programada realizada sin incidencias.', 27, 7, 24, '2023-11-05', '2024-12-19');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(21, 63, 43, '2025-05-09', 'Se detectó un leve desgaste, se aplicó tratamiento preventivo.', 27, 7, 24, '2023-11-05', '2025-05-15');

-- Obra 22: The Bridal Party
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(22, 66, 44, '2024-09-04', 'Mantenimiento completado satisfactoriamente.', 30, 8, 27, '2023-10-15', '2024-09-08');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(22, 66, 45, '2025-01-19', 'Retraso de un día por falta de material específico.', 31, 8, 26, '2023-12-01', '2025-01-20');

-- Obra 23: The Bath of Diana
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(23, 69, 46, '2024-10-25', 'Condiciones óptimas después del mantenimiento.', 31, 8, 26, '2023-12-01', '2024-10-29');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(23, 69, 47, '2025-04-03', 'Mantenimiento extendido 2 días por necesidad de ajuste adicional.', 31, 8, 26, '2023-12-01', '2025-04-09');

-- Obra 24: Untitled (Large Blue)
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(24, 72, 48, '2024-07-28', 'Revisión de rutina sin hallazgos inusuales.', 30, 8, 27, '2023-10-15', '2024-08-01');
INSERT INTO historico_mantenimiento_realizado (id_obra, id_historico_obra_movimiento, id_mantenimiento_obra, fecha_inicio, observaciones, id_empleado, id_museo, id_estructura_org, fecha_inicio_hist_empleado, fecha_fin) VALUES
(24, 72, 49, '2025-02-09', 'La obra está en excelente estado.', 30, 8, 27, '2023-10-15', '2025-02-16');

---------------------------------------------------------------------------------------------Funciones------------------------------------------------------------------------------------------------

-- SP_InsertarTicket: Inserta un nuevo ticket de entrada
CREATE OR REPLACE FUNCTION SP_InsertarTicket(
    p_id_museo NUMERIC,
    p_tipo_ticket VARCHAR(20),
    p_cantidad NUMERIC DEFAULT 1
)
RETURNS VOID AS $$
DECLARE
    v_precio_ticket NUMERIC;
    i INT := 1;
BEGIN
    -- Validar que el museo existe
    IF NOT EXISTS (SELECT 1 FROM museo WHERE museo.id_museo = p_id_museo) THEN
        RAISE EXCEPTION 'Museo con ID % no encontrado.', p_id_museo;
    END IF;

    -- Validar el tipo de ticket
    IF p_tipo_ticket NOT IN ('niño', 'adulto', 'tercera edad') THEN
        RAISE EXCEPTION 'El tipo de ticket debe ser "niño", "adulto" o "tercera edad".';
    END IF;

    -- Validar que la cantidad sea un valor positivo
    IF p_cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad de tickets a generar debe ser un valor positivo.';
    END IF;

    -- Obtener el precio actual del tipo de ticket
    SELECT precio INTO v_precio_ticket
    FROM tipo_ticket_historico
    WHERE tipo_ticket_historico.id_museo = p_id_museo AND tipo_ticket_historico.tipo_ticket = p_tipo_ticket AND tipo_ticket_historico.fecha_fin IS NULL;

    IF v_precio_ticket IS NULL THEN
        RAISE EXCEPTION 'No se encontró un precio activo para el tipo de ticket "%" en el museo %.', p_tipo_ticket, p_id_museo;
    END IF;

    -- Insertar la cantidad de tickets especificada
    WHILE i <= p_cantidad LOOP
        INSERT INTO ticket (
            id_museo,
            precio,
            tipo_ticket,
            fecha_hora_ticket
        ) VALUES (
            p_id_museo,
            v_precio_ticket, -- Usar el precio obtenido del historial
            p_tipo_ticket,
            CURRENT_TIMESTAMP -- Se genera automáticamente con la fecha y hora actuales. Si la columna 'fecha_hora_ticket' es de tipo DATE, la parte de la hora se truncará automáticamente. Para almacenar la hora, la columna debe ser TIMESTAMP.
        );
        i := i + 1;
    END LOOP;

END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION ranking_mundial_museos()
RETURNS TABLE (
    ranking_posicion NUMERIC,
    nombre_museo VARCHAR(50),
    pais VARCHAR(50),
    promedio_permanencia NUMERIC,
    rotacion_puntaje NUMERIC,
    visitas_anuales NUMERIC,
    puntaje_total NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH permanencia_empleados AS (
        SELECT
            he.id_museo,
            ROUND(AVG(
                CASE
                    WHEN he.fecha_fin IS NULL THEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM he.fecha_inicio)
                    ELSE EXTRACT(YEAR FROM he.fecha_fin) - EXTRACT(YEAR FROM he.fecha_inicio)
                END
            ), 2) AS promedio_permanencia
        FROM
            historico_empleado he
        GROUP BY
            he.id_museo
    ),
    visitas_anuales AS (
        SELECT
            t.id_museo,
            EXTRACT(YEAR FROM t.fecha_hora_ticket) AS ano,
            COUNT(*) AS cantidad_visitas
        FROM
            ticket t
        GROUP BY
            t.id_museo, EXTRACT(YEAR FROM t.fecha_hora_ticket)
    ),
    promedio_visitas AS (
        SELECT
            va.id_museo,
            ROUND(AVG(va.cantidad_visitas), 2) AS visitas_promedio
        FROM
            visitas_anuales va
        GROUP BY
            va.id_museo
    ),
    datos_completos AS (
        SELECT
            m.id_museo,
            m.nombre::VARCHAR(50) AS nombre,
            UPPER(lp.nombre_lugar)::VARCHAR(50) AS pais,
            COALESCE(pe.promedio_permanencia, 0) AS promedio_permanencia,
            (CASE
                WHEN COALESCE(pe.promedio_permanencia, 0) >= 10 THEN 1
                WHEN COALESCE(pe.promedio_permanencia, 0) >= 5 THEN 2
                ELSE 3
            END)::NUMERIC AS rotacion_puntaje,
            COALESCE(pv.visitas_promedio, 0) AS visitas_anuales
        FROM
            museo m
            JOIN lugar lc ON m.id_lugar = lc.id_lugar
            JOIN lugar lp ON lc.id_jerarquia = lp.id_lugar
            JOIN permanencia_empleados pe ON m.id_museo = pe.id_museo
            JOIN promedio_visitas pv ON m.id_museo = pv.id_museo
        WHERE
            lp.tipo = 'pais'
    ),
    datos_con_puntaje AS (
        SELECT
            dc.*,
            ROUND((dc.rotacion_puntaje * 0.6 + (1 - (RANK() OVER (ORDER BY dc.visitas_anuales DESC)::NUMERIC / (SELECT COUNT(*)::NUMERIC FROM datos_completos))) * 0.4 * 100))::NUMERIC AS puntaje_total
        FROM
            datos_completos dc
    )
    SELECT
        RANK() OVER (ORDER BY dcp.puntaje_total DESC)::NUMERIC AS ranking_posicion,
        dcp.nombre AS nombre_museo,
        dcp.pais,
        dcp.promedio_permanencia,
        dcp.rotacion_puntaje,
        dcp.visitas_anuales,
        dcp.puntaje_total
    FROM
        datos_con_puntaje dcp
    ORDER BY
        ranking_posicion;
END;
$$ LANGUAGE plpgsql;

-- Función para calcular el ranking de museos por país
CREATE OR REPLACE FUNCTION ranking_pais_museos(p_nombre_pais VARCHAR)
RETURNS TABLE (
    ranking_posicion NUMERIC,
    nombre_museo VARCHAR(50),
    ciudad VARCHAR(50),
    promedio_permanencia NUMERIC,
    rotacion_puntaje NUMERIC,
    visitas_anuales NUMERIC,
    puntaje_total NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    WITH permanencia_empleados AS (
        SELECT
            he.id_museo,
            ROUND(AVG( -- Se añade ROUND para limitar a 2 decimales
                CASE
                    WHEN he.fecha_fin IS NULL THEN EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM he.fecha_inicio)
                    ELSE EXTRACT(YEAR FROM he.fecha_fin) - EXTRACT(YEAR FROM he.fecha_inicio)
                END
            ), 2) AS promedio_permanencia
        FROM
            historico_empleado he
        GROUP BY
            he.id_museo
    ),
    visitas_anuales AS (
        SELECT
            t.id_museo,
            EXTRACT(YEAR FROM t.fecha_hora_ticket) AS ano,
            COUNT(*) AS cantidad_visitas
        FROM
            ticket t
        GROUP BY
            t.id_museo, EXTRACT(YEAR FROM t.fecha_hora_ticket)
    ),
    promedio_visitas AS (
        SELECT
            va.id_museo,
            ROUND(AVG(va.cantidad_visitas), 2) AS visitas_promedio 
        FROM
            visitas_anuales va
        GROUP BY
            va.id_museo
    ),
    museos_pais AS (
        SELECT
            m.id_museo,
            m.nombre::VARCHAR(50) AS nombre,
            UPPER(lc.nombre_lugar)::VARCHAR(50) AS ciudad, 
            UPPER(lp.nombre_lugar)::VARCHAR(50) AS pais, 
            COALESCE(pe.promedio_permanencia, 0) AS promedio_permanencia,
            (CASE
                WHEN COALESCE(pe.promedio_permanencia, 0) >= 10 THEN 1
                WHEN COALESCE(pe.promedio_permanencia, 0) >= 5 THEN 2
                ELSE 3
            END)::NUMERIC AS rotacion_puntaje,
            COALESCE(pv.visitas_promedio, 0) AS visitas_anuales
        FROM
            museo m,
            lugar lc,
            lugar lp,
            permanencia_empleados pe,
            promedio_visitas pv
        WHERE
            m.id_lugar = lc.id_lugar
            AND lc.id_jerarquia = lp.id_lugar
            AND lp.tipo = 'pais'
            AND LOWER(lp.nombre_lugar) = LOWER(p_nombre_pais) 
            AND m.id_museo = pe.id_museo
            AND m.id_museo = pv.id_museo
    ),
    datos_con_puntaje AS (
        SELECT
            mp.*,
            ROUND((mp.rotacion_puntaje * 0.6 + (1 - (RANK() OVER (ORDER BY mp.visitas_anuales DESC)::NUMERIC / (SELECT COUNT(*)::NUMERIC FROM museos_pais))) * 0.4 * 100))::NUMERIC AS puntaje_total
        FROM
            museos_pais mp
    )
    SELECT
        RANK() OVER (ORDER BY dcp.puntaje_total DESC)::NUMERIC AS ranking_posicion,
        dcp.nombre AS nombre_museo,
        dcp.ciudad,
        dcp.promedio_permanencia,
        dcp.rotacion_puntaje,
        dcp.visitas_anuales,
        dcp.puntaje_total
    FROM
        datos_con_puntaje dcp
    ORDER BY
        ranking_posicion;
END;
$$ LANGUAGE plpgsql;

-- Función para calcular la ganancia generada por eventos de un museo
CREATE OR REPLACE FUNCTION fn_ganancia_eventos_museo(p_id_museo NUMERIC)
RETURNS TABLE (
    "Nombre del Museo" VARCHAR(50), -- Renombrado
    "Total generado" TEXT         -- Cambiado a TEXT para concatenar el símbolo '$'
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.nombre::VARCHAR(50) AS "Nombre del Museo",
        '$' || COALESCE(SUM(e.cantidad_asistentes * e.costo_persona), 0)::NUMERIC::TEXT AS "Total generado" -- Concatenado con '$'
    FROM
        museo m, 
        evento e 
    WHERE
        m.id_museo = e.id_museo
        AND m.id_museo = p_id_museo
    GROUP BY
        m.nombre;
END;
$$ LANGUAGE plpgsql;

-- Función para calcular la ganancia generada por tickets de un museo en un rango de fechas
CREATE OR REPLACE FUNCTION fn_ganancia_tickets_museo_fechas(
    p_id_museo NUMERIC,
    p_fecha_inicio DATE,
    p_fecha_fin DATE
)
RETURNS TABLE (
    "Nombre del Museo" VARCHAR(50),
    "Total generado" TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.nombre::VARCHAR(50) AS "Nombre del Museo",
        '$' || COALESCE(SUM(t.precio), 0)::NUMERIC::TEXT AS "Total generado"
    FROM
        museo m, -- JOIN implícito
        ticket t -- JOIN implícito
    WHERE
        m.id_museo = t.id_museo
        AND m.id_museo = p_id_museo
        AND t.fecha_hora_ticket >= p_fecha_inicio -- Filtro por fecha de inicio
        AND t.fecha_hora_ticket <= p_fecha_fin   -- Filtro por fecha de fin
    GROUP BY
        m.nombre;
END;
$$ LANGUAGE plpgsql;


-- Función para calcular la ganancia generada por tickets de un museo
CREATE OR REPLACE FUNCTION fn_ganancia_total_tickets_museo(
    p_id_museo NUMERIC
)
RETURNS TABLE (
    "Nombre del Museo" VARCHAR(50),
    "Total generado" TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.nombre::VARCHAR(50) AS "Nombre del Museo",
        '$' || COALESCE(SUM(t.precio), 0)::NUMERIC::TEXT AS "Total generado"
    FROM
        museo m, -- JOIN implícito
        ticket t -- JOIN implícito
    WHERE
        m.id_museo = t.id_museo
        AND m.id_museo = p_id_museo
    GROUP BY
        m.nombre;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION fn_ganancia_total_museo_ticket_evento(
    p_id_museo NUMERIC
)
RETURNS TABLE (
    "Nombre del Museo" VARCHAR(50),
    "Total generado" TEXT
) AS $$
DECLARE
    total_tickets NUMERIC;
    total_eventos NUMERIC;
BEGIN
    -- Obtener la ganancia total por tickets
    SELECT COALESCE(REPLACE(t."Total generado", '$', '')::NUMERIC, 0)
    INTO total_tickets
    FROM fn_ganancia_total_tickets_museo(p_id_museo) AS t;

    -- Obtener la ganancia total por eventos
    SELECT COALESCE(REPLACE(e."Total generado", '$', '')::NUMERIC, 0)
    INTO total_eventos
    FROM fn_ganancia_eventos_museo(p_id_museo) AS e;

    -- Retornar el nombre del museo y la suma de las ganancias
    RETURN QUERY
    SELECT
        m.nombre::VARCHAR(50) AS "Nombre del Museo",
        '$' || (total_tickets + total_eventos)::TEXT AS "Total generado"
    FROM
        museo m
    WHERE
        m.id_museo = p_id_museo;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------------------------Triggers-----------------------------------------------------------------------------------------

-- Función para actualizar orden_recorrido antes de insertar un nuevo registro
CREATE OR REPLACE FUNCTION actualizar_orden_recorrido_coleccion()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si existe algún registro con el mismo id_museo y orden_recorrido mayor o igual
    IF EXISTS (
        SELECT 1
        FROM coleccion_permanente
        WHERE id_museo = NEW.id_museo
          AND orden_recorrido >= NEW.orden_recorrido
    ) THEN
        -- Incrementar orden_recorrido en 1 para todos esos registros para hacer espacio
        UPDATE coleccion_permanente
        SET orden_recorrido = orden_recorrido + 1
        WHERE id_museo = NEW.id_museo
          AND orden_recorrido >= NEW.orden_recorrido;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger que llama a la función antes de insertar en coleccion_permanente
DROP TRIGGER IF EXISTS before_insert_coleccion ON coleccion_permanente;

CREATE TRIGGER before_insert_coleccion
BEFORE INSERT ON coleccion_permanente
FOR EACH ROW
EXECUTE FUNCTION actualizar_orden_recorrido_coleccion();

-- Valida la insercion de la estructura organizacional
CREATE OR REPLACE FUNCTION validar_jerarquia_organizacional()
RETURNS trigger AS $$
DECLARE
    nivel_padre TEXT;
BEGIN
    -- No puede apuntar a sí misma
    IF NEW.id_estructura_org = NEW.id_jerarquia_estructura AND NEW.id_museo = NEW.id_jerarquia_museo THEN
        RAISE EXCEPTION 'Una estructura organizacional no puede apuntar a sí misma';
    END IF;

    -- Verificar que el nivel sea 'Nivel 1' para permitir id_jerarquia_estructura vacío
    IF NEW.nivel <> 'Nivel 1' AND NEW.id_jerarquia_estructura IS NULL THEN
        RAISE EXCEPTION 'El campo id_jerarquia_estructura debe ser proporcionado para niveles distintos de Nivel 1';
    END IF;

    -- Verificar que el nivel del padre sea mayor
    IF NEW.id_jerarquia_estructura IS NOT NULL THEN
        SELECT nivel INTO nivel_padre
        FROM estructura_organizacional
        WHERE id_museo = NEW.id_jerarquia_museo AND id_estructura_org = NEW.id_jerarquia_estructura;

        IF nivel_padre IS NULL THEN
            RAISE EXCEPTION 'La estructura jerárquica padre no existe';
        END IF;

        -- Verificar que el nivel del hijo sea un nivel menor que el del padre
        IF (CASE 
                WHEN nivel_padre = 'Nivel 1' THEN NEW.nivel <> 'Nivel 2'
                WHEN nivel_padre = 'Nivel 2' THEN NEW.nivel <> 'Nivel 3'
                WHEN nivel_padre = 'Nivel 3' THEN NEW.nivel <> 'Nivel 4'
                WHEN nivel_padre = 'Nivel 4' THEN NEW.nivel IS NOT NULL
                ELSE TRUE
            END) THEN
            RAISE EXCEPTION 'El nivel de la estructura hija debe ser un nivel menor que el de su padre';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_jerarquia_organizacional
BEFORE INSERT OR UPDATE ON estructura_organizacional
FOR EACH ROW EXECUTE FUNCTION validar_jerarquia_organizacional();

--Valida jerarquia fisica

CREATE OR REPLACE FUNCTION validar_jerarquia_fisica()
RETURNS trigger AS $$
DECLARE
    tipo_padre TEXT;
BEGIN
    -- 1. No puede apuntarse a sí misma
    IF NEW.id_estructura_fisica = NEW.id_jerarquia_estructura AND NEW.id_museo = NEW.id_jerarquia_museo THEN
        RAISE EXCEPTION 'Una estructura física no puede apuntar a sí misma';
    END IF;

    -- 2. Si hay padre, debe ser del mismo museo
    IF NEW.id_jerarquia_estructura IS NOT NULL AND NEW.id_jerarquia_museo <> NEW.id_museo THEN
        RAISE EXCEPTION 'La jerarquía debe pertenecer al mismo museo';
    END IF;

    -- 3. Si no es de tipo 'edificio', debe tener padre
    IF NEW.tipo_estructura <> 'edificio' AND NEW.id_jerarquia_estructura IS NULL THEN
        RAISE EXCEPTION 'Solo estructuras de tipo "edificio" pueden no tener jerarquía padre';
    END IF;

    -- 4. Validar que solo las estructuras de tipo 'edificio' pueden tener dirección
    IF NEW.tipo_estructura <> 'edificio' AND NEW.direccion IS NOT NULL THEN
        RAISE EXCEPTION 'Solo las estructuras de tipo "edificio" pueden tener una dirección';
    END IF;

    -- 5. Si tiene padre, debe ser consistente con la jerarquía
    IF NEW.id_jerarquia_estructura IS NOT NULL THEN
        SELECT tipo_estructura INTO tipo_padre
        FROM estructura_fisica
        WHERE id_museo = NEW.id_jerarquia_museo AND id_estructura_fisica = NEW.id_jerarquia_estructura;

        IF tipo_padre IS NULL THEN
            RAISE EXCEPTION 'La estructura física padre no existe';
        END IF;

        -- Reglas jerárquicas entre tipos con restricción estricta
        IF tipo_padre = 'edificio' AND NEW.tipo_estructura <> 'piso' THEN
            RAISE EXCEPTION 'Un edificio solo puede tener pisos como hijos';
        ELSIF tipo_padre = 'piso' AND NEW.tipo_estructura <> 'area seccion' THEN
            RAISE EXCEPTION 'Un piso solo puede tener áreas o secciones como hijos';
        ELSIF tipo_padre = 'area seccion' THEN
            RAISE EXCEPTION 'Un área no puede ser padre de ninguna estructura';
        END IF;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_jerarquia_fisica
BEFORE INSERT OR UPDATE ON estructura_fisica
FOR EACH ROW EXECUTE FUNCTION validar_jerarquia_fisica();

CREATE OR REPLACE FUNCTION trg_validar_actualizar_fecha_fin()
RETURNS trigger AS $$
DECLARE
    fecha_inicio_existente DATE;
    last_record_id NUMERIC;
BEGIN
    -- Verificar si el id_historico_obra_movimiento ya existe
    IF EXISTS (SELECT 1 FROM historico_obra_movimiento WHERE id_historico_obra_movimiento = NEW.id_historico_obra_movimiento) THEN
        -- Obtener la fecha_inicio del registro existente
        SELECT fecha_inicio INTO fecha_inicio_existente
        FROM historico_obra_movimiento
        WHERE id_historico_obra_movimiento = NEW.id_historico_obra_movimiento;

        -- Validar que la nueva fecha_inicio sea mayor que la existente
        IF NEW.fecha_inicio <= fecha_inicio_existente THEN
            RAISE EXCEPTION 'La nueva fecha de inicio (%), debe ser mayor que la fecha de inicio existente (%) para el mismo id_historico_obra_movimiento', NEW.fecha_inicio, fecha_inicio_existente;
        END IF;
    END IF;

    -- Buscar el registro con mayor fecha_inicio menor que la nueva fecha_inicio para la misma obra
    SELECT id_historico_obra_movimiento INTO last_record_id
    FROM historico_obra_movimiento
    WHERE id_obra = NEW.id_obra
      AND fecha_inicio < NEW.fecha_inicio
    ORDER BY fecha_inicio DESC, id_historico_obra_movimiento DESC
    LIMIT 1;

    IF last_record_id IS NOT NULL THEN
        -- Actualizar la fecha_fin del registro encontrado
        UPDATE historico_obra_movimiento
        SET fecha_fin = NEW.fecha_inicio
        WHERE id_obra = NEW.id_obra
          AND id_historico_obra_movimiento = last_record_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_fecha_fin
BEFORE INSERT ON historico_obra_movimiento
FOR EACH ROW EXECUTE FUNCTION trg_validar_actualizar_fecha_fin();

-- Trigger function para hacer cumplir el pedido de fecha_inicio y actualizar fecha_fin del registro anterior
CREATE OR REPLACE FUNCTION validar_hist_empleado()
RETURNS TRIGGER AS $$
DECLARE
    latest_fecha_inicio DATE;
    latest_id_museo NUMERIC;
    latest_id_estructura_org NUMERIC;
BEGIN
    --Encuentra la última fecha_inicio del empleado
    SELECT id_museo, id_estructura_org, fecha_inicio
    INTO latest_id_museo, latest_id_estructura_org, latest_fecha_inicio
    FROM historico_empleado
    WHERE id_empleado = NEW.id_empleado
    ORDER BY fecha_inicio DESC
    LIMIT 1;

    IF latest_fecha_inicio IS NOT NULL THEN
        -- Comprueba si la nueva fecha_inicio es mayor que la última fecha_inicio
        IF NEW.fecha_inicio <= latest_fecha_inicio THEN
            RAISE EXCEPTION 'New fecha_inicio (%) debe ser mayor que la última existente fecha_inicio (%) para empleado %',
                            NEW.fecha_inicio, latest_fecha_inicio, NEW.id_empleado;
        END IF;

        -- Actualizar la fecha_fin del último registro existente a la nueva fecha_inicio
        UPDATE historico_empleado
        SET fecha_fin = NEW.fecha_inicio
        WHERE id_empleado = NEW.id_empleado
          AND id_museo = latest_id_museo
          AND id_estructura_org = latest_id_estructura_org
          AND fecha_inicio = latest_fecha_inicio;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_validar_hist_empleado
BEFORE INSERT ON historico_empleado
FOR EACH ROW
EXECUTE FUNCTION validar_hist_empleado();

-- Función PL/pgSQL para validar rol_empleado y tipo_resposable antes de insert
CREATE OR REPLACE FUNCTION check_rol_responsable_before_insert()
RETURNS TRIGGER AS $$
DECLARE
    empleado_rol VARCHAR(70);
    mantenimiento_tipo_responsable VARCHAR(15);
BEGIN
    -- Obtener el rol_empleado del historico_empleado asociado
    SELECT rol_empleado
      INTO empleado_rol
      FROM historico_empleado
     WHERE id_empleado = NEW.id_empleado
       AND id_museo = NEW.id_museo
       AND id_estructura_org = NEW.id_estructura_org
       AND fecha_inicio = NEW.fecha_inicio_hist_empleado;
       
    IF empleado_rol IS NULL THEN
        RAISE EXCEPTION 'No existe un registro de historico_empleado para el empleado % con museo %, estructura_org % y fecha_inicio %',
            NEW.id_empleado, NEW.id_museo, NEW.id_estructura_org, NEW.fecha_inicio_hist_empleado;
    END IF;
    
    -- Verificar que rol_empleado sea 'curador' o 'restaurador'
    IF empleado_rol NOT IN ('curador', 'restaurador') THEN
        RAISE EXCEPTION 'El rol_empleado asociado debe ser curador o restaurador. Encontrado: %', empleado_rol;
    END IF;
    
    -- Obtener el tipo_resposable del mantenimiento_obra asociado
    SELECT tipo_resposable
      INTO mantenimiento_tipo_responsable
      FROM mantenimiento_obra
     WHERE id_obra = NEW.id_obra
       AND id_historico_obra_movimiento = NEW.id_historico_obra_movimiento
       AND id_mantenimiento_obra = NEW.id_mantenimiento_obra;
    
    IF mantenimiento_tipo_responsable IS NULL THEN
        RAISE EXCEPTION 'No existe mantenimiento_obra para id_obra %, id_historico_obra_movimiento %, id_mantenimiento_obra %',
        NEW.id_obra, NEW.id_historico_obra_movimiento, NEW.id_mantenimiento_obra;
    END IF;
    
    -- Verificar que rol_empleado coincida con tipo_resposable
    IF empleado_rol <> mantenimiento_tipo_responsable THEN
        RAISE EXCEPTION 'El rol_empleado (%) no coincide con el tipo_resposable (%) del mantenimiento_obra asociado.',
            empleado_rol, mantenimiento_tipo_responsable;
    END IF;
    
    -- Si todo está correcto, dejar continuar la inserción
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear trigger BEFORE INSERT en historico_mantenimiento_realizado
CREATE TRIGGER trg_check_rol_responsable
BEFORE INSERT ON historico_mantenimiento_realizado
FOR EACH ROW
EXECUTE FUNCTION check_rol_responsable_before_insert();

CREATE OR REPLACE FUNCTION check_fecha_muerte_gt_nacimiento()
RETURNS TRIGGER AS $$
BEGIN
  -- Only check if fecha_muerte is not null
  IF NEW.fecha_muerte IS NOT NULL THEN
    IF NEW.fecha_nacimiento IS NULL THEN
      RAISE EXCEPTION 'Fecha de nacimiento no puede ser nula si se proporciona fecha de muerte';
    END IF;

    IF NEW.fecha_muerte <= NEW.fecha_nacimiento THEN
      RAISE EXCEPTION 'Fecha de muerte debe ser mayor que fecha de nacimiento';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger on artista table before insert or update
DROP TRIGGER IF EXISTS trg_check_fecha_muerte ON artista;

CREATE TRIGGER trg_check_fecha_muerte
BEFORE INSERT OR UPDATE OF fecha_muerte, fecha_nacimiento ON artista
FOR EACH ROW
EXECUTE FUNCTION check_fecha_muerte_gt_nacimiento();

--------------------------------------------------------------------------------ROLES-------------------------------------------------------------------------------------------------------
-- Creación de Roles (sin contraseña)

-- Rol para los curadores de arte
-- Se encargarán de la gestión de obras, artistas, colecciones y sus mantenimientos.
CREATE ROLE curador WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Rol para el personal de seguridad y mantenimiento
-- Gestionará las asignaciones de vigilancia y mantenimiento de las instalaciones.
CREATE ROLE personal_seguridad_mantenimiento WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Rol para los operadores de taquilla/recepción
-- Gestionará la venta de tickets y el registro de asistencia a eventos.
CREATE ROLE operador_taquilla WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Rol para los restauradores de obras de arte
-- Registrará el historial de mantenimiento y restauración de las obras.
CREATE ROLE restaurador WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Rol para Recursos Humanos (RRHH)
-- Gestionará la información de los empleados, su formación y su historial en el museo.
CREATE ROLE personal_rrhh WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Nuevo rol para el Director
-- Tendrá permisos específicos sobre la estructura organizacional, empleados, historial y resúmenes.
CREATE ROLE director WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Creación de Usuarios y Asignación de Roles

-- Usuario para un curador
CREATE USER user_curador WITH LOGIN PASSWORD '1234';
GRANT curador TO user_curador;

-- Usuario para el personal de seguridad y mantenimiento
CREATE USER user_seg_mant WITH LOGIN PASSWORD '1234';
GRANT personal_seguridad_mantenimiento TO user_seg_mant;

-- Usuario para un operador de taquilla
CREATE USER user_taquilla WITH LOGIN PASSWORD '1234';
GRANT operador_taquilla TO user_taquilla;

-- Usuario para un restaurador
CREATE USER user_restaurador WITH LOGIN PASSWORD '1234';
GRANT restaurador TO user_restaurador;

-- Usuario para el personal de RRHH
CREATE USER user_rrhh WITH LOGIN PASSWORD '1234';
GRANT personal_rrhh TO user_rrhh;

-- Usuario para el Director
CREATE USER user_director WITH LOGIN PASSWORD '1234';
GRANT director TO user_director;


-- Asignación de Privilegios a los Roles

-- 1. Privilegios para 'curador'
-- Gestionará obras, artistas, colecciones y mantenimiento de obras.

-- Obras de Arte y Artistas: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON obra TO curador;
GRANT SELECT, INSERT, UPDATE, DELETE ON artista TO curador;
GRANT SELECT, INSERT, UPDATE, DELETE ON art_obra TO curador;
GRANT USAGE ON SEQUENCE seq_obra TO curador;
GRANT USAGE ON SEQUENCE seq_artista TO curador;

-- Colecciones Permanentes: CRUD completo (gestionar colecciones a su cargo)
GRANT SELECT, INSERT, UPDATE, DELETE ON coleccion_permanente TO curador;
GRANT USAGE ON SEQUENCE seq_coleccion TO curador;

-- Relación Colección-Sala: CRUD completo (asignar obras de su colección a salas)
GRANT SELECT, INSERT, UPDATE, DELETE ON col_sal TO curador;

-- Histórico de Movimiento de Obras: CRUD completo (adquisición, donación, ubicación)
GRANT SELECT, INSERT, UPDATE, DELETE ON historico_obra_movimiento TO curador;
GRANT USAGE ON SEQUENCE seq_historico_obra TO curador;

-- Mantenimiento de Obras: CRUD completo (definir programas de mantenimiento)
GRANT SELECT, INSERT, UPDATE, DELETE ON mantenimiento_obra TO curador;
GRANT USAGE ON SEQUENCE seq_mantenimiento_obra TO curador;

-- Empleados Profesionales e Histórico de Empleados: Solo lectura (para asignar responsables de obras/mantenimiento)
GRANT SELECT ON empleado_profesional TO curador;
GRANT SELECT ON historico_empleado TO curador;
GRANT SELECT ON formacion_profesional TO curador;
GRANT SELECT ON idioma TO curador;
GRANT SELECT ON emp_idi TO curador;

-- Estructura Organizacional y Física del Museo: Solo lectura (para entender el contexto de las colecciones y salas)
GRANT SELECT ON museo TO curador;
GRANT SELECT ON lugar TO curador;
GRANT SELECT ON estructura_organizacional TO curador;
GRANT SELECT ON estructura_fisica TO curador;
GRANT SELECT ON sala_exposicion TO curador;
GRANT SELECT ON evento TO curador; -- Para ver las exposiciones y eventos


-- 2. Privilegios para 'personal_seguridad_mantenimiento'
-- Solo gestionará las asignaciones mensuales de vigilancia y mantenimiento de instalaciones.

-- Asignaciones Mensuales: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON asignacion_mensual TO personal_seguridad_mantenimiento;

-- Empleados de Mantenimiento y Vigilancia: Solo lectura (para ver los empleados disponibles)
GRANT SELECT ON empleado_mantenimiento_vigilancia TO personal_seguridad_mantenimiento;

-- Estructura Física del Museo: Solo lectura (para ver las áreas a las que se asigna personal)
GRANT SELECT ON museo TO personal_seguridad_mantenimiento;
GRANT SELECT ON estructura_fisica TO personal_seguridad_mantenimiento;
GRANT SELECT ON sala_exposicion TO personal_seguridad_mantenimiento;
GRANT SELECT ON hist_cierre TO personal_seguridad_mantenimiento;


-- 3. Privilegios para 'operador_taquilla'
-- Gestionará la venta de tickets y el registro de asistencia a eventos.

-- Tickets: INSERT (para registrar nuevas ventas)
GRANT INSERT ON ticket TO operador_taquilla;
GRANT USAGE ON SEQUENCE seq_ticket TO operador_taquilla;

-- Eventos: SELECT y UPDATE (solo para la cantidad de asistentes)
GRANT SELECT, UPDATE (cantidad_asistentes) ON evento TO operador_taquilla;

-- Tipos de Ticket Históricos y Horarios: Solo lectura (para conocer precios y horarios de apertura)
GRANT SELECT ON tipo_ticket_historico TO operador_taquilla;
GRANT SELECT ON horario TO operador_taquilla;

-- Museo: Solo lectura (información general del museo)
GRANT SELECT ON museo TO operador_taquilla;


-- 4. Privilegios para 'restaurador'
-- Registrará el historial de mantenimiento realizado.

-- Histórico de Mantenimiento Realizado: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON historico_mantenimiento_realizado TO restaurador;
GRANT USAGE ON SEQUENCE seq_historico_mant_re TO restaurador;

-- Mantenimiento de Obra, Obra, Histórico de Movimiento de Obra: Solo lectura (para ver las tareas programadas y la obra)
GRANT SELECT ON mantenimiento_obra TO restaurador;
GRANT SELECT ON obra TO restaurador;
GRANT SELECT ON historico_obra_movimiento TO restaurador;

-- Estructura Organizacional y Museo: Solo lectura (contexto)
GRANT SELECT ON museo TO restaurador;
GRANT SELECT ON estructura_organizacional TO restaurador;


-- 5. Privilegios para 'personal_rrhh'
-- Gestionará la información de los empleados, su formación y su historial en el museo.

-- Empleados Profesionales: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON empleado_profesional TO personal_rrhh;
GRANT USAGE ON SEQUENCE seq_empleado_prof TO personal_rrhh;

-- Formación Profesional: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON formacion_profesional TO personal_rrhh;
GRANT USAGE ON SEQUENCE seq_formacion TO personal_rrhh;

-- Idiomas y relación Empleado-Idioma: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON idioma TO personal_rrhh;
GRANT USAGE ON SEQUENCE seq_idioma TO personal_rrhh;
GRANT SELECT, INSERT, UPDATE, DELETE ON emp_idi TO personal_rrhh;

-- Histórico de Empleado (roles y permanencia): CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON historico_empleado TO personal_rrhh;

-- Empleados de Mantenimiento y Vigilancia: CRUD completo (gestión de este tipo de personal)
GRANT SELECT, INSERT, UPDATE, DELETE ON empleado_mantenimiento_vigilancia TO personal_rrhh;
GRANT USAGE ON SEQUENCE seq_empleado_mv TO personal_rrhh;

-- Tablas de contexto (solo lectura):
GRANT SELECT ON museo TO personal_rrhh;
GRANT SELECT ON lugar TO personal_rrhh;
GRANT SELECT ON estructura_organizacional TO personal_rrhh;
GRANT SELECT ON estructura_fisica TO personal_rrhh;
GRANT SELECT ON sala_exposicion TO personal_rrhh;
GRANT SELECT ON asignacion_mensual TO personal_rrhh; -- Para ver asignaciones de personal de seguridad/mantenimiento

-- 6. Privilegios para 'director'
-- CRUD de estructura_organizacional, empleado_profesional y historico_empleado.
-- SELECT, INSERT, UPDATE en resumen_hist.
-- SELECT en todas las demás tablas.

-- CRUD en tablas específicas:
GRANT SELECT, INSERT, UPDATE, DELETE ON estructura_organizacional TO director;
GRANT USAGE ON SEQUENCE seq_estructura_org TO director; -- Necesario para INSERT

GRANT SELECT, INSERT, UPDATE, DELETE ON empleado_profesional TO director;
GRANT USAGE ON SEQUENCE seq_empleado_prof TO director; -- Necesario para INSERT

GRANT SELECT, INSERT, UPDATE, DELETE ON historico_empleado TO director;

-- SELECT, INSERT, UPDATE en resumen_hist:
GRANT SELECT, INSERT, UPDATE ON resumen_hist TO director;

-- SELECT en todas las demás tablas:
GRANT SELECT ON lugar TO director;
GRANT SELECT ON obra TO director;
GRANT SELECT ON artista TO director;
GRANT SELECT ON art_obra TO director;
GRANT SELECT ON museo TO director;
GRANT SELECT ON tipo_ticket_historico TO director;
GRANT SELECT ON evento TO director;
GRANT SELECT ON ticket TO director;
GRANT SELECT ON horario TO director;
GRANT SELECT ON formacion_profesional TO director;
GRANT SELECT ON idioma TO director;
GRANT SELECT ON emp_idi TO director;
GRANT SELECT ON coleccion_permanente TO director;
GRANT SELECT ON estructura_fisica TO director;
GRANT SELECT ON sala_exposicion TO director;
GRANT SELECT ON col_sal TO director;
GRANT SELECT ON hist_cierre TO director;
GRANT SELECT ON empleado_mantenimiento_vigilancia TO director;
GRANT SELECT ON asignacion_mensual TO director;
GRANT SELECT ON historico_obra_movimiento TO director;
GRANT SELECT ON mantenimiento_obra TO director;
GRANT SELECT ON historico_mantenimiento_realizado TO director;


-- Asegúrate de que los usuarios creados con estos roles puedan conectarse a la base de datos.
-- Por ejemplo, para permitir que 'user_curador' se conecte a una base de datos llamada 'museo_db':
-- GRANT CONNECT ON DATABASE museo_db TO user_curador;
-- Repite esto para cada usuario que necesite conectarse.

-------------------------------------------------------------------------------Calculo----------------------------------------------------------------------------------

-- Ingresos por eventos de un museo General
CREATE OR REPLACE FUNCTION fn_ingresos_eventos_totales(
    p_id_museo NUMERIC
)
RETURNS NUMERIC
LANGUAGE plpgsql
AS $$
DECLARE
    v_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(costo_persona * cantidad_asistentes), 0)
      INTO v_total
      FROM evento
     WHERE id_museo = p_id_museo;

    RETURN v_total;
END;
$$;

-- SELECT fn_ingresos_eventos_totales(2);
commit;
