# 🪵 TimberPunk - Vodič za Pokretanje

## 📖 Pregled

Postoje **3 načina** da pokrenete TimberPunk aplikaciju:

| Način | Namena | Skripta | Port Backend | Port Frontend |
|-------|--------|---------|--------------|---------------|
| **1. Local Dev** | Razvoj i testiranje | `./setup-local.sh` | 8000 | 5173 |
| **2. Production** | Produkciono okruženje | `./setup-production.sh` | 8000 | 4173 |
| **3. Manual** | Ručno pokretanje | (vidi dole) | 8000 | 5173/4173 |

---

## 🚀 1. Lokalno Razvojno Okruženje (PREPORUČENO ZA DEV)

### Karakteristike
- ✅ **Hot Reload** - Automatsko osvežavanje kod izmena
- ✅ **SQLite baza** - Jednostavno, bez PostgreSQL-a
- ✅ **Test podaci** - 3 proizvoda automatski dodata
- ✅ **Dev server** - Brz start, optimizovan za razvoj
- ⚠️ **NE za produkciju** - Nema optimizacija

### Pokretanje
```bash
./setup-local.sh
```

### URL-ovi
- Frontend: http://localhost:5173
- Backend: http://localhost:8000
- Admin: http://localhost:5173/admin
- API Docs: http://localhost:8000/docs

### Kredit
- Email: `admin@timberpunk.com`
- Password: `admin123`

### Više informacija
📄 [README-LOCAL.md](./README-LOCAL.md)

---

## 🏭 2. Produkciono Okruženje

### Karakteristike
- ✅ **Gunicorn** - Production WSGI server (4 workers)
- ✅ **PostgreSQL** - Prava baza podataka
- ✅ **Optimizovan build** - Minifikovan, tree-shaken kod
- ✅ **Auto-generisan SECRET_KEY** - Bezbednost
- ⚠️ **Zahteva konfiguraciju** - Morate urediti .env.production

### Pokretanje
```bash
./setup-production.sh
```

### Pre Pokretanja - VAŽNO!
Skripta će kreirati `.env.production` fajlove. **Morate ih urediti**:

**Backend `.env.production`:**
```bash
DATABASE_URL=postgresql://timberpunk_user:VASA_LOZINKA@localhost:5432/timberpunk
ADMIN_PASSWORD=SIGURNA_LOZINKA  # ⚠️ OBAVEZNO PROMENITE!
FRONTEND_URL=https://vašdomen.com
```

**Frontend `.env.production`:**
```bash
VITE_API_URL=https://api.vašdomen.com  # Ili http://localhost:8000 za test
```

### URL-ovi
- Frontend: http://localhost:4173
- Backend: http://localhost:8000
- Admin: http://localhost:4173/admin
- API Docs: http://localhost:8000/docs

### Više informacija
📄 [README-PRODUCTION.md](./README-PRODUCTION.md)

---

## 🔧 3. Ručno Pokretanje

### Backend (Development)
```bash
cd tp_backend

# Kreiraj venv (prvi put)
python3 -m venv venv

# Aktiviraj venv
source venv/bin/activate

# Instaliraj pakete (prvi put)
pip install -r requirements.txt

# Pokreni server
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Backend (Production)
```bash
cd tp_backend
source venv/bin/activate

# Učitaj production env
export $(cat .env.production | grep -v '^#' | xargs)

# Pokreni sa Gunicorn
gunicorn main:app \
    --workers 4 \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:8000
```

### Frontend (Development)
```bash
cd tp_ui

# Instaliraj pakete (prvi put)
npm install

# Pokreni dev server
npm run dev
```

### Frontend (Production)
```bash
cd tp_ui

# Build
npm run build

# Preview (serve build)
npm run preview -- --port 4173 --host 0.0.0.0
```

---

## 📊 Detaljno Poređenje

### Serveri

| Aspekt | Local Dev | Production |
|--------|-----------|------------|
| Backend Server | Uvicorn (1 worker, --reload) | Gunicorn (4 workers) |
| Frontend Server | Vite Dev Server | Vite Preview (static) |
| Hot Reload | ✅ Da | ❌ Ne |
| Auto-restart na greške | ✅ Da | ✅ Da (Gunicorn) |
| Performance | 🐌 Srednje | ⚡ Brzo |

### Baza Podataka

| Aspekt | Local Dev | Production |
|--------|-----------|------------|
| Tip | SQLite | PostgreSQL (preporučeno) |
| Lokacija | `timberpunk.db` | `timberpunk_production.db` ili PostgreSQL |
| Test podaci | ✅ Auto-dodato | ❌ Samo admin |
| Backup | Kopiraj .db fajl | pg_dump ili kopiraj .db |

### Bezbednost

| Aspekt | Local Dev | Production |
|--------|-----------|------------|
| SECRET_KEY | Hard-coded dev key | ✅ Auto-generisan (openssl) |
| Admin Password | `admin123` | ⚠️ Morate promeniti! |
| CORS | localhost:5173 | Vaš domen |
| HTTPS | ❌ Ne | ⚠️ Konfigurisati (Nginx + Let's Encrypt) |

### Environment Files

| File | Local Dev | Production |
|------|-----------|------------|
| Backend | `.env` | `.env.production` |
| Frontend | `.env` | `.env.production` |
| Auto-kreiranje | ✅ Da | ✅ Da (sa promptima) |
| Potrebno editovanje | ❌ Ne | ✅ DA - OBAVEZNO! |

---

## 🎯 Koji Način Izabrati?

### Koristite **Local Dev** (`setup-local.sh`) ako:
- ✅ Razvijate aplikaciju
- ✅ Testirate nove feature-e
- ✅ Debugging-ujete
- ✅ Ne želite da podešavate PostgreSQL
- ✅ Želite brzo pokretanje bez konfiguracije

### Koristite **Production** (`setup-production.sh`) ako:
- ✅ Deploy-ujete na server
- ✅ Testiranje production performance-a
- ✅ Potrebna vam je PostgreSQL baza
- ✅ Želite optimizovan build
- ✅ Spremni ste da konfigurišete .env.production

### Koristite **Manual** pokretanje ako:
- ✅ Želite potpunu kontrolu
- ✅ Debug-ujete specifične probleme
- ✅ Podešavate custom konfiguracije
- ✅ Učite kako sistem radi

---

## 🛠️ Brzi Start

### Prvi put ikad (Development)
```bash
# 1. Klonirajte repo (ako nije već)
git clone <repo-url>
cd timber_punk

