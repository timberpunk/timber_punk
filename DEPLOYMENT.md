# TimberPunk Backend - Production Deployment Guide

## 🚀 Deployment Options

### Option 1: Docker (Recommended)

1. **Install Docker & Docker Compose**
   ```bash
   # On Ubuntu
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

2. **Setup Environment**
   ```bash
   cd /path/to/timber_punk
   cp .env.docker.example .env.docker
   nano .env.docker  # Edit with your values
   ```

3. **Generate Secret Key**
   ```bash
   openssl rand -hex 32
   # Copy output to .env.docker SECRET_KEY
   ```

4. **Deploy**
   ```bash
   docker-compose --env-file .env.docker up -d
   ```

5. **Check Status**
   ```bash
   docker-compose ps
   docker-compose logs -f backend
   ```

---

### Option 2: VPS Manual Setup

1. **Install Dependencies**
   ```bash
   sudo apt update
   sudo apt install python3-pip python3-venv postgresql nginx certbot
   ```

2. **Setup PostgreSQL**
   ```bash
   sudo -u postgres createdb timberpunk
   sudo -u postgres createuser timberpunk_user -P
   # Enter password when prompted
   ```

3. **Clone & Setup**
   ```bash
   cd /var/www
   git clone https://github.com/timberpunk/tp_backend.git timberpunk
   cd timberpunk/tp_backend
   python3 -m venv venv
   source venv/bin/activate
   pip install -r requirements.txt
   pip install gunicorn
   ```

4. **Configure .env**
   ```bash
   cp .env .env.production
   nano .env.production
   # Update DATABASE_URL, SECRET_KEY, etc.
   ```

5. **Setup Systemd Service**
   ```bash
   sudo cp timberpunk.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable timberpunk
   sudo systemctl start timberpunk
   ```

6. **Setup Nginx**
   ```bash
   sudo cp nginx.conf /etc/nginx/sites-available/timberpunk
   sudo ln -s /etc/nginx/sites-available/timberpunk /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

7. **Setup SSL (Let's Encrypt)**
   ```bash
   sudo certbot --nginx -d api.timberpunk.com
   ```

---

### Option 3: Heroku

1. **Install Heroku CLI**
   ```bash
   curl https://cli-assets.heroku.com/install.sh | sh
   ```

2. **Login & Create App**
   ```bash
   heroku login
   cd tp_backend
   heroku create timberpunk-api
   ```

3. **Add PostgreSQL**
   ```bash
   heroku addons:create heroku-postgresql:mini
   ```

4. **Set Environment Variables**
   ```bash
   heroku config:set SECRET_KEY=$(openssl rand -hex 32)
   heroku config:set ADMIN_EMAIL=admin@timberpunk.com
   heroku config:set ADMIN_PASSWORD=your_password
   ```

5. **Deploy**
   ```bash
   git push heroku main
   ```

---

### Option 4: Render.com

1. Go to [render.com](https://render.com)
2. Connect GitHub repository
3. Create new "Web Service"
4. Settings:
   - **Build Command**: `pip install -r requirements.txt && pip install gunicorn`
   - **Start Command**: `gunicorn -c gunicorn.conf.py main:app`
5. Add PostgreSQL database
6. Set environment variables in dashboard
7. Deploy!

---

## 🔒 Security Checklist

- [ ] Change SECRET_KEY (use `openssl rand -hex 32`)
- [ ] Use strong database password
- [ ] Change admin password
- [ ] Enable HTTPS/SSL
- [ ] Update CORS settings in main.py
- [ ] Set up firewall (UFW)
- [ ] Regular backups
- [ ] Monitor logs

---

## 📊 Monitoring

### Check Application Status
```bash
# Docker
docker-compose logs -f backend

# Systemd
sudo systemctl status timberpunk
sudo journalctl -u timberpunk -f

# Heroku
heroku logs --tail
```

### Database Backup
```bash
# Docker
docker-compose exec db pg_dump -U timberpunk_user timberpunk > backup.sql

# Manual
pg_dump -U timberpunk_user timberpunk > backup.sql
```

---

## 🔄 Updates

### Docker
```bash
git pull
docker-compose down
docker-compose build
docker-compose up -d
```

### Manual
```bash
cd /var/www/timberpunk/tp_backend
git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart timberpunk
```

---

## 🆘 Troubleshooting

### Check if service is running
```bash
curl http://localhost:8000/
```

### Check database connection
```bash
psql -U timberpunk_user -d timberpunk -h localhost
```

### View logs
```bash
tail -f /var/log/nginx/timberpunk-error.log
```

---

## 📞 Support

For issues, check logs and ensure:
- Database is running
- Environment variables are set
- Firewall allows port 8000 (or 80/443)
- SSL certificates are valid
