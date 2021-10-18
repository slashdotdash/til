# List tables in a Postgres schema

```SQL
SELECT table_name
FROM information_schema.tables
WHERE table_schema = '<schema>' AND table_type = 'BASE TABLE'
ORDER BY table_name;
```
