#!/bin/bash

# TimberPunk - Produkciono Okruženje - Setup Skripta
# Automatski postavlja i pokreće backend i frontend za produkciju

set -e  # Zaustavi skriptu ako nešto ne uspe

echo "================================================"
echo "🪵 TimberPunk - Produkciono Okruženje Setup"
echo "================================================"
echo ""

# Boje za terminal output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Direktorijumi (relativne putanje od root foldera)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/tp_backend"
FRONTEND_DIR="$SCRIPT_DIR/tp_ui"

# ==============================================
# KORAK 1: Provera node i python
# ==============================================
echo -e "${BLUE}📋 Korak 1: Provera instaliranih alata...${NC}"

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 nije instaliran!${NC}"
    echo "Instalirajte Python3 sa: brew install python@3.12"
    exit 1
fi
echo -e "${GREEN}✓ Python3: $(python3 --version)${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js nije instaliran!${NC}"
    echo "Instalirajte Node.js sa: brew install node"
    exit 1
fi
echo -e "${GREEN}✓ Node.js: $(node --version)${NC}"
echo -e "${GREEN}✓ npm: $(npm --version)${NC}"

if ! command -v psql &> /dev/null; then
    echo -e "${YELLOW}⚠️  PostgreSQL client nije instaliran (opciono)${NC}"
    echo "   Za PostgreSQL: brew install postgresql@15"
else
    echo -e "${GREEN}✓ PostgreSQL: $(psql --version)${NC}"
fi

echo ""

# ==============================================
# KORAK 2: Backend Production Setup
# ==============================================
echo -e "${BLUE}📦 Korak 2: Backend Production Setup...${NC}"

cd "$BACKEND_DIR"

# Proveri da li .env.production postoji
if [ ! -f ".env.production" ]; then
    echo -e "${YELLOW}📝 Kreiram .env.production fajl...${NC}"
    
    # Generiši SECRET_KEY
    SECRET_KEY=$(openssl rand -hex 32)
    
    # Pitaj korisnika koji tip baze želi
    echo ""
    echo -e "${BLUE}Izaberite tip baze podataka:${NC}"
    echo "  1) SQLite (preporučeno za manje sajtove, jednostavno)"
    echo "  2) PostgreSQL (za velike sajtove, zahteva dodatnu konfiguraciju)"
    echo ""
    read -p "Izbor (1 ili 2) [1]: " DB_CHOICE
    DB_CHOICE=${DB_CHOICE:-1}
    
    if [ "$DB_CHOICE" = "2" ]; then
        # PostgreSQL
        echo ""
        read -p "PostgreSQL korisničko ime [timberpunk_user]: " PG_USER
        PG_USER=${PG_USER:-timberpunk_user}
        read -p "PostgreSQL lozinka: " PG_PASS
        read -p "PostgreSQL host [localhost]: " PG_HOST
        PG_HOST=${PG_HOST:-localhost}
        read -p "PostgreSQL port [5432]: " PG_PORT
        PG_PORT=${PG_PORT:-5432}
        read -p "Ime baze [timberpunk]: " PG_DB
        PG_DB=${PG_DB:-timberpunk}
        
        DATABASE_URL="postgresql://${PG_USER}:${PG_PASS}@${PG_HOST}:${PG_PORT}/${PG_DB}"
    else
        # SQLite (default)
        DATABASE_URL="sqlite:///./timberpunk_production.db"
        echo -e "${GREEN}✓ Koristiće se SQLite baza${NC}"
    fi
    
    echo ""
    read -p "Admin email [admin@timberpunk.com]: " ADMIN_EMAIL
    ADMIN_EMAIL=${ADMIN_EMAIL:-admin@timberpunk.com}
    
    read -p "Admin lozinka: " ADMIN_PASSWORD
    while [ -z "$ADMIN_PASSWORD" ]; do
        echo -e "${RED}Lozinka ne može biti prazna!${NC}"
        read -p "Admin lozinka: " ADMIN_PASSWORD
    done
    
    read -p "Frontend URL [http://localhost:4173]: " FRONTEND_URL
    FRONTEND_URL=${FRONTEND_URL:-http://localhost:4173}
    
    cat > .env.production << EOF
# TimberPunk Backend - Production Environment Variables

# ===== DATABASE =====
DATABASE_URL=${DATABASE_URL}

# ===== SECURITY =====
SECRET_KEY=${SECRET_KEY}
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# ===== ADMIN CREDENTIALS =====
ADMIN_EMAIL=${ADMIN_EMAIL}
ADMIN_PASSWORD=${ADMIN_PASSWORD}

# ===== CORS =====
FRONTEND_URL=${FRONTEND_URL}
EOF
    echo -e "${GREEN}✓ .env.production fajl kreiran${NC}"
else
    echo -e "${GREEN}✓ .env.production fajl već postoji${NC}"
fi

# Kreiraj virtualno okruženje ako ne postoji
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}🐍 Kreiram Python virtualno okruženje...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✓ Virtualno okruženje kreirano${NC}"
else
    echo -e "${GREEN}✓ Virtualno okruženje već postoji${NC}"
