# CAMS AI Chatbot — Production Deployment Guide

This guide provides step-by-step, provider-neutral instructions for deploying the **CAMS AI Chatbot** in a production environment.

---

## A. Prerequisites

### Infrastructure Requirements
- **PostgreSQL Server**: PostgreSQL 16 or 17 instance with the CAMS database restored (122 relational tables).
- **Backend Host / Container**: Linux server or container runtime (Docker, Kubernetes, AWS ECS, GCP Cloud Run) with Python 3.10+.
- **Frontend Host / CDN**: Web server (Nginx, Caddy, AWS S3 + CloudFront, Vercel, Netlify) capable of serving static Single Page Applications (SPA).
- **Network Access**:
  - Outbound HTTPS to `https://integrate.api.nvidia.com/v1` (for NVIDIA NIM).
  - Outbound HTTPS to E2B Sandbox API (for code execution).
  - Backend-to-PostgreSQL connectivity (port 5432 / 5433).

---

## B. Environment Variables Reference

### Backend (`cams-chatbot/backend/.env`)
| Variable | Type | Default | Description |
|---|---|---|---|
| `PROJECT_NAME` | String | `CAMS AI Chatbot` | Display name of the application. |
| `APP_ENV` | String | `production` | Deployment mode (`production` or `development`). |
| `DEBUG` | Boolean | `false` | Disable Swagger debug endpoints and verbose tracing in production. |
| `API_V1_STR` | String | `/api/v1` | API version routing prefix. |
| `DATABASE_URL` | String | *Required* | Connection string for PostgreSQL read-only user (`postgresql://cams_readonly:<password>@<db-host>:5432/cams_db`). |
| `DB_STATEMENT_TIMEOUT_MS` | Integer | `3000` | Query timeout in milliseconds (prevents runaway database queries). |
| `DB_MAX_ROWS_LIMIT` | Integer | `500` | Maximum rows returned per query to protect server memory. |
| `SECRET_KEY` | String | *Required* | Cryptographically random string for HS256 JWT signature verification. |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Integer | `1440` | JWT token lifetime (24 hours). |
| `NVIDIA_API_KEY` | String | *Required* | API key for NVIDIA NIM LLM inference (`nvapi-...`). |
| `NVIDIA_NIM_BASE_URL` | String | `https://integrate.api.nvidia.com/v1` | NVIDIA NIM endpoint. |
| `NVIDIA_MODEL` | String | `meta/llama-3.1-70b-instruct` | LLM model identifier. |
| `NVIDIA_NIM_TIMEOUT_SEC`| Float | `15.0` | Maximum latency before triggering deterministic fallback planner. |
| `E2B_API_KEY` | String | *Required* | API key for isolated Python code execution & charts. |
| `CORS_ORIGINS` | String | *Required* | Comma-separated list of allowed frontend origins (e.g. `https://cams.college.edu`). |

### Frontend (`cams-chatbot/frontend/.env`)
| Variable | Type | Default | Description |
|---|---|---|---|
| `VITE_API_BASE_URL` | String | `/api/v1` | Base URL for API requests. If served behind an Nginx reverse proxy, leave as `/api/v1`. |

---

## C. Database Setup

The existing CAMS schema and data must remain unchanged. No destructive migrations are needed.

### 1. Provision Read-Only Database User
Connect to your PostgreSQL cluster as `postgres` admin and execute:
```sql
-- 1. Create dedicated read-only role
CREATE ROLE cams_readonly WITH LOGIN PASSWORD 'your_strong_readonly_password';

-- 2. Grant connectivity and schema usage
GRANT CONNECT ON DATABASE cams_db TO cams_readonly;
GRANT USAGE ON SCHEMA public TO cams_readonly;

-- 3. Grant SELECT on all existing and future tables
GRANT SELECT ON ALL TABLES IN SCHEMA public TO cams_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO cams_readonly;

-- 4. Grant read/write permissions strictly to chat session persistence tables
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_sessions TO cams_readonly;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE chat_messages TO cams_readonly;

-- 5. Enforce statement timeout and transaction read-only defaults
ALTER ROLE cams_readonly SET statement_timeout = '3000';
ALTER ROLE cams_readonly SET default_transaction_read_only = 'on';
```

---

## D. Backend Deployment

### Entry Point
- **Module**: `app.main:app` (FastAPI instance)
- **Directory**: `cams-chatbot/backend`

### Production Start Command
Using Uvicorn with multiple workers:
```bash
uvicorn app.main:app --host 0.0.0.0 --port 8000 --workers 4 --no-access-log
```

