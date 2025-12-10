#!/bin/bash

# TimberPunk - Lokalno Razvojno Okruženje - Setup Skripta
# Automatski postavlja i pokreće backend i frontend

set -e  # Zaustavi skriptu ako nešto ne uspe

echo "================================================"
echo "🪵 TimberPunk - Lokalno Okruženje Setup"
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
echo ""

# ==============================================
# KORAK 2: Backend Setup
# ==============================================
echo -e "${BLUE}📦 Korak 2: Backend Setup...${NC}"

cd "$BACKEND_DIR"

# Kreiraj .env fajl za lokalno okruženje ako ne postoji
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}📝 Kreiram .env fajl za backend...${NC}"
    cat > .env << 'EOF'
# TimberPunk Backend - Local Development Environment

# ===== DATABASE =====
DATABASE_URL=sqlite:///./timberpunk.db

# ===== SECURITY =====
SECRET_KEY=dev-secret-key-change-in-production-09d25e094faa6ca2556c818166b7a9563b93f7099f6f0f4caa6cf63b88e8d3e7
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# ===== ADMIN CREDENTIALS =====
ADMIN_EMAIL=admin@timberpunk.com
ADMIN_PASSWORD=admin123

# ===== CORS =====
FRONTEND_URL=http://localhost:5173
EOF
    echo -e "${GREEN}✓ .env fajl kreiran${NC}"
else
    echo -e "${GREEN}✓ .env fajl već postoji${NC}"
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

# Instaliraj Python zavisnosti
echo -e "${YELLOW}📚 Instaliram Python pakete...${NC}"
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt > /dev/null 2>&1
echo -e "${GREEN}✓ Python paketi instalirani${NC}"

# Proveri da li baza postoji, ako ne - kreiraj je
if [ ! -f "timberpunk.db" ]; then
    echo -e "${YELLOW}🗄️  Kreiram bazu podataka i dodajem početne podatke...${NC}"
    python3 -c "
from database import engine, Base
from models import Admin, Product, Order, OrderItem
from auth import get_password_hash
from sqlalchemy.orm import Session

# Kreiraj tabele
Base.metadata.create_all(bind=engine)

# Dodaj admin korisnika i test podatke
with Session(engine) as db:
    # Admin user
    admin = Admin(
        email='admin@timberpunk.com',
        hashed_password=get_password_hash('admin123')
    )
    db.add(admin)
    
    # Test proizvodi
    products = [
        Product(
            name='Drvena Cutting Board',
            description='Ručno izrađena daska za sečenje od hrasta.\n\nDimenzije: 40x30x2cm\nMaterijal: Hrastovina\nZavršna obrada: Mineralno ulje',
            price=4500.00,
            category='Kuhinja',
            image_url='https://images.unsplash.com/photo-1598327105666-5b89351aff97?w=600'
        ),
        Product(
            name='Drvena Kutija za Nakit',
            description='Elegantna kutija za čuvanje nakita.\n\nIzrađena od orah drveta sa plišanom postavom.\nPerfektan poklon!',
            price=3200.00,
            category='Dekoracija',
            image_url='https://images.unsplash.com/photo-1583623025817-d180a2221d0a?w=600'
        ),
        Product(
            name='Set Drvenih Podmetača',
            description='Set od 6 ručno izrađenih podmetača.\n\nMaterijal: Razne vrste drveta\nFinish: Vosak',
            price=1500.00,
            category='Kuhinja',
            image_url='https://images.unsplash.com/photo-1565374373232-2c0ca1b3e412?w=600'
        ),
    ]
    
    for product in products:
        db.add(product)
    
    db.commit()
    print('✓ Baza kreirana i popunjena test podacima')
"
    echo -e "${GREEN}✓ Baza podataka spremna${NC}"
else
    echo -e "${GREEN}✓ Baza podataka već postoji${NC}"
fi

echo ""

# ==============================================
# KORAK 3: Frontend Setup
# ==============================================
echo -e "${BLUE}📦 Korak 3: Frontend Setup...${NC}"

cd "$FRONTEND_DIR"

# Kreiraj .env fajl za frontend ako ne postoji
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}📝 Kreiram .env fajl za frontend...${NC}"
    cat > .env << 'EOF'
# TimberPunk Frontend - Local Development Environment
VITE_API_URL=http://localhost:8000
EOF
    echo -e "${GREEN}✓ .env fajl kreiran${NC}"
else
    echo -e "${GREEN}✓ .env fajl već postoji${NC}"
fi

# Instaliraj npm pakete ako node_modules ne postoji
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📚 Instaliram npm pakete (može da potraje)...${NC}"
    npm install > /dev/null 2>&1
    echo -e "${GREEN}✓ npm paketi instalirani${NC}"
else
    echo -e "${GREEN}✓ node_modules već postoji${NC}"
fi

echo ""

# ==============================================
# KORAK 4: Pokretanje servisa
# ==============================================
echo -e "${BLUE}🚀 Korak 4: Pokrećem servise...${NC}"
echo ""

# Funkcija za cleanup kada se skripta zaustavi
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

# Pokreni backend
echo -e "${GREEN}🔧 Pokrećem Backend na http://localhost:8000${NC}"
cd "$BACKEND_DIR"
source venv/bin/activate
uvicorn main:app --reload --host 0.0.0.0 --port 8000 > /tmp/timberpunk_backend.log 2>&1 &
BACKEND_PID=$!

# Sačekaj da backend bude spreman
echo -e "${YELLOW}⏳ Čekam da backend bude spreman...${NC}"
sleep 3

if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${RED}❌ Backend nije uspeo da se pokrene!${NC}"
    echo "Greška:"
    cat /tmp/timberpunk_backend.log
    exit 1
fi

echo -e "${GREEN}✓ Backend je aktivan${NC}"

# Pokreni frontend
echo -e "${GREEN}🎨 Pokrećem Frontend na http://localhost:5173${NC}"
cd "$FRONTEND_DIR"
npm run dev > /tmp/timberpunk_frontend.log 2>&1 &
FRONTEND_PID=$!

# Sačekaj da frontend bude spreman
echo -e "${YELLOW}⏳ Čekam da frontend bude spreman...${NC}"
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
# Informacije
# ==============================================
echo "================================================"
echo -e "${GREEN}✅ TimberPunk je uspešno pokrenut!${NC}"
echo "================================================"
echo ""
echo -e "${BLUE}📍 URL-ovi:${NC}"
echo "   🌐 Frontend:  http://localhost:5173"
echo "   🔧 Backend:   http://localhost:8000"
echo "   📚 API Docs:  http://localhost:8000/docs"
echo ""
echo -e "${BLUE}🔐 Admin pristup:${NC}"
echo "   📧 Email:     admin@timberpunk.com"
echo "   🔑 Password:  admin123"
echo "   🔗 URL:       http://localhost:5173/admin"
echo ""
echo -e "${BLUE}🗄️  Baza podataka:${NC}"
echo "   📁 SQLite:    $BACKEND_DIR/timberpunk.db"
echo ""
echo -e "${BLUE}📋 Logovi:${NC}"
echo "   Backend:  tail -f /tmp/timberpunk_backend.log"
echo "   Frontend: tail -f /tmp/timberpunk_frontend.log"
echo ""
echo -e "${YELLOW}⚠️  Pritisnite Ctrl+C da zaustavite servise${NC}"
echo "================================================"
echo ""

# Drži skriptu aktivnom
wait $BACKEND_PID $FRONTEND_PID
