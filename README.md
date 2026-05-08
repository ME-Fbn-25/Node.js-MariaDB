# Node.js-MariaDB

## What this is
This project serves a small web UI (in `Website/`) where you can paste a SQL script (textarea) and get query results back from MariaDB.

## Start the server
```bash
DB_HOST=localhost \
DB_PORT=3306 \
DB_USER=root \
DB_PASSWORD= \
DB_NAME=ExampleDB \
node Website/server.js
```

Then open:
`http://localhost:3000`

## SQL you can run
- Single or multi-statement scripts are supported.
- `USE <db>;` is allowed (it’s ignored by the backend; `DB_NAME` is used instead).
- Only `SELECT` / `WITH` statements are executed.

Example: `SQL-Queries/examples/w0-do.sql`

## Notes / security
This is intended for local/private use. The backend blocks most write/DDL statements, but it’s still not a hardened “production” SQL console.