fi

# Aktiviraj virtualno okruženje
echo -e "${YELLOW}🔄 Aktiviram virtualno okruženje...${NC}"
source venv/bin/activate

# Instaliraj Python zavisnosti (production)
echo -e "${YELLOW}📚 Instaliram Python pakete za produkciju...${NC}"
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt > /dev/null 2>&1
# Dodatno instaliraj gunicorn ako nije u requirements.txt
pip install gunicorn uvicorn[standard] > /dev/null 2>&1
echo -e "${GREEN}✓ Python paketi instalirani${NC}"

# Učitaj production env
export $(cat .env.production | grep -v '^#' | xargs)

# Kreiraj/migriraj bazu
echo -e "${YELLOW}🗄️  Kreiram/migriram bazu podataka...${NC}"
python3 << 'PYTHON_SCRIPT'
from database import engine, Base
from models import Admin, Product
from auth import get_password_hash
from sqlalchemy.orm import Session
import os

# Kreiraj tabele
Base.metadata.create_all(bind=engine)

# Proveri da li admin postoji
with Session(engine) as db:
    admin_email = os.getenv('ADMIN_EMAIL', 'admin@timberpunk.com')
    admin = db.query(Admin).filter(Admin.email == admin_email).first()
    
    if not admin:
        admin_password = os.getenv('ADMIN_PASSWORD', 'admin123')
        admin = Admin(
            email=admin_email,
            hashed_password=get_password_hash(admin_password)
        )
        db.add(admin)
        db.commit()
        print(f'✓ Admin korisnik kreiran: {admin_email}')
    else:
        print(f'✓ Admin korisnik već postoji: {admin_email}')
PYTHON_SCRIPT

echo -e "${GREEN}✓ Baza podataka spremna${NC}"

echo ""

# ==============================================
# KORAK 3: Frontend Production Setup
# ==============================================
echo -e "${BLUE}📦 Korak 3: Frontend Production Setup...${NC}"

cd "$FRONTEND_DIR"

