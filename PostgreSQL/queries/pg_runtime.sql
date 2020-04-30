SELECT pg_postmaster_start_time() AS pg_start,
       current_timestamp - pg_postmaster_start_time() AS runtime;