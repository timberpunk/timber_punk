# 🪵 TimberPunk - Lokalno Razvojno Okruženje

## 🚀 Brzo Pokretanje (Sve Automatski)

Samo pokrenite jednu komandu:

```bash
./setup-local.sh
```

Ova skripta će automatski:
- ✅ Proveriti da li su Python3 i Node.js instalirani
- ✅ Kreirati `.env` fajlove za backend i frontend
- ✅ Napraviti Python virtualno okruženje
- ✅ Instalirati sve Python i npm pakete
- ✅ Kreirati SQLite bazu sa test podacima
- ✅ Pokrenuti backend na `http://localhost:8000`
- ✅ Pokrenuti frontend na `http://localhost:5173`

## 📋 Pre Prvog Pokretanja

Proverite da li imate instalirano:

### Python 3.12+
```bash
python3 --version
```
Ako nije instaliran:
```bash
brew install python@3.12
```

### Node.js (16+)
```bash
node --version
```
Ako nije instaliran:
```bash
brew install node
```

## 🎯 Posle Pokretanja

Kada se skripta pokrene, dobićete:

### 🌐 Frontend
- URL: **http://localhost:5173**
- Jezik: Srpski (podrazumevano)
- Prebacivanje: Dugmad SR/EN u headeru

### 🔧 Backend API
- URL: **http://localhost:8000**
- Dokumentacija: **http://localhost:8000/docs**

### 🔐 Admin Panel
- URL: **http://localhost:5173/admin**
- Email: `admin@timberpunk.com`
- Password: `admin123`

### 🗄️ Baza Podataka
- Tip: SQLite
- Lokacija: `tp_backend/timberpunk.db`
- Test podaci: 3 proizvoda automatski dodata

## 🛑 Zaustavljanje

Pritisnite **Ctrl+C** u terminalu gde je pokrenuta skripta.

## 📝 Ručno Pokretanje (ako želite odvojeno)

### Backend
```bash
cd tp_backend
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### Frontend
```bash
cd tp_ui
npm run dev
```

## 🔍 Pregled Logova

### Backend logovi
```bash
tail -f /tmp/timberpunk_backend.log
```

### Frontend logovi
```bash
tail -f /tmp/timberpunk_frontend.log
```

## 🧹 Resetovanje (Ako Nešto Krene Naopako)

### Resetuj backend
```bash
cd tp_backend
rm -rf venv
rm timberpunk.db
rm .env
```

### Resetuj frontend
```bash
cd tp_ui
rm -rf node_modules
rm .env
```

### Pokreni setup ponovo
```bash
./setup-local.sh
```

## 📦 Šta se Automatski Kreira

### Backend `.env`
```
DATABASE_URL=sqlite:///./timberpunk.db
SECRET_KEY=dev-secret-key-...
ADMIN_EMAIL=admin@timberpunk.com
ADMIN_PASSWORD=admin123
FRONTEND_URL=http://localhost:5173
```

### Frontend `.env`
```
VITE_API_URL=http://localhost:8000
```

## ❓ Najčešći Problemi

### "npm: command not found"
Instalirajte Node.js:
```bash
brew install node
```

### "python3: command not found"
Instalirajte Python:
```bash
brew install python@3.12
```

### Port 8000 ili 5173 već zauzet
Pronađite proces:
```bash
lsof -ti:8000  # Backend
lsof -ti:5173  # Frontend
```
Zaustavite ga:
```bash
kill -9 $(lsof -ti:8000)
kill -9 $(lsof -ti:5173)
```

### Backend ne može da se poveže na bazu
Obrišite staru bazu i kreirajte novu:
```bash
cd tp_backend
rm timberpunk.db
./setup-local.sh
```

## 🎨 Test Proizvodi

Skripta automatski dodaje 3 test proizvoda:
1. **Drvena Cutting Board** - 4500 RSD
2. **Drvena Kutija za Nakit** - 3200 RSD
3. **Set Drvenih Podmetača** - 1500 RSD

## 🌍 Jezici

- 🇷🇸 **Srpski** (podrazumevano)
- 🇬🇧 **Engleski**

Promenite jezik klikom na **SR** ili **EN** dugme u headeru.

## 📞 Podrška

Ako naiđete na probleme:
1. Proverite logove (`/tmp/timberpunk_*.log`)
2. Resetujte okruženje (gore ⬆️)
3. Pokrenite setup skriptu ponovo

---

**Srećno kodiranje! 🚀**
