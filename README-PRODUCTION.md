# 🪵 TimberPunk - Produkciono Okruženje

## 🚀 Brzo Pokretanje Production Build-a

```bash
./setup-production.sh
```

Ova skripta će automatski:
- ✅ Proveriti da li su Python3, Node.js i PostgreSQL instalirani
- ✅ Kreirati `.env.production` sa **auto-generisanim SECRET_KEY**
- ✅ Napraviti Python virtualno okruženje
- ✅ Instalirati sve production pakete (uključujući Gunicorn)
- ✅ Kreirati/migrirati PostgreSQL ili SQLite bazu
- ✅ Build-ovati frontend sa optimizacijama
- ✅ Pokrenuti backend sa **Gunicorn (4 workers)**
- ✅ Pokrenuti frontend sa **Vite Preview**

## 📋 Pre Prvog Pokretanja

### 1. Obavezno Instalirano

```bash
# Python 3.12+
brew install python@3.12

# Node.js 16+
brew install node
```

### 2. Opciono (ali preporučeno za produkciju)

```bash
# PostgreSQL 15
brew install postgresql@15
brew services start postgresql@15

# Kreiraj bazu
createdb timberpunk

# Kreiraj korisnika
psql -c "CREATE USER timberpunk_user WITH PASSWORD 'your_secure_password';"
psql -c "GRANT ALL PRIVILEGES ON DATABASE timberpunk TO timberpunk_user;"
```

## ⚙️ Konfiguracija Pre Pokretanja

### Backend `.env.production`

Skripta će kreirati ovaj fajl sa auto-generisanim `SECRET_KEY`, ali **morate urediti**:

```bash
# OBAVEZNO PROMENITE:
DATABASE_URL=postgresql://timberpunk_user:VASA_LOZINKA@localhost:5432/timberpunk
ADMIN_PASSWORD=SIGURNA_ADMIN_LOZINKA
FRONTEND_URL=https://vašdomen.com  # ili http://localhost:4173 za test
```

### Frontend `.env.production`

Skripta će pitati za API URL:
```bash
# Produkcija:
VITE_API_URL=https://api.timberpunk.com

# Lokalno testiranje:
VITE_API_URL=http://localhost:8000
```

## 🎯 Posle Pokretanja

### 🌐 Frontend
- **URL:** http://localhost:4173
- **Mod:** Vite Preview (optimizovan production build)
- **Lokacija:** `tp_ui/dist/` (static files)

### 🔧 Backend API
- **URL:** http://localhost:8000
- **Server:** Gunicorn sa 4 workers
- **Worker Class:** uvicorn.workers.UvicornWorker
- **Dokumentacija:** http://localhost:8000/docs

### 🔐 Admin Panel
- **URL:** http://localhost:4173/admin
- **Email:** admin@timberpunk.com (konfigurisano u .env.production)
- **Password:** Ono što ste postavili u .env.production

### 🗄️ Baza Podataka
- **PostgreSQL:** Konfigurisano u DATABASE_URL
- **SQLite Fallback:** `timberpunk_production.db` ako PostgreSQL nije dostupan

## 📊 Production vs Development

| Feature | Development | Production |
|---------|-------------|------------|
| Backend Server | Uvicorn (--reload) | Gunicorn (4 workers) |
| Frontend | Vite Dev Server | Vite Build + Preview |
| Database | SQLite | PostgreSQL (preporučeno) |
| Port Backend | 8000 | 8000 |
| Port Frontend | 5173 | 4173 |
| Hot Reload | ✅ Aktivno | ❌ Neaktivno |
| Optimizacija | ❌ Ne | ✅ Da (minify, tree-shake) |
| Source Maps | ✅ Da | ❌ Ne |

## 🔍 Monitoring i Logovi

### Backend Logovi
```bash
# Access log (svi HTTP zahtevi)
tail -f /tmp/timberpunk_backend_access.log

# Error log (greške i upozorenja)
tail -f /tmp/timberpunk_backend_error.log
```

### Frontend Logovi
```bash
tail -f /tmp/timberpunk_frontend.log
```

### Live Monitoring
```bash
# Proveri da li servisi rade
ps aux | grep gunicorn
ps aux | grep vite

# Proveri portove
lsof -i :8000  # Backend
lsof -i :4173  # Frontend
```

## 🛑 Zaustavljanje Servisa

### Automatski (Ctrl+C)
Pritisnite **Ctrl+C** u terminalu gde je pokrenuta skripta.

### Ručno
```bash
# Nađi PID-ove
ps aux | grep gunicorn
ps aux | grep vite

# Zaustavi servise
kill <BACKEND_PID> <FRONTEND_PID>

# Ili force kill
pkill -f "gunicorn main:app"
pkill -f "vite preview"
```

## 💾 Backup Baze Podataka

