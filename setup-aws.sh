#!/bin/bash

# TimberPunk - AWS EC2 Production Deployment
# Automatski setup za deployment na AWS EC2 instancu

set -e

echo "================================================"
echo "🪵 TimberPunk - AWS EC2 Production Setup"
echo "================================================"
echo ""

# Boje
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Direktorijumi
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKEND_DIR="$SCRIPT_DIR/tp_backend"
FRONTEND_DIR="$SCRIPT_DIR/tp_ui"

# AWS EC2 Public DNS
AWS_PUBLIC_DNS="ec2-52-29-195-201.eu-central-1.compute.amazonaws.com"

echo -e "${BLUE}📋 Korak 1: Provera alata...${NC}"

if ! command -v python3 &> /dev/null; then
    echo -e "${RED}❌ Python3 nije instaliran!${NC}"
    echo "Instalirajte: sudo apt update && sudo apt install python3 python3-pip python3-venv"
    exit 1
fi
echo -e "${GREEN}✓ Python3: $(python3 --version)${NC}"

if ! command -v node &> /dev/null; then
    echo -e "${RED}❌ Node.js nije instaliran!${NC}"
    echo "Instalirajte: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -"
    echo "             sudo apt-get install -y nodejs"
    exit 1
fi
echo -e "${GREEN}✓ Node.js: $(node --version)${NC}"
echo -e "${GREEN}✓ npm: $(npm --version)${NC}"

echo ""
echo -e "${BLUE}📦 Korak 2: Backend Production Setup...${NC}"

cd "$BACKEND_DIR"

# Kreiraj .env.production
if [ ! -f ".env.production" ]; then
    echo -e "${YELLOW}📝 Kreiram .env.production...${NC}"
    
    SECRET_KEY=$(openssl rand -hex 32)
    
    read -p "Admin email [admin@timberpunk.com]: " ADMIN_EMAIL
    ADMIN_EMAIL=${ADMIN_EMAIL:-admin@timberpunk.com}
    
    read -p "Admin lozinka: " ADMIN_PASSWORD
    while [ -z "$ADMIN_PASSWORD" ]; do
        echo -e "${RED}Lozinka ne može biti prazna!${NC}"
        read -p "Admin lozinka: " ADMIN_PASSWORD
    done
    
    cat > .env.production << EOF
# TimberPunk Backend - AWS EC2 Production

# ===== DATABASE =====
DATABASE_URL=sqlite:///./timberpunk_production.db

# ===== SECURITY =====
SECRET_KEY=${SECRET_KEY}
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# ===== ADMIN CREDENTIALS =====
ADMIN_EMAIL=${ADMIN_EMAIL}
ADMIN_PASSWORD=${ADMIN_PASSWORD}

# ===== CORS =====
FRONTEND_URL=http://${AWS_PUBLIC_DNS}
EOF
    echo -e "${GREEN}✓ .env.production kreiran${NC}"
else
    echo -e "${GREEN}✓ .env.production već postoji${NC}"
fi

# Python venv
if [ ! -d "venv" ]; then
    echo -e "${YELLOW}🐍 Kreiram Python venv...${NC}"
    python3 -m venv venv
    echo -e "${GREEN}✓ venv kreiran${NC}"
fi

source venv/bin/activate

# Instaliraj pakete
echo -e "${YELLOW}📚 Instaliram Python pakete...${NC}"
pip install --upgrade pip > /dev/null 2>&1
pip install -r requirements.txt > /dev/null 2>&1
pip install gunicorn uvicorn[standard] > /dev/null 2>&1
echo -e "${GREEN}✓ Paketi instalirani${NC}"

# Kreiraj bazu
echo -e "${YELLOW}🗄️  Kreiram bazu...${NC}"
export $(cat .env.production | grep -v '^#' | xargs)
python3 << 'PYTHON_SCRIPT'
from database import engine, Base
from models import Admin
from auth import get_password_hash
from sqlalchemy.orm import Session
import os

Base.metadata.create_all(bind=engine)

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
        print(f'✓ Admin kreiran: {admin_email}')
    else:
        print(f'✓ Admin već postoji: {admin_email}')
PYTHON_SCRIPT
echo -e "${GREEN}✓ Baza spremna${NC}"

echo ""
echo -e "${BLUE}📦 Korak 3: Frontend Production Setup...${NC}"

cd "$FRONTEND_DIR"

# Frontend .env.production
if [ ! -f ".env.production" ]; then
    echo -e "${YELLOW}📝 Kreiram frontend .env.production...${NC}"
    cat > .env.production << EOF
# TimberPunk Frontend - AWS EC2 Production
VITE_API_URL=http://${AWS_PUBLIC_DNS}:8000
EOF
    echo -e "${GREEN}✓ .env.production kreiran${NC}"
else
    echo -e "${GREEN}✓ .env.production već postoji${NC}"
fi

# npm paketi
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}📚 Instaliram npm pakete...${NC}"
    npm install > /dev/null 2>&1
    echo -e "${GREEN}✓ npm paketi instalirani${NC}"
fi

# Build
echo -e "${YELLOW}🏗️  Building frontend...${NC}"
npm run build > /dev/null 2>&1
echo -e "${GREEN}✓ Frontend build završen${NC}"

echo ""
echo -e "${BLUE}🚀 Korak 4: Pokretanje servisa...${NC}"