# 2. Pokrenite local setup
./setup-local.sh

# 3. Otvorite browser
# Frontend: http://localhost:5173
# Admin: http://localhost:5173/admin (admin@timberpunk.com / admin123)
```

### Svaki sledeći put (Development)
```bash
# Ako već imate sve setup-ovano, jednostavno:
./setup-local.sh

# Ili ručno:
cd tp_backend && source venv/bin/activate && uvicorn main:app --reload &
cd tp_ui && npm run dev
```

### Production Deployment (Prvi put)
```bash
# 1. Pokrenite setup
./setup-production.sh

# 2. Uredite .env.production fajlove kada skripta traži
#    - Postavite DATABASE_URL (PostgreSQL credentials)
#    - Postavite ADMIN_PASSWORD (sigurna lozinka)
#    - Postavite FRONTEND_URL (vaš domen)

# 3. Nastavite sa enter
#    Skripta će build-ovati sve i pokrenuti servise
```

---

## 📂 Struktura Fajlova

```
timber_punk/
├── setup-local.sh              # 🚀 Lokalni dev setup (SVE automatski)
├── setup-production.sh         # 🏭 Production setup (SVE automatski)
├── README-LOCAL.md             # 📖 Detaljan vodič za local dev
├── README-PRODUCTION.md        # 📖 Detaljan vodič za production
├── README-SETUP.md             # 📖 Ovaj fajl - pregled svega
│
├── tp_backend/
│   ├── .env                    # Lokalno razvojno okruženje
│   ├── .env.production         # Production okruženje
│   ├── main.py                 # FastAPI app
│   ├── requirements.txt        # Python zavisnosti
│   ├── gunicorn.conf.py        # Gunicorn config
│   └── ...
│
└── tp_ui/
    ├── .env                    # Lokalno razvojno okruženje
    ├── .env.production         # Production okruženje
    ├── package.json            # npm config
    ├── vite.config.ts          # Vite config
    └── src/
        └── ...
```

---

## ❓ Najčešća Pitanja

### Q: Koja je razlika između portova 5173 i 4173?
**A:** 
- `5173` = Vite Dev Server (hot reload, development)
- `4173` = Vite Preview (optimizovan build, production test)

### Q: Moram li koristiti PostgreSQL?
**A:**
- **Development:** Ne, SQLite je dovoljno
- **Production:** Preporučeno da, ali SQLite radi za manje sajtove

### Q: Kako resetujem sve?
**A:**
```bash
# Obrišite sve generisane fajlove
rm -rf tp_backend/venv tp_backend/*.db tp_backend/.env*
rm -rf tp_ui/node_modules tp_ui/dist tp_ui/.env*

# Pokrenite setup ponovo
./setup-local.sh  # ili ./setup-production.sh
```

### Q: Mogu li pokrenuti production lokalno za testiranje?
**A:** Da! `setup-production.sh` radi i lokalno. Samo u `.env.production` postavite:
```
DATABASE_URL=sqlite:///./timberpunk_production.db
FRONTEND_URL=http://localhost:4173
VITE_API_URL=http://localhost:8000
```

### Q: Kako zaustavim servise?
**A:**
- **Ctrl+C** u terminalu gde je pokrenuta skripta
- Ili: `pkill -f gunicorn && pkill -f vite`

---

## 🆘 Pomoć

### Logovi
```bash
# Local dev
# Backend: direktno u terminalu
# Frontend: direktno u terminalu

# Production
tail -f /tmp/timberpunk_backend_access.log  # HTTP zahtevi
tail -f /tmp/timberpunk_backend_error.log   # Backend greške
tail -f /tmp/timberpunk_frontend.log        # Frontend
```

### Debug Problemi
1. **Proveri logove** (gore ⬆️)
2. **Proveri da li portovi rade:** `lsof -i :8000` i `lsof -i :5173`
3. **Resetuj okruženje** (vidi Q&A)
4. **Pogledaj detaljne README-ove** za specific issue-e

---

## 📚 Dodatni Resursi

- 📄 [README-LOCAL.md](./README-LOCAL.md) - Sve o development setup-u
- 📄 [README-PRODUCTION.md](./README-PRODUCTION.md) - Sve o production deployment-u
- 🌐 API Dokumentacija: http://localhost:8000/docs
- 🔧 Gunicorn Docs: https://docs.gunicorn.org/
- ⚡ Vite Docs: https://vitejs.dev/

---

**Srećno! 🚀 Ako nešto nije jasno, pogledajte detaljne README fajlove ili proverite logove.**
