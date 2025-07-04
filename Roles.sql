-- Creación de Roles (sin contraseña)

-- Rol para el administrador general del museo
-- Este rol tendrá amplios permisos para configurar y gestionar el museo, incluyendo RRHH, ingresos, eventos, etc.
CREATE ROLE administrador_museo WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

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

-- Rol para los visitantes (solo lectura de información pública)
CREATE ROLE visitante WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;

-- Creación de Usuarios y Asignación de Roles

-- Usuario para el administrador del museo
CREATE USER user_admin WITH LOGIN PASSWORD 'your_secure_admin_password';
GRANT administrador_museo TO user_admin;

-- Usuario para un curador
CREATE USER user_curador WITH LOGIN PASSWORD 'your_secure_curator_password';
GRANT curador TO user_curador;

-- Usuario para el personal de seguridad y mantenimiento
CREATE USER user_seg_mant WITH LOGIN PASSWORD 'your_secure_security_password';
GRANT personal_seguridad_mantenimiento TO user_seg_mant;

-- Usuario para un operador de taquilla
CREATE USER user_taquilla WITH LOGIN PASSWORD 'your_secure_cashier_password';
GRANT operador_taquilla TO user_taquilla;

-- Usuario para un restaurador
CREATE USER user_restaurador WITH LOGIN PASSWORD 'your_secure_restorer_password';
GRANT restaurador TO user_restaurador;

-- Usuario para un visitante
CREATE USER user_visitante WITH LOGIN PASSWORD 'your_secure_visitor_password';
GRANT visitante TO user_visitante;


-- Asignación de Privilegios a los Roles

-- 1. Privilegios para 'administrador_museo'
-- Tendrá todos los permisos (SELECT, INSERT, UPDATE, DELETE) sobre la mayoría de las tablas.
-- Esto incluye la gestión de museos, lugares, empleados (profesionales), formación, idiomas,
-- estructura organizacional y física, colecciones, horarios, eventos, tickets históricos y resúmenes.
-- Este rol es el administrador de la aplicación y necesita control total sobre los datos del museo.
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrador_museo;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO administrador_museo;


-- 2. Privilegios para 'curador'
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


-- 3. Privilegios para 'personal_seguridad_mantenimiento'
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


-- 4. Privilegios para 'operador_taquilla'
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


-- 5. Privilegios para 'restaurador'
-- Registrará el historial de mantenimiento realizado.

-- Histórico de Mantenimiento Realizado: CRUD completo
GRANT SELECT, INSERT, UPDATE, DELETE ON historico_mantenimiento_realizado TO restaurador;
GRANT USAGE ON SEQUENCE seq_historico_mant_re TO restaurador;

-- Mantenimiento de Obra, Obra, Histórico de Movimiento de Obra: Solo lectura (para ver las tareas programadas y la obra)
GRANT SELECT ON mantenimiento_obra TO restaurador;
GRANT SELECT ON obra TO restaurador;
GRANT SELECT ON historico_obra_movimiento TO restaurador;

-- Empleados Profesionales e Histórico de Empleados: Solo lectura (para registrar quién realizó el mantenimiento)
GRANT SELECT ON empleado_profesional TO restaurador;
GRANT SELECT ON historico_empleado TO restaurador;

-- Estructura Organizacional y Museo: Solo lectura (contexto)
GRANT SELECT ON museo TO restaurador;
GRANT SELECT ON estructura_organizacional TO restaurador;


-- 6. Privilegios para 'visitante'
-- Solo tendrá acceso de lectura a la información pública del museo.

GRANT SELECT ON lugar TO visitante;
GRANT SELECT ON obra TO visitante;
GRANT SELECT ON artista TO visitante;
GRANT SELECT ON art_obra TO visitante;
GRANT SELECT ON museo TO visitante;
GRANT SELECT ON resumen_hist TO visitante;
GRANT SELECT ON evento TO visitante;
GRANT SELECT ON horario TO visitante;
GRANT SELECT ON estructura_organizacional TO visitante;
GRANT SELECT ON coleccion_permanente TO visitante;
GRANT SELECT ON estructura_fisica TO visitante;
GRANT SELECT ON sala_exposicion TO visitante;
GRANT SELECT ON col_sal TO visitante;
GRANT SELECT ON hist_cierre TO visitante;
GRANT SELECT ON historico_obra_movimiento TO visitante;


-- Asegúrate de que los usuarios creados con estos roles puedan conectarse a la base de datos.
-- Por ejemplo, para permitir que 'user_admin' se conecte a una base de datos llamada 'museo_db':
-- GRANT CONNECT ON DATABASE museo_db TO user_admin;
-- Repite esto para cada usuario que necesite conectarse.
