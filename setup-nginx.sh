#!/bin/bash

# TimberPunk - Nginx Reverse Proxy Setup
# Omogućava pristup aplikaciji bez porta (samo DNS)

set -e

echo "================================================"
echo "🪵 TimberPunk - Nginx Setup"
echo "================================================"
echo ""

# Boje
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# AWS EC2 Public DNS
AWS_PUBLIC_DNS="ec2-52-29-195-201.eu-central-1.compute.amazonaws.com"

echo -e "${BLUE}📋 Korak 1: Instalacija Nginx...${NC}"

if ! command -v nginx &> /dev/null; then
    echo -e "${YELLOW}📦 Instaliram Nginx...${NC}"
    sudo apt update
    sudo apt install -y nginx
    echo -e "${GREEN}✓ Nginx instaliran${NC}"
else
    echo -e "${GREEN}✓ Nginx već instaliran: $(nginx -v 2>&1)${NC}"
fi

echo ""
echo -e "${BLUE}🔧 Korak 2: Konfiguracija Nginx reverse proxy...${NC}"

# Kreiraj Nginx config za TimberPunk
sudo tee /etc/nginx/sites-available/timberpunk > /dev/null << 'EOF'
server {
    listen 80;
    server_name ec2-52-29-195-201.eu-central-1.compute.amazonaws.com;

    # Frontend (React)
    location / {
        proxy_pass http://localhost:4173;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend API
    location /api {
        rewrite ^/api/(.*) /$1 break;
        proxy_pass http://localhost:8000;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Backend docs
    location /docs {
        proxy_pass http://localhost:8000/docs;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }

    location /openapi.json {
        proxy_pass http://localhost:8000/openapi.json;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
    }
}
EOF

echo -e "${GREEN}✓ Nginx config kreiran: /etc/nginx/sites-available/timberpunk${NC}"

echo ""
echo -e "${BLUE}🔗 Korak 3: Aktivacija konfiguracije...${NC}"

# Ukloni default site ako postoji
sudo rm -f /etc/nginx/sites-enabled/default

# Kreiraj symlink
sudo ln -sf /etc/nginx/sites-available/timberpunk /etc/nginx/sites-enabled/

echo -e "${GREEN}✓ Konfiguracija aktivirana${NC}"

echo ""
echo -e "${BLUE}✅ Korak 4: Testiranje i restart Nginx...${NC}"

# Testiraj config
if sudo nginx -t; then
    echo -e "${GREEN}✓ Nginx config validan${NC}"
    
    # Restart Nginx
    sudo systemctl restart nginx
    sudo systemctl enable nginx
    
    echo -e "${GREEN}✓ Nginx restartovan i omogućen${NC}"
else
    echo -e "${RED}❌ Nginx config nije validan!${NC}"
    exit 1
fi

echo ""
echo "================================================"
echo -e "${GREEN}✅ Nginx uspešno konfigurisan!${NC}"
echo "================================================"
echo ""
echo -e "${BLUE}📡 Pristup aplikaciji:${NC}"
echo "   Frontend: http://${AWS_PUBLIC_DNS}"
echo "   Backend API: http://${AWS_PUBLIC_DNS}/api/"
echo "   API Docs: http://${AWS_PUBLIC_DNS}/docs"
echo ""
echo -e "${BLUE}🔒 AWS Security Group - potrebna pravila:${NC}"
echo "   Port 80 (HTTP) - Source: 0.0.0.0/0"
echo "   Port 22 (SSH) - Source: Your IP"
echo ""
echo -e "${YELLOW}⚠️  NAPOMENA:${NC}"
echo "   - Portovi 4173 i 8000 više nisu potrebni u Security Group"
echo "   - Nginx sluša na portu 80 i prosleđuje zahteve"
echo "   - Frontend i Backend moraju biti pokrenuti na 4173 i 8000"
echo ""
echo -e "${BLUE}🔍 Provera statusa:${NC}"
echo "   sudo systemctl status nginx"
echo "   sudo nginx -t"
echo "   curl http://localhost"
echo ""
echo "================================================"
