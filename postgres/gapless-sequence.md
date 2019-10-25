# Gapless sequence in Postgres

You can use a separate counter table and either a Postgres function or a [Common Table Expression](https://www.postgresql.org/docs/current/queries-with.html) (CTE) to update the counter value during insert into your target table.

### Using a Postgres function

1. Create a "counter" table containing a single "last value" row:

    ```sql
    CREATE TABLE counter (last_value integer NOT NULL);
    INSERT INTO counter (last_value) VALUES (0);
    ```

2. Create a `get_next_id` function:

    ```sql  
    CREATE OR REPLACE FUNCTION get_next_id(countertable regclass, countercolumn text) RETURNS integer AS $$
    DECLARE
        next_value integer;
    BEGIN
        EXECUTE format('UPDATE %s SET %I = %I + 1 RETURNING %I', countertable, countercolumn, countercolumn, countercolumn) INTO next_value;
        RETURN next_value;
    END;
    $$ LANGUAGE plpgsql;

    COMMENT ON get_next_id(countername regclass) IS 'Increment and return value from integer column $2 in table $1';
    ```

3. Create your desired table to use the gapless sequence:

    ```sql
    CREATE TABLE example (id integer NOT NULL, value text NOT NULL);
    CREATE UNIQUE INDEX events_pkey ON example(id);
    ```

Usage:

```sql
INSERT INTO example(id, value)
VALUES (get_next_id('counter','last_value'), 'example');
```

- [PostgreSQL gapless sequences](https://stackoverflow.com/questions/9984196/postgresql-gapless-sequences) (using a function)

### Using a CTE

Use a separate "counter" table and a [Common Table Expression](https://www.postgresql.org/docs/current/queries-with.html) (CTE) to update the counter value during insert into your target table.

1. Create a "counter" table containing a single "last value" row:

    ```sql
    CREATE TABLE counter (last_value integer NOT NULL);
    INSERT INTO counter (last_value) VALUES (0);
    ```

2. Create your desired table to use the gapless sequence:

    ```sql
    CREATE TABLE example (id integer NOT NULL, value text NOT NULL);
    CREATE UNIQUE INDEX events_pkey ON example(id);
    ```

Usage:

```sql
WITH
  counter AS (
    UPDATE counter SET last_value = last_value + 1
    RETURNING last_value
  )
INSERT INTO example (id, value)
SELECT counter.last_value, 'example';
```

---

With both approaches the `UPDATE` ... `RETURNING` query will _block any other update_ to the `counter` table, thus guaranteeing a gapless sequence. You can test this by attempting to run the query concurrently using `BEGIN;` but not committing. You'll notice that the second query is blocked until the first commits (or aborts).

This also means that if the first query's transaction is aborted (using `ROLLBACK`) the second query can continue and will be assigned the next value, no gaps. Unlike using a traditional Postgres sequence which is not transactional.

A caveat is that if you delete a row from the table you will then have gaps. This can be prevented with a rule to prevent deletion from the table:

```sql
CREATE RULE no_delete_example AS ON DELETE TO example DO INSTEAD NOTHING;
```