Or using Gunicorn process manager:
```bash
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker -b 0.0.0.0:8000
```

### Dockerfile (Optional Reference)
```dockerfile
FROM python:3.10-slim

WORKDIR /app

RUN apt-get update && apt-get install -y libpq-dev gcc && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ ./app/

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4"]
```

---

## E. Frontend Deployment

### Build Command
```bash
cd cams-chatbot/frontend
npm install
npm run build
```
- **Output Directory**: `cams-chatbot/frontend/dist`

### Serving with Nginx (Recommended Reverse Proxy)
```nginx
server {
    listen 80;
    server_name cams.college.edu;
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name cams.college.edu;

    ssl_certificate /etc/letsencrypt/live/cams.college.edu/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/cams.college.edu/privkey.pem;

    root /var/www/cams-chatbot/dist;
    index index.html;

    # Static assets caching
    location /assets/ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }

    # SPA routing
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Backend API proxy
    location /api/v1/ {
        proxy_pass http://127.0.0.1:8000/api/v1/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Health check proxy
    location /health {
        proxy_pass http://127.0.0.1:8000/health;
        proxy_set_header Host $host;
    }
}
```

---

## F. CORS Configuration

In production, set `CORS_ORIGINS` in `backend/.env` to the exact protocol and domain of the frontend:
```env
CORS_ORIGINS="https://cams.college.edu,https://admin.cams.college.edu"
```
Do **not** set `CORS_ORIGINS="*"` in production.

---

## G. NVIDIA NIM Configuration
1. Obtain an API key from NVIDIA Developer Portal.
2. Configure `NVIDIA_API_KEY="nvapi-..."` in `backend/.env`.
3. Set `NVIDIA_MODEL="meta/llama-3.1-70b-instruct"`.
4. The key is securely restricted to the backend service and never returned via client APIs.

---

## H. E2B Configuration
1. Obtain an API key from [E2B](https://e2b.dev).
2. Configure `E2B_API_KEY="e2b_..."` in `backend/.env`.
3. E2B executes code in an isolated container without network or database access to PostgreSQL.

---

## I. Health Checks

1. **Application Health**:
   ```bash
   curl -i https://cams.college.edu/health
   ```
   *Expected Response* (`200 OK`):
   ```json
   {
     "status": "healthy",
     "environment": "production",
     "version": "1.0.0-phase2",
     "database_connected": true,
     "database_tables_count": 122,
     "database_error": null
   }
   ```

2. **Dedicated Database Health**:
   ```bash
   curl -i https://cams.college.edu/api/v1/health/database
   ```
   *Expected Response* (`200 OK`):
   ```json
   {
     "status": "healthy",
     "database_type": "PostgreSQL",
     "connected": true,
     "tables_detected": 122,
     "read_only_mode": true,
     "statement_timeout_ms": 3000,
     "latency_ms": 1.45,
     "error": null
   }
   ```

---

## J. Post-Deployment Testing Matrix

1. **Authentication**: Switch between Admin, Faculty, and Student roles using the UI switcher.
2. **Text Query**: Inquire *"Show student details for student1"* $\to$ Verify structured profile appears.
3. **Table Query**: Inquire *"List courses for semester 1"* $\to$ Verify 8 courses render in markdown table.
4. **Calculation**: Inquire *"What is the average internal marks for student1?"* $\to$ Verify computed average card (`93.0`).
5. **Chart**: Inquire *"Show marks as a bar chart for student1"* $\to$ Verify SVG bar chart renders with hover tooltips.
6. **RBAC Isolation**: Log in as student1 and inquire about student2's fees $\to$ Verify `403 Forbidden` / Access Denied response.
7. **SQL Injection Defense**: Send `'; DROP TABLE students; --` $\to$ Verify safe rejection.

---

## K. Troubleshooting

| Issue | Possible Cause | Resolution |
|---|---|---|
| `database_connected: false` | Database host unreachable or invalid credentials | Check `DATABASE_URL` in `backend/.env` and verify firewall rules for PostgreSQL port. |
| `502 Bad Gateway` on API routes | Backend service is down | Check backend logs: `journalctl -u cams-backend` or `docker logs <container_id>`. |
| `CORS error` in browser console | Origin not in `CORS_ORIGINS` | Add frontend domain to `CORS_ORIGINS` in `backend/.env` and restart backend. |
| LLM responses slow / timeout | NIM API latency spike | System will automatically failover to regex planner after `NVIDIA_NIM_TIMEOUT_SEC` (15s). |
| Charts show empty data | Empty historical tables in DB | Expected behavior for tables with 0 rows in backup; zero hallucination enforced. |
