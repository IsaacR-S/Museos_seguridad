-- Función para obtener el rol y los privilegios asignados a un usuario.
-- Esta función consulta las tablas del catálogo del sistema de PostgreSQL
-- para determinar el rol de un usuario y los permisos que tiene sobre
-- tablas y secuencias.

SELECT grantee, table_schema, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE grantee <> 'postgres' AND grantee <> 'PUBLIC' AND grantee <> 'pg_read_all_stats'
ORDER BY grantee, table_schema, table_name;