# Kreiraj .env.production za frontend
if [ ! -f ".env.production" ]; then
    echo -e "${YELLOW}📝 Kreiram .env.production fajl za frontend...${NC}"
    
    read -p "Production API URL [http://localhost:8000]: " API_URL
    API_URL=${API_URL:-http://localhost:8000}
    
    cat > .env.production << EOF
# TimberPunk Frontend - Production Environment
VITE_API_URL=${API_URL}
EOF
    echo -e "${GREEN}✓ .env.production fajl kreiran${NC}"
else
    echo -e "${GREEN}✓ .env.production fajl već postoji${NC}"
fi

# Instaliraj npm pakete ako node_modules ne postoji
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📚 Instaliram npm pakete...${NC}"
    npm install > /dev/null 2>&1
    echo -e "${GREEN}✓ npm paketi instalirani${NC}"
else
    echo -e "${GREEN}✓ node_modules već postoji${NC}"
fi

# Build frontend
echo -e "${YELLOW}🏗️  Gradim production build frontend-a...${NC}"
npm run build > /dev/null 2>&1
echo -e "${GREEN}✓ Frontend build završen (folder: dist/)${NC}"

echo ""

# ==============================================
# KORAK 4: Pokretanje Production Servisa
# ==============================================
echo -e "${BLUE}🚀 Korak 4: Pokrećem production servise...${NC}"
echo ""

# Funkcija za cleanup
cleanup() {
    echo ""
    echo -e "${YELLOW}🛑 Zaustavljam servise...${NC}"
    kill $BACKEND_PID 2>/dev/null
    kill $FRONTEND_PID 2>/dev/null
    wait $BACKEND_PID 2>/dev/null
    wait $FRONTEND_PID 2>/dev/null
    echo -e "${GREEN}✓ Servisi zaustavljeni${NC}"
    exit 0
}

trap cleanup SIGINT SIGTERM

# Pokreni backend sa Gunicorn
echo -e "${GREEN}🔧 Pokrećem Backend (Gunicorn) na http://0.0.0.0:8000${NC}"
cd "$BACKEND_DIR"
source venv/bin/activate

# Učitaj production env
export $(cat .env.production | grep -v '^#' | xargs)

# Pokreni Gunicorn
gunicorn main:app \
    --workers 4 \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:8000 \
    --access-logfile /tmp/timberpunk_backend_access.log \
    --error-logfile /tmp/timberpunk_backend_error.log \
    --log-level info \
    --daemon

# Sačekaj da backend se pokrene
sleep 3

# Proveri da li je backend aktivan
if ! curl -s http://localhost:8000/docs > /dev/null; then
    echo -e "${RED}❌ Backend nije uspeo da se pokrene!${NC}"
    echo "Proverite logove:"
    echo "   cat /tmp/timberpunk_backend_error.log"
    exit 1
fi

BACKEND_PID=$(pgrep -f "gunicorn main:app")
echo -e "${GREEN}✓ Backend je aktivan (PID: $BACKEND_PID)${NC}"

# Pokreni frontend sa preview
echo -e "${GREEN}🎨 Pokrećem Frontend (Preview) na http://localhost:4173${NC}"
cd "$FRONTEND_DIR"
npm run preview -- --port 4173 --host 0.0.0.0 > /tmp/timberpunk_frontend.log 2>&1 &
FRONTEND_PID=$!

# Sačekaj da frontend bude spreman
sleep 3

if ! kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${RED}❌ Frontend nije uspeo da se pokrene!${NC}"
    echo "Greška:"
    cat /tmp/timberpunk_frontend.log
    kill $BACKEND_PID 2>/dev/null
    exit 1
fi

echo -e "${GREEN}✓ Frontend je aktivan${NC}"
echo ""

# ==============================================
# Production Informacije
# ==============================================
echo "================================================"
echo -e "${GREEN}✅ TimberPunk Production je pokrenut!${NC}"
echo "================================================"
echo ""
echo -e "${BLUE}📍 URL-ovi:${NC}"
echo "   🌐 Frontend:  http://localhost:4173"
echo "   🔧 Backend:   http://localhost:8000"
echo "   📚 API Docs:  http://localhost:8000/docs"
echo ""
echo -e "${BLUE}🔐 Admin pristup:${NC}"
echo "   📧 Email:     $(grep ADMIN_EMAIL $BACKEND_DIR/.env.production | cut -d '=' -f2)"
echo "   🔑 Password:  [proveri .env.production]"
echo "   🔗 URL:       http://localhost:4173/admin"
echo ""
echo -e "${BLUE}🗄️  Baza podataka:${NC}"
echo "   📁 URL:       $(grep DATABASE_URL $BACKEND_DIR/.env.production | cut -d '=' -f2 | head -n1)"
echo ""
echo -e "${BLUE}⚙️  Konfiguracija:${NC}"
echo "   🔧 Backend:   Gunicorn (4 workers, uvicorn worker class)"
echo "   🎨 Frontend:  Vite Preview (optimizovan build)"
echo ""
echo -e "${BLUE}📋 Logovi:${NC}"
echo "   Backend Access:  tail -f /tmp/timberpunk_backend_access.log"
echo "   Backend Error:   tail -f /tmp/timberpunk_backend_error.log"
echo "   Frontend:        tail -f /tmp/timberpunk_frontend.log"
echo ""
echo -e "${BLUE}🔍 Process IDs:${NC}"
echo "   Backend PID:  $BACKEND_PID"
echo "   Frontend PID: $FRONTEND_PID"
echo ""
echo -e "${YELLOW}⚠️  Za zaustavljanje servisa:${NC}"
echo "   kill $BACKEND_PID $FRONTEND_PID"
echo "   ili pritisnite Ctrl+C"
echo ""
echo -e "${BLUE}📦 Backup baze:${NC}"
if [[ $(grep DATABASE_URL $BACKEND_DIR/.env.production | head -n1) == *"sqlite"* ]]; then
    echo "   SQLite: cp $BACKEND_DIR/timberpunk_production.db backup_\$(date +%Y%m%d).db"
else
    echo "   PostgreSQL: pg_dump timberpunk > backup_\$(date +%Y%m%d).sql"
fi
echo ""
echo "================================================"
echo ""

# Drži skriptu aktivnom
wait $FRONTEND_PID
