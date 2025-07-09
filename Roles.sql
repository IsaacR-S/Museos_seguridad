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
