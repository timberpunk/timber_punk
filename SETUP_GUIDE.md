# 🪵 TimberPunk E-Commerce - Setup Guide

This guide will walk you through setting up both the backend and frontend.

## Prerequisites

- **Python 3.9+** - [Download](https://www.python.org/downloads/)
- **Node.js 18+** - [Download](https://nodejs.org/)
- **PostgreSQL** - [Download](https://www.postgresql.org/download/)

## Step-by-Step Setup

### 1. Database Setup

First, install and start PostgreSQL:

**macOS (using Homebrew):**
```bash
brew install postgresql
brew services start postgresql
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get install postgresql postgresql-contrib
sudo service postgresql start
```

**Windows:**
Download and install from [postgresql.org](https://www.postgresql.org/download/windows/)

Then create the database:
```bash
createdb timberpunk
```

If you need to create a PostgreSQL user:
```bash
psql postgres
CREATE USER postgres WITH PASSWORD 'postgres';
ALTER USER postgres CREATEDB;
\q
```

### 2. Backend Setup (FastAPI)

Navigate to backend directory:
```bash
cd tp_backend
```

Install Python dependencies:
```bash
pip install -r requirements.txt
```

The `.env` file is already configured with default settings. Start the backend:
```bash
uvicorn main:app --reload
```

The API should now be running at `http://localhost:8000`
- API Documentation: `http://localhost:8000/docs`
- Alternative Docs: `http://localhost:8000/redoc`

#### Seed Sample Data (Optional)

To populate the database with sample products, run:
```bash
python seed_data.py
```

This will create 6 sample products with images and details.

### 3. Frontend Setup (React + Vite)

Open a new terminal and navigate to frontend directory:
```bash
cd tp_ui
```

Install Node dependencies:
```bash
npm install
```

Start the development server:
```bash
npm run dev
```

The frontend should now be running at `http://localhost:5173`

## 🎉 You're All Set!

Open your browser and visit:
- **Frontend:** http://localhost:5173
- **Backend API Docs:** http://localhost:8000/docs

### Default Admin Credentials

- **Email:** admin@timberpunk.com
- **Password:** admin123

⚠️ **Important:** Change these credentials in production!

## Testing the Application

1. **Browse Products:** Visit the homepage and click "Shop All Products"
2. **Add to Cart:** Click on a product, add custom engraving, and add to cart
3. **Checkout:** Complete the checkout form to create an order
4. **Admin Dashboard:** 
   - Go to `/admin`
   - Login with the credentials above
   - Manage products and view orders

## Project Structure

```
timber_punk/
├── tp_backend/          # FastAPI Backend
│   ├── main.py         # Entry point
│   ├── models.py       # Database models
│   ├── schemas.py      # Pydantic schemas
│   ├── auth.py         # Authentication logic
│   ├── database.py     # Database connection
│   ├── config.py       # Configuration
│   ├── routers/        # API routes
│   │   ├── auth_routes.py
│   │   ├── products.py
│   │   └── orders.py
│   └── seed_data.py    # Sample data script
│
└── tp_ui/              # React Frontend
    ├── src/
    │   ├── api/        # API client functions
    │   ├── components/ # Reusable components
    │   ├── context/    # React context (cart)
    │   ├── pages/      # Page components
    │   ├── types.ts    # TypeScript types
    │   ├── App.tsx     # Main app component
    │   └── main.tsx    # Entry point
    └── package.json
```

## Common Issues & Solutions

### Backend Issues

**"Connection refused" when starting backend:**
- Make sure PostgreSQL is running: `brew services list` (macOS) or `sudo service postgresql status` (Linux)
- Check if the database exists: `psql -l`

**"ModuleNotFoundError":**
- Make sure you installed all dependencies: `pip install -r requirements.txt`
- Consider using a virtual environment: `python -m venv venv && source venv/bin/activate`

### Frontend Issues

**TypeScript errors about missing modules:**
- Delete `node_modules` and reinstall: `rm -rf node_modules && npm install`
- The errors you see are just linting warnings - the app will still run

**"Network Error" when calling API:**
- Make sure the backend is running on port 8000
- Check the console for CORS errors

## Next Steps

### For Development

1. **Customize the styling** - Edit `tp_ui/src/index.css`
2. **Add more product categories** - Update the category filter logic
3. **Add payment integration** - Integrate Stripe or PayPal
4. **Add email notifications** - Use SendGrid or similar service
5. **Add image upload** - Integrate with Cloudinary or AWS S3

### For Production

1. **Change admin credentials** - Update `.env` file
2. **Use production database** - Update `DATABASE_URL` in `.env`
3. **Build frontend** - Run `npm run build` in `tp_ui`
4. **Deploy** - Consider Vercel (frontend) + Railway/Heroku (backend)
5. **Add HTTPS** - Use Let's Encrypt or Cloudflare
6. **Set up monitoring** - Use Sentry, LogRocket, or similar

## Features Implemented

### Public Features ✅
- Homepage with hero section and featured products
- Product listing with category filtering
- Product details with custom engraving
- Shopping cart with quantity management
- Checkout with customer information
- Order confirmation

### Admin Features ✅
- Admin login with JWT authentication
- Product management (CRUD operations)
- Order management
- Order status updates
- Responsive dashboard

## Tech Stack

**Backend:**
- FastAPI - Modern Python web framework
- PostgreSQL - Relational database
- SQLAlchemy - ORM
- JWT - Authentication
- Pydantic - Data validation

**Frontend:**
- React 18 - UI library
- TypeScript - Type safety
- Vite - Build tool
- React Router - Routing
- Axios - HTTP client
- Context API - State management

## Support

If you encounter any issues, check:
1. All services are running (PostgreSQL, backend, frontend)
2. Environment variables are set correctly
3. Dependencies are installed
4. Ports 8000 and 5173 are not in use by other applications

Enjoy building with TimberPunk! 🪵✨
