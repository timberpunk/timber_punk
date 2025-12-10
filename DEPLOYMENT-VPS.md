# TimberPunk VPS Deployment Guide (No Docker)

## 🖥️ VPS Requirements

- Ubuntu 22.04 LTS or newer
- Minimum 1GB RAM
- 10GB+ disk space
- SSH access with sudo privileges

---

## 🚀 Quick Deployment

### Automated Script (Recommended)

1. **SSH into your VPS**
   ```bash
   ssh your-user@your-vps-ip
   ```

2. **Download and run deployment script**
   ```bash
   wget https://raw.githubusercontent.com/timberpunk/timber_punk/main/deploy-vps.sh
   chmod +x deploy-vps.sh
   sudo ./deploy-vps.sh
   ```

   The script will:
   - ✅ Install all dependencies
   - ✅ Setup PostgreSQL database
   - ✅ Clone your repository
   - ✅ Configure Python environment
   - ✅ Create systemd service
   - ✅ Configure Nginx
   - ✅ Setup SSL (optional)

---

## 📋 Manual Deployment Steps

### 1. Install Dependencies

```bash
sudo apt update && sudo apt upgrade -y

sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    postgresql \
    postgresql-contrib \
    nginx \
    git \
    certbot \
    python3-certbot-nginx
```

### 2. Setup PostgreSQL

```bash
# Switch to postgres user
sudo -u postgres psql

# In PostgreSQL console:
CREATE DATABASE timberpunk;
CREATE USER timberpunk_user WITH PASSWORD 'your_secure_password';
GRANT ALL PRIVILEGES ON DATABASE timberpunk TO timberpunk_user;
ALTER DATABASE timberpunk OWNER TO timberpunk_user;
\q
```

### 3. Clone Repository

```bash
cd /var/www
sudo git clone https://github.com/timberpunk/tp_backend.git timberpunk
cd timberpunk/tp_backend
```

### 4. Setup Python Environment

```bash
python3 -m venv venv
source venv/bin/activate
pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn
```

### 5. Configure Environment

```bash
nano .env
```

Add:
```bash
DATABASE_URL=postgresql://timberpunk_user:your_password@localhost:5432/timberpunk
SECRET_KEY=your-secret-key-from-openssl-rand-hex-32
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ADMIN_EMAIL=admin@timberpunk.com
ADMIN_PASSWORD=your_admin_password
FRONTEND_URL=https://timberpunk.com
```

Generate SECRET_KEY:
```bash
openssl rand -hex 32
```

### 6. Test Backend

```bash
source venv/bin/activate
gunicorn -c gunicorn.conf.py main:app
```

Open another terminal and test:
```bash
curl http://localhost:8000
```

Should return: `{"message":"TimberPunk API is running"}`

### 7. Setup Systemd Service

```bash
sudo nano /etc/systemd/system/timberpunk.service
```

Paste the content from `timberpunk.service` file.

Then:
```bash
sudo systemctl daemon-reload
sudo systemctl enable timberpunk
sudo systemctl start timberpunk
sudo systemctl status timberpunk
```

