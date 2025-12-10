# 🪵 TimberPunk - E-Commerce Website

> A complete full-stack e-commerce platform for TimberPunk woodworking studio

![Tech Stack](https://img.shields.io/badge/FastAPI-009688?style=for-the-badge&logo=fastapi&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![React](https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB)
![TypeScript](https://img.shields.io/badge/TypeScript-007ACC?style=for-the-badge&logo=typescript&logoColor=white)

## 📖 Documentation

- **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Detailed setup instructions
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Complete project documentation
- **[tp_backend/README.md](tp_backend/README.md)** - Backend documentation
- **[tp_ui/README.md](tp_ui/README.md)** - Frontend documentation

## 🚀 Quick Start

### Prerequisites
- Python 3.9+
- Node.js 18+
- PostgreSQL

### 1. Setup Database
```bash
createdb timberpunk
```

### 2. Start Backend
```bash
cd tp_backend
./start.sh
# Or manually:
# pip install -r requirements.txt
# uvicorn main:app --reload
```

### 3. Start Frontend (in new terminal)
```bash
cd tp_ui
./start.sh
# Or manually:
# npm install
# npm run dev
```

### 4. Add Sample Data (Optional)
```bash
cd tp_backend
python seed_data.py
```

## 🌐 Access the Application

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Admin Panel:** http://localhost:5173/admin
  - Email: `admin@timberpunk.com`
  - Password: `admin123`

## ✨ Features

### 🛍️ Customer Features
- Browse and filter products by category
- View detailed product information with images
- Add items to cart with custom engraving
- Checkout with customer information
- Order confirmation

### 👨‍💼 Admin Features
- Secure JWT authentication
- Full product management (CRUD)
- Order tracking and status updates
- Modern responsive dashboard

## 📁 Project Structure

```
timber_punk/
├── tp_backend/          # FastAPI Backend
│   ├── main.py         # Entry point
│   ├── models.py       # Database models
│   ├── routers/        # API endpoints
│   └── seed_data.py    # Sample data
│
└── tp_ui/              # React Frontend
    ├── src/
    │   ├── api/        # API clients
    │   ├── pages/      # Page components
    │   └── components/ # UI components
    └── package.json
```

## 🛠️ Tech Stack

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
- Context API - State management

## 📊 API Endpoints

### Public
```
GET    /products        List all products
GET    /products/{id}   Get product details
POST   /orders          Create order
```

### Admin (Auth Required)
```
POST   /auth/login      Admin login
POST   /products        Create product
PUT    /products/{id}   Update product
DELETE /products/{id}   Delete product
GET    /orders          List orders
PATCH  /orders/{id}     Update order status
```

## 🎨 Screenshots & Features

- ✅ Responsive mobile-first design
- ✅ Dark/light theme support
- ✅ Shopping cart with local storage
- ✅ Custom product engraving
- ✅ Admin dashboard
- ✅ Order management
- ✅ Category filtering

## 🔐 Security

- JWT token-based authentication
- Password hashing with bcrypt
- CORS protection
- SQL injection prevention via ORM
- Input validation with Pydantic

## 🚧 Future Enhancements

- [ ] Payment integration (Stripe)
- [ ] Email notifications
- [ ] Image upload functionality
- [ ] Product reviews
- [ ] Inventory tracking
- [ ] Analytics dashboard
- [ ] Customer accounts

## 📝 License

Private project for TimberPunk woodworking studio.

---

**Made with ❤️ for handcrafted wood products**
