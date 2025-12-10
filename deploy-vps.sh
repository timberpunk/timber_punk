#!/bin/bash

# TimberPunk VPS Deployment Script (No Docker)
# Run this on your VPS server

set -e

echo "🪵 TimberPunk VPS Deployment"
echo "============================"
echo ""

# Configuration
APP_NAME="timberpunk"
APP_USER="www-data"
APP_DIR="/var/www/$APP_NAME"
BACKEND_DIR="$APP_DIR/tp_backend"
FRONTEND_DIR="$APP_DIR/tp_ui"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}1. Updating system packages...${NC}"
sudo apt update
sudo apt upgrade -y

echo -e "${YELLOW}2. Installing dependencies...${NC}"
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    postgresql \
    postgresql-contrib \
    nginx \
    git \
    nodejs \
    npm \
    certbot \
    python3-certbot-nginx

echo -e "${GREEN}✅ Dependencies installed${NC}"
echo ""

echo -e "${YELLOW}3. Setting up PostgreSQL...${NC}"
read -p "Enter database name (default: timberpunk): " DB_NAME
DB_NAME=${DB_NAME:-timberpunk}

read -p "Enter database user (default: timberpunk_user): " DB_USER
DB_USER=${DB_USER:-timberpunk_user}

read -sp "Enter database password: " DB_PASSWORD
echo ""

sudo -u postgres psql <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
ALTER DATABASE $DB_NAME OWNER TO $DB_USER;
\q
EOF

echo -e "${GREEN}✅ Database created${NC}"
echo ""

echo -e "${YELLOW}4. Cloning repository...${NC}"
read -p "Enter GitHub repository URL: " REPO_URL

if [ -d "$APP_DIR" ]; then
    echo "Directory $APP_DIR already exists. Pulling latest changes..."
    cd $APP_DIR
    git pull
else
    sudo mkdir -p $APP_DIR
    sudo chown $USER:$USER $APP_DIR
    git clone $REPO_URL $APP_DIR
fi

cd $BACKEND_DIR

echo -e "${GREEN}✅ Repository cloned${NC}"
echo ""

echo -e "${YELLOW}5. Setting up Python virtual environment...${NC}"
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn

echo -e "${GREEN}✅ Python environment ready${NC}"
echo ""

echo -e "${YELLOW}6. Configuring environment variables...${NC}"

# Generate SECRET_KEY
SECRET_KEY=$(openssl rand -hex 32)

read -p "Enter admin email (default: admin@timberpunk.com): " ADMIN_EMAIL
ADMIN_EMAIL=${ADMIN_EMAIL:-admin@timberpunk.com}

read -sp "Enter admin password: " ADMIN_PASSWORD
echo ""

read -p "Enter frontend URL (e.g., https://timberpunk.com): " FRONTEND_URL
FRONTEND_URL=${FRONTEND_URL:-http://localhost:5173}

cat > $BACKEND_DIR/.env <<EOF
# Database
DATABASE_URL=postgresql://$DB_USER:$DB_PASSWORD@localhost:5432/$DB_NAME

# Security
SECRET_KEY=$SECRET_KEY
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# Admin credentials
ADMIN_EMAIL=$ADMIN_EMAIL
ADMIN_PASSWORD=$ADMIN_PASSWORD

# CORS
FRONTEND_URL=$FRONTEND_URL
EOF

echo -e "${GREEN}✅ Environment configured${NC}"
echo ""

echo -e "${YELLOW}7. Setting up systemd service...${NC}"

sudo tee /etc/systemd/system/$APP_NAME.service > /dev/null <<EOF
[Unit]
Description=TimberPunk FastAPI Application
After=network.target postgresql.service
Requires=postgresql.service

[Service]
Type=notify
User=$APP_USER
Group=$APP_USER
WorkingDirectory=$BACKEND_DIR
Environment="PATH=$BACKEND_DIR/venv/bin"
EnvironmentFile=$BACKEND_DIR/.env
ExecStart=$BACKEND_DIR/venv/bin/gunicorn -c gunicorn.conf.py main:app
Restart=always
RestartSec=10

# Security
NoNewPrivileges=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

sudo chown -R $APP_USER:$APP_USER $BACKEND_DIR
sudo systemctl daemon-reload
sudo systemctl enable $APP_NAME
sudo systemctl start $APP_NAME

echo -e "${GREEN}✅ Service started${NC}"
echo ""

echo -e "${YELLOW}8. Checking service status...${NC}"
sudo systemctl status $APP_NAME --no-pager

echo ""
read -p "Configure Nginx now? (y/n): " SETUP_NGINX

if [ "$SETUP_NGINX" = "y" ]; then
    read -p "Enter your domain (e.g., api.timberpunk.com): " DOMAIN
    
    sudo tee /etc/nginx/sites-available/$APP_NAME > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        
        proxy_connect_timeout 60s;
        proxy_send_timeout 60s;
        proxy_read_timeout 60s;
    }
}
EOF

    sudo ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
    sudo nginx -t
    sudo systemctl restart nginx
    
    echo -e "${GREEN}✅ Nginx configured${NC}"
    echo ""
    
    read -p "Setup SSL with Let's Encrypt? (y/n): " SETUP_SSL
    if [ "$SETUP_SSL" = "y" ]; then
        sudo certbot --nginx -d $DOMAIN
        echo -e "${GREEN}✅ SSL configured${NC}"
    fi
fi

echo ""
echo -e "${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}🎉 Deployment Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════${NC}"
echo ""
echo "📊 Service Status:"
echo "   sudo systemctl status $APP_NAME"
echo ""
echo "📝 View Logs:"
echo "   sudo journalctl -u $APP_NAME -f"
echo ""
echo "🔄 Restart Service:"
echo "   sudo systemctl restart $APP_NAME"
echo ""
echo "🌐 API URL: http://localhost:8000"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""

if [ -n "$DOMAIN" ]; then
    echo "🌍 Public URL: http://$DOMAIN"
fi

echo ""
echo "💾 Database Backup:"
echo "   pg_dump -U $DB_USER $DB_NAME > backup.sql"
echo ""