### 8. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/timberpunk
```

Paste the content from `nginx.conf` file (update domain name).

Then:
```bash
sudo ln -s /etc/nginx/sites-available/timberpunk /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 9. Setup SSL (Let's Encrypt)

```bash
sudo certbot --nginx -d api.timberpunk.com
```

Follow the prompts. Certbot will automatically configure SSL.

### 10. Configure Firewall

```bash
sudo ufw allow 22    # SSH
sudo ufw allow 80    # HTTP
sudo ufw allow 443   # HTTPS
sudo ufw enable
```

---

## 🔄 Common Operations

### View Logs
```bash
# Service logs
sudo journalctl -u timberpunk -f

# Nginx logs
sudo tail -f /var/log/nginx/timberpunk-error.log
sudo tail -f /var/log/nginx/timberpunk-access.log
```

### Restart Service
```bash
sudo systemctl restart timberpunk
```

### Update Code
```bash
cd /var/www/timberpunk/tp_backend
git pull
source venv/bin/activate
pip install -r requirements.txt
sudo systemctl restart timberpunk
```

### Database Backup
```bash
pg_dump -U timberpunk_user timberpunk > backup-$(date +%Y%m%d).sql
```

### Database Restore
```bash
psql -U timberpunk_user timberpunk < backup.sql
```

---

## 🛡️ Security Best Practices

### 1. Change Default SSH Port
```bash
sudo nano /etc/ssh/sshd_config
# Change: Port 22 → Port 2222
sudo systemctl restart sshd
```

### 2. Disable Root Login
```bash
sudo nano /etc/ssh/sshd_config
# Set: PermitRootLogin no
sudo systemctl restart sshd
```

### 3. Setup Fail2Ban
```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

### 4. Regular Updates
```bash
sudo apt update && sudo apt upgrade -y
```

### 5. Database Backups (Automated)
```bash
# Create backup script
sudo nano /usr/local/bin/backup-db.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/var/backups/timberpunk"
DATE=$(date +%Y%m%d_%H%M%S)
mkdir -p $BACKUP_DIR
pg_dump -U timberpunk_user timberpunk | gzip > $BACKUP_DIR/backup_$DATE.sql.gz
# Keep only last 7 days
find $BACKUP_DIR -name "backup_*.sql.gz" -mtime +7 -delete
```

```bash
sudo chmod +x /usr/local/bin/backup-db.sh

# Add to crontab (daily at 2 AM)
sudo crontab -e
# Add: 0 2 * * * /usr/local/bin/backup-db.sh
```

---

## 📊 Monitoring

### Check Service Status
```bash
sudo systemctl status timberpunk
```

### Check if API is responding
```bash
curl http://localhost:8000
curl https://api.timberpunk.com
```

### Database Connections
```bash
sudo -u postgres psql timberpunk
# In psql:
SELECT * FROM pg_stat_activity WHERE datname = 'timberpunk';
```

---

## 🆘 Troubleshooting

### Service won't start
```bash
# Check logs
sudo journalctl -u timberpunk -n 50

# Check if port is in use
sudo lsof -i :8000

# Test manually
cd /var/www/timberpunk/tp_backend
source venv/bin/activate
gunicorn -c gunicorn.conf.py main:app
```

### Database connection errors
```bash
# Test connection
psql -U timberpunk_user -d timberpunk -h localhost

# Check PostgreSQL is running
sudo systemctl status postgresql

# Check pg_hba.conf
sudo nano /etc/postgresql/14/main/pg_hba.conf
```

### Nginx errors
```bash
# Test configuration
sudo nginx -t

# Check logs
sudo tail -f /var/log/nginx/error.log
```

---

## 📱 Deploy Frontend

### Build Frontend Locally
```bash
cd tp_ui
npm install
npm run build
```

### Upload to Server
```bash
scp -r dist/* user@your-vps:/var/www/timberpunk/frontend/
```

### Configure Nginx for Frontend
```bash
sudo nano /etc/nginx/sites-available/timberpunk-frontend
```

```nginx
server {
    listen 80;
    server_name timberpunk.com;
    root /var/www/timberpunk/frontend;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    location /api {
        proxy_pass http://127.0.0.1:8000;
    }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/timberpunk-frontend /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 💡 Performance Optimization

### 1. Increase Gunicorn Workers
Edit `gunicorn.conf.py`:
```python
workers = (2 * cpu_cores) + 1  # e.g., 4 cores = 9 workers
```

### 2. Enable Nginx Caching
```nginx
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m max_size=1g;
```

### 3. Database Connection Pooling
Already configured in SQLAlchemy settings.

---

## 📞 Support

For issues:
1. Check logs: `sudo journalctl -u timberpunk -f`
2. Verify database connection
3. Test API manually: `curl http://localhost:8000`
4. Check Nginx configuration: `sudo nginx -t`

Happy deploying! 🚀
