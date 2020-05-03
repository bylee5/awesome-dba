SELECT a.rolname AS role,
       u.rolname AS member,
       CASE WHEN m.admin_option
            THEN 'YES'
            ELSE 'no'
        END AS admin
FROM pg_auth_members m
JOIN pg_authid a ON (a.oid = m.roleid)
JOIN pg_authid u ON (u.oid = m.member)
ORDER BY 1, 2;