# Recreate Postgres schema

Dropping and creating a schema, such as the default `public` schema, is useful for deleting all tables, data, functions, views, etc.

```sql
DROP SCHEMA public CASCADE;
CREATE SCHEMA public;

GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO public;
```

- [How can I drop all the tables in a PostgreSQL database?](https://stackoverflow.com/questions/3327312/how-can-i-drop-all-the-tables-in-a-postgresql-database)
