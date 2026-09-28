# CAMS AI Chatbot — Production Database Deployment & Provisioning Guide

This document defines the exact PostgreSQL configuration, provisioning steps, safety constraints, and connectivity requirements for connecting the **CAMS AI Chatbot** to the production database.

---

## 1. Database Specifications

| Specification | Production Requirement | Verified Project Configuration |
|---|---|---|
| **Database Engine** | PostgreSQL 16.x or 17.x | PostgreSQL 17 (verified against CAMS schema backup) |
| **Target Database Name** | `cams_db` (or institutional instance name) | Sourced via `DATABASE_URL` |
| **Target Schema** | `public` | 122 relational tables |
| **Driver / Client** | `psycopg2-binary >= 2.9.9`, `SQLAlchemy >= 2.0.28` | Pre-configured in `requirements.txt` |
| **Connection Pooling** | `pool_size=10`, `max_overflow=20`, `pool_pre_ping=True` | Configured in `app/database/connection.py` |
| **Query Timeout** | `3000ms` (3 seconds) | Configured at both connection level and DB role level |
| **Row Clamping** | `LIMIT 500` maximum | Enforced by Safe Query Layer `QueryPolicy` |
| **Transaction Mode** | `SET default_transaction_read_only = on` | Enforced at engine & role level |

---

## 2. Dedicated Read-Only User (`cams_readonly`)

To protect institutional CAMS records and enforce the principle of least privilege, the chatbot must connect using the dedicated `cams_readonly` database user.

### Provisioning Script Location
[`backend/scripts/provision_cams_readonly.sql`](file:///c:/Users/veeno/OneDrive/Desktop/CAMS/cams-chatbot/backend/scripts/provision_cams_readonly.sql)

### Detailed Permission Breakdown
1. **`GRANT CONNECT ON DATABASE cams_db TO cams_readonly;`**  
   Allows the service to establish a network connection to the target database.
2. **`GRANT USAGE ON SCHEMA public TO cams_readonly;`**  
   Grants access to lookup table names and types in the `public` schema.
3. **`GRANT SELECT ON ALL TABLES IN SCHEMA public TO cams_readonly;`**  
   Grants read-only access across all 122 existing CAMS tables (e.g. `students`, `courses`, `exams`, `marks`, `attendance`).
4. **`ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO cams_readonly;`**  
   Ensures any future academic tables created by the ERP system are automatically accessible for read-only queries.
5. **`GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_sessions, chat_messages TO cams_readonly;`**  
   Grants scoped write permissions strictly to the two native chatbot tables for storing conversation history.
6. **`ALTER ROLE cams_readonly SET statement_timeout = '3000';`**  
   Cancels any query running longer than 3 seconds to prevent table locks and runaway queries.
7. **`ALTER ROLE cams_readonly SET default_transaction_read_only = 'on';`**  
   Configures PostgreSQL to automatically reject write transactions on standard tables.

---

## 3. Database Safety Guarantee

The provisioning process and chatbot query engine are **100% Non-Destructive**:
- **NO `DROP DATABASE` or `DROP TABLE`** commands exist in the codebase.
- **NO `TRUNCATE` or `DELETE`** operations can be performed against academic CAMS tables.
- **NO schema migrations or schema modifications** are executed.
- The existing CAMS production data remains untouched.

---

## 4. Connection String (`DATABASE_URL`) Format

The backend dynamically reads the database connection string from the `DATABASE_URL` environment variable:

```
postgresql://<username>:<password>@<host>:<port>/<database_name>?sslmode=<ssl_mode>
```

### Examples:
- **Local Development / Staging**:
  ```env
  DATABASE_URL="postgresql://cams_readonly:cams_readonly_pass@127.0.0.1:5433/cams_db"
  ```
- **Production (with SSL enabled)**:
  ```env
  DATABASE_URL="postgresql://cams_readonly:your_strong_password@db.internal.college.edu:5432/cams_db?sslmode=require"
  ```

---

## 5. Network & Firewall Requirements

- **Inbound Port**: Port `5432` (or custom port e.g. `5433`) on the database server must be open to the backend host / container subnet.
- **TLS / SSL**: For cloud-hosted databases (AWS RDS, GCP Cloud SQL, Azure Database for PostgreSQL), append `?sslmode=require` or `?sslmode=verify-full` to the `DATABASE_URL`.
- **Database IP Restriction**: Disallow public internet access to PostgreSQL port; restrict ingress to backend server IP addresses.

---

## 6. Manual Execution Instructions (For Database Administrator)

When ready to provision the database user in your production PostgreSQL cluster:

1. Connect as PostgreSQL superuser:
   ```bash
   psql -h <db-host> -U postgres -d cams_db
   ```
2. Execute the provisioning script:
   ```sql
   \i cams-chatbot/backend/scripts/provision_cams_readonly.sql
   ```
3. Test connectivity with the new role:
   ```bash
   psql -h <db-host> -U cams_readonly -d cams_db -c "SELECT count(*) FROM students;"
   ```
4. Verify read-only enforcement:
   ```sql
   -- This must fail with ERROR: cannot execute INSERT in a read-only transaction
   INSERT INTO students (id) VALUES ('test_fail');
   ```
5. Set `DATABASE_URL` in `cams-chatbot/backend/.env`.
