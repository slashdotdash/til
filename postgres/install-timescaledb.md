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
    git checkout 1.6.0
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
