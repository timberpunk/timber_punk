#!/bin/bash

# TimberPunk - AWS Server Commands
# Komande koje treba pokrenuti NA AWS EC2 serveru

echo "================================================"
echo "🪵 TimberPunk - AWS Server Setup"
echo "================================================"
echo ""
echo "Ova skripta sadrži komande koje treba pokrenuti NA AWS serveru"
echo "Kopiraj i izvršavaj korak po korak"
echo ""
echo "================================================"

cat << 'EOF'

# ===== KORAK 1: Update koda sa GitHub-a =====
cd ~/timber_punk
git pull origin main

# ===== KORAK 2: Instalacija i konfiguracija Nginx =====
# Instaliraj Nginx ako nije instaliran
sudo apt update
sudo apt install -y nginx

# Kreiraj Nginx konfiguraciju
sudo tee /etc/nginx/sites-available/timberpunk > /dev/null << 'NGINX_CONFIG'
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

    # Backend API - VAŽNO: rewrite uklanja /api prefix
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
NGINX_CONFIG

# Aktiviraj konfiguraciju
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/timberpunk /etc/nginx/sites-enabled/

# Testiraj i restartuj Nginx
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

echo "✓ Nginx konfigurisan"

# ===== KORAK 3: Update Frontend .env.production =====
cd ~/timber_punk/tp_ui

cat > .env.production << 'ENV_PROD'
# TimberPunk Frontend - Production Environment Variables

# Backend API URL (preko Nginx reverse proxy)
VITE_API_URL=http://ec2-52-29-195-201.eu-central-1.compute.amazonaws.com/api
ENV_PROD

echo "✓ .env.production ažuriran"

# ===== KORAK 4: Rebuild Frontend =====
npm run build

echo "✓ Frontend build završen"

# ===== KORAK 5: Restartuj servise =====
# Zaustavi postojeće procese
pkill -f 'gunicorn' || true
pkill -f 'vite preview' || true

# Startuj Backend
cd ~/timber_punk/tp_backend
source venv/bin/activate
nohup gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000 > /tmp/timberpunk_backend.log 2>&1 &
echo "✓ Backend pokrenut (PID: $!)"

# Startuj Frontend
cd ~/timber_punk/tp_ui
nohup npm run preview -- --port 4173 --host 0.0.0.0 > /tmp/timberpunk_frontend.log 2>&1 &
echo "✓ Frontend pokrenut (PID: $!)"

# ===== KORAK 6: Provera statusa =====
echo ""
echo "================================================"
echo "✅ Setup završen!"
echo "================================================"
echo ""
echo "📡 Aplikacija dostupna na:"
echo "   Frontend: http://ec2-52-29-195-201.eu-central-1.compute.amazonaws.com"
echo "   Backend API: http://ec2-52-29-195-201.eu-central-1.compute.amazonaws.com/api"
echo "   API Docs: http://ec2-52-29-195-201.eu-central-1.compute.amazonaws.com/docs"
echo ""
echo "🔍 Provera servisa:"
echo "   sudo systemctl status nginx"
echo "   ps aux | grep gunicorn"
echo "   ps aux | grep vite"
echo ""
echo "📋 Logovi:"
echo "   Backend: tail -f /tmp/timberpunk_backend.log"
echo "   Frontend: tail -f /tmp/timberpunk_frontend.log"
echo "   Nginx: sudo tail -f /var/log/nginx/access.log"
echo ""
echo "🔒 AWS Security Group:"
echo "   Port 80 (HTTP) - Source: 0.0.0.0/0 ✓"
echo "   Port 22 (SSH) - Source: Your IP ✓"
echo ""
echo "================================================"

EOF

echo ""
echo "================================================"
echo "📋 INSTRUKCIJE:"
echo "================================================"
echo ""
echo "1. SSH na AWS server:"
echo "   ssh -i your-key.pem ubuntu@ec2-52-29-195-201.eu-central-1.compute.amazonaws.com"
echo ""
echo "2. Kopiraj komande iznad i izvršavaj ih korak po korak"
echo ""
echo "3. Ili sačuvaj komande u fajl:"
echo "   nano ~/setup-server.sh"
echo "   chmod +x ~/setup-server.sh"
echo "   ./setup-server.sh"
echo ""
echo "================================================"