### SQLite
```bash
cp tp_backend/timberpunk_production.db backup_$(date +%Y%m%d_%H%M%S).db
```

### PostgreSQL
```bash
# Full backup
pg_dump timberpunk > backup_$(date +%Y%m%d_%H%M%S).sql

# Compressed backup
pg_dump timberpunk | gzip > backup_$(date +%Y%m%d_%H%M%S).sql.gz

# Restore
psql timberpunk < backup_20241210.sql
```

## 🔄 Update i Redeploy

```bash
# 1. Pull latest changes
git pull origin main

# 2. Stop services
pkill -f "gunicorn main:app"
pkill -f "vite preview"

# 3. Run setup again
./setup-production.sh
```

## 🌍 Deployment na VPS

### Nginx kao Reverse Proxy (Opciono)

```nginx
# /etc/nginx/sites-available/timberpunk

# Backend API
server {
    listen 80;
    server_name api.timberpunk.com;

    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Frontend
server {
    listen 80;
    server_name timberpunk.com www.timberpunk.com;

    location / {
        proxy_pass http://localhost:4173;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Aktiviraj:
```bash
sudo ln -s /etc/nginx/sites-available/timberpunk /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

### SSL Certifikati (Let's Encrypt)

```bash
sudo apt install certbot python3-certbot-nginx
sudo certbot --nginx -d timberpunk.com -d www.timberpunk.com -d api.timberpunk.com
```

### Systemd Service (za auto-restart)

**Backend service:**
```bash
sudo nano /etc/systemd/system/timberpunk-backend.service
```

```ini
[Unit]
Description=TimberPunk Backend (Gunicorn)
After=network.target postgresql.service

[Service]
Type=simple
User=mirosljevic
WorkingDirectory=/Users/mirosljevic/timber_punk/tp_backend
Environment="PATH=/Users/mirosljevic/timber_punk/tp_backend/venv/bin"
EnvironmentFile=/Users/mirosljevic/timber_punk/tp_backend/.env.production
ExecStart=/Users/mirosljevic/timber_punk/tp_backend/venv/bin/gunicorn main:app \
    --workers 4 \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:8000
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

Aktiviraj:
```bash
sudo systemctl daemon-reload
sudo systemctl enable timberpunk-backend
sudo systemctl start timberpunk-backend
sudo systemctl status timberpunk-backend
```

## ❓ Najčešći Problemi

### "PostgreSQL connection refused"
```bash
# Proveri da li PostgreSQL radi
brew services list | grep postgresql

# Pokreni PostgreSQL
brew services start postgresql@15

# Ili koristi SQLite za testiranje
# U .env.production zameni DATABASE_URL sa:
DATABASE_URL=sqlite:///./timberpunk_production.db
```

### "Port 8000 already in use"
```bash
# Nađi proces
lsof -ti:8000

# Zaustavi ga
kill -9 $(lsof -ti:8000)
```

### "npm ERR! missing script: build"
```bash
cd tp_ui
npm install
npm run build
```

### "Permission denied: .env.production"
```bash
chmod 600 tp_backend/.env.production
chmod 600 tp_ui/.env.production
```

## 🔒 Bezbednost - Production Checklist

- [ ] Promenjen `ADMIN_PASSWORD` u .env.production
- [ ] Promenjen `SECRET_KEY` (auto-generisan, ali proveri)
- [ ] PostgreSQL umesto SQLite za produkciju
- [ ] `DATABASE_URL` koristi jake lozinke
- [ ] `FRONTEND_URL` postavljen na pravi domen
- [ ] `.env.production` fajlovi imaju chmod 600
- [ ] `.env.production` dodati u .gitignore
- [ ] SSL certifikati konfigurisani (HTTPS)
- [ ] Firewall podešen (samo portovi 80, 443, 22)
- [ ] Redovni backups konfigurisani
- [ ] Monitoring/alerting postavljen

## 📈 Performance Optimizacije

### Backend (Gunicorn)
- **Workers:** `(2 × CPU cores) + 1` (trenutno 4)
- **Worker Class:** uvicorn.workers.UvicornWorker (async)
- **Timeout:** 30s (default)

Za podešavanje:
```bash
# U setup-production.sh izmeni gunicorn komandu:
gunicorn main:app --workers 8 --timeout 60
```

### Frontend (Vite)
- **Code Splitting:** Automatski
- **Tree Shaking:** Automatski
- **Minification:** Automatski
- **Gzip:** Nginx (ako koristite)

### Database
```bash
# PostgreSQL - connection pooling
# U .env.production:
DATABASE_URL=postgresql://user:pass@localhost:5432/timberpunk?pool_size=20&max_overflow=0
```

## 📞 Dodatna Pomoć

Za detaljnije informacije:
- Backend API: http://localhost:8000/docs
- Logs: `/tmp/timberpunk_*.log`
- Config: `.env.production` fajlovi

---

**Srećan deployment! 🚀**
