-- Función para obtener el rol y los privilegios asignados a un usuario.
-- Esta función consulta las tablas del catálogo del sistema de PostgreSQL
-- para determinar el rol de un usuario y los permisos que tiene sobre
-- tablas y secuencias.

CREATE OR REPLACE FUNCTION get_user_privileges(p_username VARCHAR)
RETURNS TABLE (
    user_name NAME,
    assigned_role NAME,
    object_type TEXT,
    object_schema NAME,
    object_name NAME,
    privilege_type TEXT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_oid OID;
    v_role_oid OID;
BEGIN
    -- Obtener el OID del usuario (usando usesysid para pg_user)
    SELECT usesysid INTO v_user_oid FROM pg_user WHERE usename = p_username;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Usuario "%" no encontrado.', p_username;
    END IF;

    -- Obtener el OID del rol principal asignado al usuario
    -- Asumimos que el usuario hereda los privilegios de un rol principal
    -- Esto busca el rol al que el usuario es miembro directo y que no es el mismo usuario.
    SELECT r.oid INTO v_role_oid
    FROM pg_roles r
    JOIN pg_auth_members am ON r.oid = am.roleid
    WHERE am.member = v_user_oid
    AND r.rolname != p_username -- Asegurarse de que no sea el mismo usuario actuando como rol
    LIMIT 1; -- Tomar el primer rol encontrado si hay varios

    IF NOT FOUND THEN
        -- Si el usuario no es miembro directo de un rol, su propio nombre de usuario es el rol
        SELECT oid INTO v_role_oid FROM pg_roles WHERE rolname = p_username;
    END IF;

    -- Devolver el nombre del usuario y el rol asignado
    user_name := p_username;
    SELECT rolname INTO assigned_role FROM pg_roles WHERE oid = v_role_oid;

    -- Privilegios a nivel de tabla
    RETURN QUERY
    SELECT
        p_username::NAME AS user_name, -- Cast p_username to NAME
        (SELECT rolname FROM pg_roles WHERE oid = v_role_oid) AS assigned_role,
        'TABLE' AS object_type,
        n.nspname AS object_schema,
        c.relname AS object_name,
        p.privilege_type
    FROM
        pg_class c
    JOIN
        pg_namespace n ON n.oid = c.relnamespace
    CROSS JOIN LATERAL (
        VALUES ('SELECT'), ('INSERT'), ('UPDATE'), ('DELETE'), ('TRUNCATE'), ('REFERENCES'), ('TRIGGER')
    ) AS p(privilege_type)
    WHERE
        c.relkind = 'r' -- 'r' para tablas regulares
        AND n.nspname = 'public' -- Asume el esquema 'public'
        AND has_table_privilege(v_role_oid, c.oid, p.privilege_type)
    ORDER BY
        object_name, privilege_type;

    -- Privilegios a nivel de secuencia
    RETURN QUERY
    SELECT
        p_username::NAME AS user_name, -- Cast p_username to NAME
        (SELECT rolname FROM pg_roles WHERE oid = v_role_oid) AS assigned_role,
        'SEQUENCE' AS object_type,
        n.nspname AS object_schema,
        c.relname AS object_name,
        p.privilege_type
    FROM
        pg_class c
    JOIN
        pg_namespace n ON n.oid = c.relnamespace
    JOIN
        pg_sequence s ON c.oid = s.seqrelid -- Une con pg_sequence para asegurar que es una secuencia real
    CROSS JOIN LATERAL (
        VALUES ('USAGE'), ('SELECT'), ('UPDATE')
    ) AS p(privilege_type)
    WHERE
        c.relkind = 'S' -- 'S' para secuencias
        AND n.nspname = 'public' -- Asume el esquema 'public'
        AND has_sequence_privilege(v_role_oid, c.oid, p.privilege_type)
    ORDER BY
        object_name, privilege_type;

    -- Nota: Esta función solo muestra los privilegios directos sobre tablas y secuencias
    -- para el rol principal asignado. Los privilegios a nivel de columna no se incluyen
    -- en este ejemplo para mantener la simplicidad, pero se podrían añadir consultando
    -- information_schema.role_column_grants.
    -- También, los privilegios heredados de otros roles a los que el rol principal
    -- pudiera ser miembro no se desglosan aquí, solo se muestran los efectivos.
END;
$$;
