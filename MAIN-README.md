# 🪵 TimberPunk - Kompletna E-Commerce Platforma

> Full-stack e-commerce aplikacija za TimberPunk drvenu radionicu
> Dvojezična podrška (Srpski/Engleski) sa modernim dizajnom

![Tech Stack](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

## 📖 Pregled

TimberPunk je kompletna e-commerce platforma kreirana za prodaju ručno rađenih drvenih proizvoda. Sadrži:

- ✅ **Frontend** - React + TypeScript + Vite
- ✅ **Backend** - FastAPI + SQLAlchemy
- ✅ **Dvojezično** - Srpski (default) i Engleski
- ✅ **Admin Panel** - Upravljanje proizvodima i porudžbinama
- ✅ **SQLite/PostgreSQL** - Fleksibilna baza podataka

## 🚀 Brzo Pokretanje

### Development (Lokalno)
```bash
./setup-local.sh
```
Otvori: http://localhost:5173

### Production
```bash
./setup-production.sh
```
Otvori: http://localhost:4173

## 📚 Dokumentacija

- 📄 **[README-SETUP.md](./README-SETUP.md)** - Kompletni vodič za pokretanje
- 📄 **[README-LOCAL.md](./README-LOCAL.md)** - Development setup
- 📄 **[README-PRODUCTION.md](./README-PRODUCTION.md)** - Production deployment

## 🏗️ Struktura Projekta

```
timber_punk/
├── setup-local.sh           # 🚀 Development setup skripta
├── setup-production.sh      # 🏭 Production setup skripta
├── README.md                # Ovaj fajl
├── README-SETUP.md          # Detaljno poređenje setup opcija
├── README-LOCAL.md          # Local development vodič
├── README-PRODUCTION.md     # Production deployment vodič
│
├── tp_backend/              # 🔧 Backend (FastAPI)
│   ├── main.py              # FastAPI aplikacija
│   ├── models.py            # SQLAlchemy modeli
│   ├── database.py          # Database konfiguracija
│   ├── auth.py              # JWT autentikacija
│   ├── config.py            # Environment config
│   ├── requirements.txt     # Python zavisnosti
│   ├── gunicorn.conf.py     # Gunicorn config
│   └── routers/
│       ├── products.py      # Product endpoints
│       ├── orders.py        # Order endpoints
│       └── auth_routes.py   # Auth endpoints
│
└── tp_ui/                   # 🎨 Frontend (React + TypeScript)
    ├── src/
    │   ├── components/      # React komponente
    │   ├── pages/           # Stranice
    │   ├── api/             # API client
    │   ├── context/         # React Context
    │   └── i18n/            # Internacionalizacija
    ├── package.json
    └── vite.config.ts
```

## 🌟 Karakteristike

### Frontend
- ⚛️ React 18 sa TypeScript
- ⚡ Vite za brz development
- 🎨 Moderan, clean dizajn
- 🌍 i18next za dvojezičnost (SR/EN)
- 🛒 Shopping cart sa Context API
- 📱 Responsive layout

### Backend
- 🚀 FastAPI za brze API-je
- 🗄️ SQLAlchemy ORM
- 🔐 JWT autentikacija
- 📊 Auto-generisana API dokumentacija
- 💾 SQLite ili PostgreSQL

### Admin Panel
- ✏️ CRUD operacije za proizvode
- 📦 Pregled i upravljanje porudžbinama
- 🔒 Zaštićen pristup

## 🎯 Funkcionalnosti

### Za Kupce
- 🔍 Pretraga i filtriranje proizvoda po kategoriji
- 🖼️ Galerija proizvoda sa slikama
- 🛒 Dodavanje proizvoda u korpu
- ✍️ Personalizacija (graviranje)
- 💳 Checkout proces
- 🌍 Promena jezika (SR/EN)

### Za Admina
- ➕ Dodavanje novih proizvoda
- ✏️ Izmena postojećih proizvoda
- 🗑️ Brisanje proizvoda
- 📊 Pregled svih porudžbina
- 📝 Ažuriranje statusa porudžbine

## 💻 Tehnologije

### Backend
- Python 3.12+
- FastAPI 0.104.1
- SQLAlchemy 2.0.23
- Pydantic v2
- Gunicorn 21.2.0
- bcrypt 4.0.1
- python-jose (JWT)

### Frontend
- React 18
- TypeScript
- Vite
- React Router v6
- Axios
- i18next
- React Context API

### Database
- SQLite (development)
- PostgreSQL (production - opciono)

## 🔐 Default Kredencijali (Development)

- **Admin Email:** admin@timberpunk.com
- **Admin Password:** admin123

⚠️ **VAŽNO:** Promenite ovo u produkciji!

## 🌍 Jezici

Aplikacija podržava:
- 🇷🇸 **Srpski** (podrazumevani jezik)
- 🇬🇧 **Engleski**

Promena jezika: Kliknite na **SR** ili **EN** dugme u headeru.

## 📦 Instalacija - Korak po Korak

### 1. Klonirajte Repo
```bash
git clone https://github.com/timberpunk/timber_punk.git
cd timber_punk
```

### 2. Development Setup
```bash
# Automatski:
./setup-local.sh

# Ili ručno:
# Backend
cd tp_backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --reload

# Frontend (novi terminal)
cd tp_ui
npm install
npm run dev
```

### 3. Otvorite Browser
- Frontend: http://localhost:5173
- Backend API Docs: http://localhost:8000/docs
- Admin Panel: http://localhost:5173/admin

## 🚀 Production Deployment

```bash
./setup-production.sh
```

Skripta će vas pitati za:
1. **Tip baze** (SQLite ili PostgreSQL)
2. **Admin kredencijale**
3. **Frontend/Backend URL-ove**

Detalji: [README-PRODUCTION.md](./README-PRODUCTION.md)

## 🔧 Environment Variables

### Backend (.env)
```bash
DATABASE_URL=sqlite:///./timberpunk.db
SECRET_KEY=your-secret-key
ADMIN_EMAIL=admin@timberpunk.com
ADMIN_PASSWORD=admin123
FRONTEND_URL=http://localhost:5173
```

### Frontend (.env)
```bash
VITE_API_URL=http://localhost:8000
```

## 📊 API Endpoints

### Public
- `GET /api/products` - Lista proizvoda
- `GET /api/products/{id}` - Detalji proizvoda
- `POST /api/orders` - Kreiranje porudžbine

### Admin (zahteva autentikaciju)
- `POST /api/auth/login` - Admin login
- `POST /api/products` - Dodavanje proizvoda
- `PUT /api/products/{id}` - Izmena proizvoda
- `DELETE /api/products/{id}` - Brisanje proizvoda
- `GET /api/orders` - Lista porudžbina
- `PUT /api/orders/{id}` - Ažuriranje statusa

Kompletna dokumentacija: http://localhost:8000/docs

## 🧪 Testiranje

### Backend
```bash
cd tp_backend
source venv/bin/activate
pytest
```

### Frontend
```bash
cd tp_ui
npm test
```

## 📝 Dodavanje Novih Proizvoda

### Preko Admin Panela
1. Idite na http://localhost:5173/admin
2. Ulogujte se (admin@timberpunk.com / admin123)
3. Kliknite "Dodaj Novi Proizvod"
4. Popunite formu i kliknite "Sačuvaj"

### Preko API-ja
```bash
curl -X POST http://localhost:8000/api/products \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Drvena Kutija",
    "description": "Ručno izrađena kutija",
    "price": 2500.00,
    "category": "Dekoracija",
    "image_url": "https://example.com/image.jpg"
  }'
```

## 🔄 Ažuriranje Projekta

```bash
# Povucite najnovije izmene
git pull origin main

# Ažurirajte zavisnosti
cd tp_backend && pip install -r requirements.txt
cd ../tp_ui && npm install

# Restartujte servise
./setup-local.sh  # ili ./setup-production.sh
```

## 💾 Backup Baze

### SQLite
```bash
cp tp_backend/timberpunk.db backup_$(date +%Y%m%d).db
```

### PostgreSQL
```bash
pg_dump timberpunk > backup_$(date +%Y%m%d).sql
```

## 🐛 Troubleshooting

### Backend ne može da se pokrene
```bash
# Proverite logove
tail -f /tmp/timberpunk_backend_error.log

# Resetujte venv
cd tp_backend
rm -rf venv
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Frontend ne može da se build-uje
```bash
# Obrišite node_modules i reinstalirajte
cd tp_ui
rm -rf node_modules
npm install
npm run build
```

### Port već zauzet
```bash
# Pronađite proces
lsof -ti:8000  # Backend
lsof -ti:5173  # Frontend

# Zaustavite ga
kill -9 $(lsof -ti:8000)
```

## 🤝 Doprinošenje

1. Fork projekat
2. Kreirajte feature branch (`git checkout -b feature/NovaFunkcija`)
3. Commit izmene (`git commit -m 'Dodaj novu funkciju'`)
4. Push na branch (`git push origin feature/NovaFunkcija`)
5. Otvorite Pull Request

## 📄 Licenca

MIT License - slobodno koristite za komercijalne i lične projekte.

## 📞 Kontakt

Za pitanja i podršku:
- Email: admin@timberpunk.com
- GitHub Issues: https://github.com/timberpunk/timber_punk/issues

## 🙏 Zahvalnice

- [FastAPI](https://fastapi.tiangolo.com/)
- [React](https://react.dev/)
- [Vite](https://vitejs.dev/)
- [i18next](https://www.i18next.com/)

---

**Srećno kodiranje! 🚀🪵**

Napravljeno sa ❤️ za TimberPunk
