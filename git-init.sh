#!/bin/bash

# TimberPunk - Git Repository Setup
# Inicijalizuje jedinstven GitHub repo za ceo projekat

echo "================================================"
echo "🪵 TimberPunk - Git Repository Setup"
echo "================================================"
echo ""

# Boje
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Root direktorijum projekta
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${BLUE}📋 Provera stanja...${NC}"
echo ""

# Provera postojećih .git foldera
if [ -d ".git" ]; then
    echo -e "${YELLOW}⚠️  Root .git folder već postoji!${NC}"
    read -p "Želite li da ga obrišete i napravite novi? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf .git
        echo -e "${GREEN}✓ Stari .git obrisan${NC}"
    else
        echo -e "${RED}❌ Odustao. Izlazim...${NC}"
        exit 1
    fi
fi

# Provera tp_ui/.git
if [ -d "tp_ui/.git" ]; then
    echo -e "${YELLOW}⚠️  tp_ui/.git postoji (stari frontend repo)${NC}"
    read -p "Želite li da ga sklonite? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv tp_ui/.git tp_ui/.git.backup
        echo -e "${GREEN}✓ tp_ui/.git premešteno u tp_ui/.git.backup${NC}"
    fi
fi

# Provera tp_backend/.git
if [ -d "tp_backend/.git" ]; then
    echo -e "${YELLOW}⚠️  tp_backend/.git postoji (stari backend repo)${NC}"
    read -p "Želite li da ga sklonite? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        mv tp_backend/.git tp_backend/.git.backup
        echo -e "${GREEN}✓ tp_backend/.git premešteno u tp_backend/.git.backup${NC}"
    fi
fi

echo ""
echo -e "${BLUE}🎯 Inicijalizujem novi Git repo...${NC}"

# Inicijalizuj Git
git init
echo -e "${GREEN}✓ Git repo inicijalizovan${NC}"

# Dodaj sve fajlove
echo -e "${YELLOW}📦 Dodajem fajlove...${NC}"
git add .
echo -e "${GREEN}✓ Fajlovi dodati${NC}"

# Prvi commit
echo -e "${YELLOW}💾 Kreiram prvi commit...${NC}"
git commit -m "🎉 Initial commit: TimberPunk e-commerce platform

- Backend: FastAPI + SQLAlchemy
- Frontend: React + TypeScript + Vite
- Dvojezično: Srpski (default) + Engleski
- Admin panel za upravljanje proizvodima
- SQLite/PostgreSQL podrška
- Automatski setup scripts (local & production)"

echo -e "${GREEN}✓ Prvi commit kreiran${NC}"

# Branch na main
git branch -M main
echo -e "${GREEN}✓ Branch postavljen na 'main'${NC}"

echo ""
echo -e "${BLUE}🌐 GitHub setup...${NC}"
echo ""

read -p "Unesite GitHub repo URL (npr. https://github.com/username/timber_punk.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo -e "${YELLOW}⚠️  Repo URL nije unet. Možete ga dodati kasnije sa:${NC}"
    echo "   git remote add origin https://github.com/username/timber_punk.git"
    echo "   git push -u origin main"
else
    git remote add origin "$REPO_URL"
    echo -e "${GREEN}✓ Remote origin dodat: $REPO_URL${NC}"
    
    echo ""
    read -p "Želite li odmah da push-ujete na GitHub? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}📤 Push-ujem na GitHub...${NC}"
        git push -u origin main
        echo -e "${GREEN}✓ Push uspešan!${NC}"
    else
        echo -e "${YELLOW}⚠️  Push kasnije sa:${NC}"
        echo "   git push -u origin main"
    fi
fi

echo ""
echo "================================================"
echo -e "${GREEN}✅ Git repo uspešno postavljen!${NC}"
echo "================================================"
echo ""
echo -e "${BLUE}📁 Repo struktura:${NC}"
echo "   timber_punk/ (root - glavni repo)"
echo "   ├── tp_backend/"
echo "   ├── tp_ui/"
echo "   ├── setup-local.sh"
echo "   ├── setup-production.sh"
echo "   └── README files"
echo ""
echo -e "${BLUE}🔧 Git status:${NC}"
git status
echo ""
echo -e "${BLUE}📝 Sledeći koraci:${NC}"
echo "   1. Kreirajte repo na GitHub-u ako već nije kreiran"
echo "   2. Dodajte remote origin (ako nije već dodat):"
echo "      git remote add origin https://github.com/username/timber_punk.git"
echo "   3. Push-ujte kod:"
echo "      git push -u origin main"
echo ""
echo -e "${BLUE}🚀 Za kloniranje na drugom računaru:${NC}"
echo "   git clone $REPO_URL"
echo "   cd timber_punk"
echo "   ./setup-local.sh"
echo ""
echo "================================================"
