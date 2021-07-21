# Install TimescaleDB with Postgres.app

Following the [install from source](https://docs.timescale.com/latest/getting-started/installation/macos/installation-source) instructions.

1. Install `cmake` and `openssl` via Homebrew:

    ```shell
    brew install cmake
    brew install openssl
    ```

2. Clone Timescale GitHub repo:

    ```shell
    git clone https://github.com/timescale/timescaledb.git
    cd timescaledb
    git checkout 2.3.1
    ```

3. Build Timescale extension:

    ```shell
    OPENSSL_ROOT_DIR=/usr/local/opt/openssl ./bootstrap -DREGRESS_CHECKS=OFF
    cd build && make
    ```

4. Install Timescale extension:

    ```shell
    make install
    ```

5. Locate Postgres config file:

    ```shell
    psql -d postgres -c "SHOW config_file;"
    ```

6. Modify `postgresql.conf` to add the TimescaleDB library:

    ```
    shared_preload_libraries = 'timescaledb'
    ```

7. Restart Postgres.

8. Create TimescaleDB extension in Postgres:

    ```sql
    CREATE EXTENSION IF NOT EXISTS "timescaledb" CASCADE;
    ```

## Check which Timescale version is installed

```SQL
SELECT default_version, installed_version
FROM pg_available_extensions
WHERE name = 'timescaledb';
```

## Upgrade an existing Timescale database

1. Follow the steps 2, 3, and 4 in the "Install TimescaleDB with Postgres.app" section above, but checkout the updated Timescale version:

    ```bash
    cd timescaledb
    git checkout 2.3.1
    ```

    ... then run steps 3 and 4 above.

2. Connect to the Timescale database using `psql -X`:

    ```bash
    psql -X -d <database>
    ```

3. Upgrade Timescale extension:

    ```SQL
    ALTER EXTENSION timescaledb UPDATE;
    ```
