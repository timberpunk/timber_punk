# 🪵 TimberPunk - Quick Start Guide

Jednostavne skripte za pokretanje backend-a i frontend-a bez Docker-a i Nginx-a.

---

## 📦 Prvo Pokretanje

### 1. Kloniraj repo
```bash
git clone https://github.com/timberpunk/timber_punk.git
cd timber_punk
```

### 2. Podesi Backend
```bash
cd tp_backend

# Kopiraj i ažuriraj .env fajl
cp .env .env.backup
nano .env  # Izmeni DATABASE_URL i druge settings
```

---

## 🚀 Pokretanje

### Opcija 1: Pokreni SVE odjednom
```bash
cd /path/to/timber_punk
chmod +x start-all.sh
./start-all.sh
```

### Opcija 2: Backend i Frontend odvojeno

**Backend:**
```bash
cd tp_backend
chmod +x start-prod.sh
./start-prod.sh
```
Izberi:
- `1` za **Production mode** (Gunicorn - za VPS)
- `2` za **Development mode** (Uvicorn - sa auto-reload)

**Frontend:**
```bash
cd tp_ui
chmod +x start-prod.sh
./start-prod.sh
```
Izberi:
- `1` za **Build** (kreira `dist/` folder)
- `2` za **Preview** (pokreće built verziju)
- `3` za **Development** (sa hot-reload)

---

## 🌐 URL-ovi

Kada sve radi:
- **Backend API**: http://localhost:8000
- **API Dokumentacija**: http://localhost:8000/docs
- **Frontend**: http://localhost:5173

---

## 📝 Produkcija (VPS)

### 1. Kopiraj kod na server
```bash
# Sa lokalnog računara:
scp -r timber_punk user@your-vps-ip:/var/www/
```

### 2. Na serveru, instaliraj dependencies
```bash
# Python
sudo apt install python3 python3-venv python3-pip

# Node.js
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# PostgreSQL (opciono)
sudo apt install postgresql
```

### 3. Pokreni Backend
```bash
cd /var/www/timber_punk/tp_backend
chmod +x start-prod.sh
./start-prod.sh
# Izaberi opciju 1 (Production)
```

### 4. Build Frontend
```bash
cd /var/www/timber_punk/tp_ui
chmod +x start-prod.sh
./start-prod.sh
# Izaberi opciju 1 (Build)

# Upload dist/ folder na hosting ili serve lokalno:
npx serve -s dist -p 5173
```

---

## 🔄 Update Koda

```bash
cd /var/www/timber_punk
git pull

# Restartuj backend
cd tp_backend
./start-prod.sh

# Rebuild frontend
cd ../tp_ui
./start-prod.sh  # Opcija 1
```

---

## 🛑 Zaustavljanje

Pritisni **Ctrl+C** u terminalu gde radi skripta.

---

## 💡 Saveti

### Backend u pozadini (background)
```bash
cd tp_backend
nohup ./start-prod.sh > backend.log 2>&1 &

# Proveri da radi
tail -f backend.log

# Zaustavi
pkill -f gunicorn
```

### Frontend build za hosting
```bash
cd tp_ui
./start-prod.sh  # Opcija 1

# Upload dist/ folder na:
# - Netlify
# - Vercel  
# - Bilo koji static hosting
```

### Database backup
```bash
# PostgreSQL
pg_dump timberpunk > backup.sql

# Restore
psql timberpunk < backup.sql
```

---

## 🆘 Problem Solving

### Backend ne starta
```bash
cd tp_backend
source venv/bin/activate
python main.py  # Vidi error direktno
```

### Frontend build fails
```bash
cd tp_ui
rm -rf node_modules package-lock.json
npm install
npm run build
```

### Port zauzet
```bash
# Proveri šta koristi port 8000
lsof -i :8000

# Ubij proces
kill -9 <PID>
```

---

Srećno! 🚀
