---------------------------------------------------------------------------------------------------------Crear ROl---------------------------------------------------------------------
CREATE ROLE operador_taquilla WITH
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION;
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

----------------------------------------------------------------------------------------------------------Borrar ROL---------------------------------------------------------------------------------

create role visitante2;
REASSIGN OWNED BY visitante TO visitante2;

DROP OWNED BY visitante;
DROP ROLE visitante;

-----------------------------------------------------------------------------------------------------------Crear usuario---------------------------------------------------------------------------

CREATE USER user_director WITH LOGIN PASSWORD '1234';
GRANT director TO user_director;

-------------------------------------------------------------------------------------------------------Select ver privilegios------------------------------------------------------------------------------

SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee <> 'postgres' AND grantee <> 'PUBLIC' AND grantee <> 'pg_read_all_stats'
ORDER BY grantee, table_schema, table_name;


