# 🪵 TimberPunk - Getting Started Checklist

Use this checklist to set up and run your TimberPunk e-commerce website!

## ✅ Prerequisites

- [ ] Python 3.9 or higher installed
- [ ] Node.js 18 or higher installed  
- [ ] PostgreSQL installed and running
- [ ] Git installed (optional, for version control)

## ✅ Initial Setup

### Database
- [ ] PostgreSQL service is running
- [ ] Created database: `createdb timberpunk`
- [ ] Database connection works (test with `psql timberpunk`)

### Backend Setup
- [ ] Navigate to `tp_backend` directory
- [ ] Install Python dependencies: `pip install -r requirements.txt`
- [ ] Verify `.env` file exists with correct settings
- [ ] Start backend: `uvicorn main:app --reload`
- [ ] Backend is running at http://localhost:8000
- [ ] Can access API docs at http://localhost:8000/docs
- [ ] (Optional) Run seed script: `python seed_data.py`

### Frontend Setup
- [ ] Navigate to `tp_ui` directory
- [ ] Install Node dependencies: `npm install`
- [ ] Start frontend: `npm run dev`
- [ ] Frontend is running at http://localhost:5173

## ✅ Testing the Application

### Public Features
- [ ] Homepage loads correctly
- [ ] Can navigate to Products page
- [ ] Products are displayed (if you ran seed_data.py)
- [ ] Can click on a product to view details
- [ ] Can add a product to cart
- [ ] Cart icon shows item count
- [ ] Can view cart page
- [ ] Can adjust quantities in cart
- [ ] Can proceed to checkout
- [ ] Can fill out checkout form
- [ ] Order creates successfully
- [ ] Confirmation page shows order number

### Admin Features
- [ ] Can navigate to `/admin`
- [ ] Can login with credentials:
  - Email: admin@timberpunk.com
  - Password: admin123
- [ ] Admin dashboard loads
- [ ] Can view Products tab
- [ ] Can create a new product
- [ ] Can edit an existing product
- [ ] Can delete a product
- [ ] Can view Orders tab
- [ ] Can click on an order to view details
- [ ] Can update order status

## ✅ Next Steps

### Customization
- [ ] Change admin password in `.env`
- [ ] Add your own product images
- [ ] Customize colors in `tp_ui/src/index.css`
- [ ] Update business information in Footer
- [ ] Add your logo/branding

### Production Preparation
- [ ] Change `SECRET_KEY` in `.env` to a secure random value
- [ ] Update database to production database
- [ ] Set up proper CORS origins
- [ ] Build frontend: `npm run build`
- [ ] Test production build
- [ ] Choose hosting provider (Vercel, Railway, etc.)
- [ ] Set up domain name
- [ ] Configure SSL/HTTPS
- [ ] Set up email notifications (optional)
- [ ] Add payment processing (optional)

## 🐛 Troubleshooting

If something doesn't work:

### Backend Issues
- [ ] Check PostgreSQL is running: `brew services list` or `sudo service postgresql status`
- [ ] Check database exists: `psql -l | grep timberpunk`
- [ ] Check Python packages installed: `pip list`
- [ ] Check `.env` file has correct values
- [ ] Check backend logs in terminal for errors
- [ ] Try restarting backend server

### Frontend Issues
- [ ] Check `node_modules` exists: `ls -la node_modules`
- [ ] Try deleting and reinstalling: `rm -rf node_modules && npm install`
- [ ] Check backend is running and accessible
- [ ] Check browser console for errors (F12)
- [ ] Try clearing browser cache
- [ ] Try restarting frontend server

### Database Issues
- [ ] Verify PostgreSQL is running
- [ ] Check connection string in `.env`
- [ ] Try connecting manually: `psql timberpunk`
- [ ] Check database has tables: `\dt` in psql
- [ ] Try recreating database: `dropdb timberpunk && createdb timberpunk`

## 📚 Resources

- **Setup Guide:** [SETUP_GUIDE.md](SETUP_GUIDE.md)
- **Project Documentation:** [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
- **Backend Docs:** http://localhost:8000/docs (when running)
- **FastAPI Docs:** https://fastapi.tiangolo.com/
- **React Docs:** https://react.dev/
- **PostgreSQL Docs:** https://www.postgresql.org/docs/

## 🎉 Success!

Once all items are checked, you have a fully functional e-commerce website!

### Quick Start Commands

**Start Backend:**
```bash
cd tp_backend
./start.sh
```

**Start Frontend (new terminal):**
```bash
cd tp_ui  
./start.sh
```

**Add Sample Data:**
```bash
cd tp_backend
python seed_data.py
```

---

**Happy coding! 🪵✨**
