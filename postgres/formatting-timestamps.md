# Formatting timestamps

Format a timestamp:

```sql
SELECT to_char(now() - '2019-10-25 8:30'::timestamp, 'HH:MI');
```

See [Data Type Formatting Functions](https://www.postgresql.org/docs/current/functions-formatting.html) for template patterns.

Convert a timestamp to minutes:

```sql
SELECT extract(epoch from (now() - '2019-10-25 8:30'::timestamp)) / 60;
```