# Zaustavi postojeće procese
echo -e "${YELLOW}🛑 Zaustavljam stare procese...${NC}"
pkill -f "gunicorn main:app" 2>/dev/null || true
pkill -f "vite preview" 2>/dev/null || true
sleep 2

# Pokreni backend
echo -e "${GREEN}🔧 Pokrećem Backend na port 8000...${NC}"
cd "$BACKEND_DIR"
source venv/bin/activate
export $(cat .env.production | grep -v '^#' | xargs)

nohup gunicorn main:app \
    --workers 4 \
    --worker-class uvicorn.workers.UvicornWorker \
    --bind 0.0.0.0:8000 \
    --access-logfile /tmp/timberpunk_backend_access.log \
    --error-logfile /tmp/timberpunk_backend_error.log \
    --log-level info \
    > /tmp/timberpunk_backend.log 2>&1 &

BACKEND_PID=$!
sleep 3

if ! kill -0 $BACKEND_PID 2>/dev/null; then
    echo -e "${RED}❌ Backend nije uspeo da se pokrene!${NC}"
    cat /tmp/timberpunk_backend_error.log
    exit 1
fi
echo -e "${GREEN}✓ Backend aktivan (PID: $BACKEND_PID)${NC}"

# Pokreni frontend
echo -e "${GREEN}🎨 Pokrećem Frontend na port 80...${NC}"
cd "$FRONTEND_DIR"

# Proveri da li ima sudo pristup za port 80
if [ "$EUID" -eq 0 ]; then
    # Root - može koristiti port 80
    nohup npm run preview -- --port 80 --host 0.0.0.0 > /tmp/timberpunk_frontend.log 2>&1 &
    FRONTEND_PID=$!
    echo -e "${GREEN}✓ Frontend na portu 80 (HTTP)${NC}"
else
    # Nije root - koristi port 4173
    echo -e "${YELLOW}⚠️  Niste root - koristim port 4173${NC}"
    echo -e "${YELLOW}   Za port 80, pokrenite: sudo ./setup-aws.sh${NC}"
    nohup npm run preview -- --port 4173 --host 0.0.0.0 > /tmp/timberpunk_frontend.log 2>&1 &
    FRONTEND_PID=$!
fi

sleep 3

if ! kill -0 $FRONTEND_PID 2>/dev/null; then
    echo -e "${RED}❌ Frontend nije uspeo da se pokrene!${NC}"
    cat /tmp/timberpunk_frontend.log
    exit 1
fi
echo -e "${GREEN}✓ Frontend aktivan (PID: $FRONTEND_PID)${NC}"

# Kreiraj stop skriptu
cat > "$SCRIPT_DIR/stop-aws.sh" << 'EOF'
#!/bin/bash
echo "Zaustavljam TimberPunk servise..."
pkill -f "gunicorn main:app"
pkill -f "vite preview"
echo "Servisi zaustavljeni!"
EOF
chmod +x "$SCRIPT_DIR/stop-aws.sh"

echo ""
echo "================================================"
echo -e "${GREEN}✅ TimberPunk je uspešno deploy-ovan na AWS!${NC}"
echo "================================================"
echo ""
echo -e "${BLUE}🌐 Vaš sajt je dostupan na:${NC}"
if [ "$EUID" -eq 0 ]; then
    echo "   🌐 Frontend:  http://${AWS_PUBLIC_DNS}"
    echo "   🔧 Backend:   http://${AWS_PUBLIC_DNS}:8000"
    echo "   📚 API Docs:  http://${AWS_PUBLIC_DNS}:8000/docs"
    echo "   🔐 Admin:     http://${AWS_PUBLIC_DNS}/admin"
else
    echo "   🌐 Frontend:  http://${AWS_PUBLIC_DNS}:4173"
    echo "   🔧 Backend:   http://${AWS_PUBLIC_DNS}:8000"
    echo "   📚 API Docs:  http://${AWS_PUBLIC_DNS}:8000/docs"
    echo "   🔐 Admin:     http://${AWS_PUBLIC_DNS}:4173/admin"
fi
echo ""
echo -e "${BLUE}🔐 Admin pristup:${NC}"
echo "   📧 Email:     $(grep ADMIN_EMAIL $BACKEND_DIR/.env.production | cut -d '=' -f2)"
echo "   🔑 Password:  [proveri .env.production]"
echo ""
echo -e "${BLUE}🔍 Process IDs:${NC}"
echo "   Backend:  $BACKEND_PID"
echo "   Frontend: $FRONTEND_PID"
echo ""
echo -e "${BLUE}📋 Logovi:${NC}"
echo "   Backend:  tail -f /tmp/timberpunk_backend_error.log"
echo "   Frontend: tail -f /tmp/timberpunk_frontend.log"
echo ""
echo -e "${BLUE}🛑 Za zaustavljanje:${NC}"
echo "   ./stop-aws.sh"
echo ""
echo -e "${YELLOW}⚠️  AWS EC2 Security Group mora dozvoliti:${NC}"
echo "   - Port 8000 (Backend API)"
if [ "$EUID" -eq 0 ]; then
    echo "   - Port 80 (Frontend HTTP)"
else
    echo "   - Port 4173 (Frontend)"
fi
echo ""
echo -e "${BLUE}📦 Za omogućavanje porta 80 (root):${NC}"
echo "   sudo ./setup-aws.sh"
echo ""
echo "================================================"
