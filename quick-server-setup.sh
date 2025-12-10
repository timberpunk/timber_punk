#!/bin/bash

# TimberPunk - Quick AWS Server Setup
# Brzi setup Nginx-a i restart servisa nakon git pull

echo "================================================"
echo "🪵 TimberPunk - Quick Server Setup"
echo "================================================"

# KORAK 1: Instaliraj Nginx
echo "📦 Instaliram Nginx..."
sudo apt update
sudo apt install -y nginx

# KORAK 2: Konfiguriši Nginx
echo "🔧 Konfigurišem Nginx..."
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

    # Backend API - rewrite uklanja /api prefix
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

# KORAK 3: Aktiviraj konfiguraciju
echo "🔗 Aktiviram konfiguraciju..."
sudo rm -f /etc/nginx/sites-enabled/default
sudo ln -sf /etc/nginx/sites-available/timberpunk /etc/nginx/sites-enabled/

# KORAK 4: Testiraj i restartuj Nginx
echo "✅ Testiram i restartujem Nginx..."
sudo nginx -t
sudo systemctl restart nginx
sudo systemctl enable nginx

# KORAK 5: Rebuild Frontend
echo "🏗️  Rebuilding frontend..."
cd ~/timber_punk/tp_ui
npm run build

# KORAK 6: Restartuj servise
echo "🔄 Restartujem servise..."
pkill -f 'gunicorn' || true
pkill -f 'vite preview' || true

sleep 2

# Startuj Backend
cd ~/timber_punk/tp_backend
source venv/bin/activate
nohup gunicorn -w 4 -k uvicorn.workers.UvicornWorker app.main:app --bind 0.0.0.0:8000 > /tmp/timberpunk_backend.log 2>&1 &
BACKEND_PID=$!
echo "✓ Backend pokrenut (PID: $BACKEND_PID)"

# Startuj Frontend
cd ~/timber_punk/tp_ui
nohup npm run preview -- --port 4173 --host 0.0.0.0 > /tmp/timberpunk_frontend.log 2>&1 &
FRONTEND_PID=$!
echo "✓ Frontend pokrenut (PID: $FRONTEND_PID)"

sleep 3

# KORAK 7: Provera statusa
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
sudo systemctl status nginx | head -3
echo ""
ps aux | grep gunicorn | grep -v grep
ps aux | grep vite | grep -v grep
echo ""
echo "📋 Logovi:"
echo "   Backend: tail -f /tmp/timberpunk_backend.log"
echo "   Frontend: tail -f /tmp/timberpunk_frontend.log"
echo "   Nginx: sudo tail -f /var/log/nginx/error.log"
echo ""
echo "🔒 NE ZABORAVI: Otvori port 80 u AWS Security Group!"
echo "================================================"
