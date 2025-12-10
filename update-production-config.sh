#!/bin/bash

# TimberPunk - Update Production Environment
# Ažurira .env.production fajlove za Nginx setup

set -e

echo "================================================"
echo "🪵 TimberPunk - Update Production Config"
echo "================================================"
echo ""

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AWS_PUBLIC_DNS="ec2-52-29-195-201.eu-central-1.compute.amazonaws.com"

echo -e "${BLUE}📝 Ažuriram frontend .env.production...${NC}"

cat > "$SCRIPT_DIR/tp_ui/.env.production" << EOF
# TimberPunk Frontend - Production Environment Variables

# Backend API URL (preko Nginx reverse proxy)
VITE_API_URL=http://${AWS_PUBLIC_DNS}/api
EOF

echo -e "${GREEN}✓ Frontend .env.production ažuriran${NC}"
echo ""
echo -e "${BLUE}📦 Rebuild frontend...${NC}"

cd "$SCRIPT_DIR/tp_ui"
npm run build

echo -e "${GREEN}✓ Frontend rebuild završen${NC}"
echo ""
echo "================================================"
echo -e "${GREEN}✅ Konfiguracija ažurirana!${NC}"
echo "================================================"
echo ""
echo -e "${BLUE}📋 Na AWS serveru, pokreni:${NC}"
echo "   1. Kopiraj novi .env.production:"
echo "      scp tp_ui/.env.production ec2-user@${AWS_PUBLIC_DNS}:~/timber_punk/tp_ui/"
echo ""
echo "   2. Rebuild frontend:"
echo "      cd ~/timber_punk/tp_ui"
echo "      npm run build"
echo ""
echo "   3. Restartuj frontend:"
echo "      pkill -f 'vite preview'"
echo "      nohup npm run preview -- --port 4173 --host 0.0.0.0 > /tmp/timberpunk_frontend.log 2>&1 &"
echo ""
echo "================================================"
