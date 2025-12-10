# 🪵 TimberPunk - Full-Stack E-Commerce Website

## Project Overview

A complete e-commerce platform for TimberPunk woodworking studio, featuring product browsing, shopping cart, checkout, and admin management.

## 🚀 Quick Start

### Option 1: Using Startup Scripts (Recommended)

**Terminal 1 - Backend:**
```bash
cd tp_backend
./start.sh
```

**Terminal 2 - Frontend:**
```bash
cd tp_ui
./start.sh
```

### Option 2: Manual Start

**Backend:**
```bash
cd tp_backend
pip install -r requirements.txt
uvicorn main:app --reload
```

**Frontend:**
```bash
cd tp_ui
npm install
npm run dev
```

### Add Sample Data

```bash
cd tp_backend
python seed_data.py
```

## 🌐 Access Points

- **Frontend:** http://localhost:5173
- **Backend API:** http://localhost:8000
- **API Docs:** http://localhost:8000/docs
- **Admin Login:** http://localhost:5173/admin
  - Email: `admin@timberpunk.com`
  - Password: `admin123`

## ✨ Features

### Public Features
- ✅ Homepage with hero section and featured products
- ✅ Product catalog with category filtering
- ✅ Product detail pages with image gallery
- ✅ Custom engraving text input
- ✅ Shopping cart with quantity management
- ✅ Checkout flow with customer information
- ✅ Order confirmation page
- ✅ Responsive mobile-first design
- ✅ Dark/light theme support

### Admin Features
- ✅ Secure JWT authentication
- ✅ Product management (create, read, update, delete)
- ✅ Order management and viewing
- ✅ Order status updates (NEW, IN_PROGRESS, COMPLETED, CANCELED)
- ✅ Product categorization
- ✅ Image URL management
- ✅ Product options (size, wood type, finish)

## 📁 Project Structure

```
timber_punk/
├── tp_backend/                 # Python FastAPI Backend
│   ├── main.py                # Application entry point
│   ├── config.py              # Configuration settings
│   ├── database.py            # Database connection
│   ├── models.py              # SQLAlchemy models
│   ├── schemas.py             # Pydantic schemas
│   ├── auth.py                # Authentication logic
│   ├── routers/               # API route modules
│   │   ├── auth_routes.py    # Login & auth endpoints
│   │   ├── products.py       # Product CRUD endpoints
│   │   └── orders.py         # Order endpoints
│   ├── requirements.txt       # Python dependencies
│   ├── seed_data.py          # Sample data script
│   ├── start.sh              # Startup script
│   ├── .env                  # Environment variables
│   └── README.md
│
└── tp_ui/                     # React TypeScript Frontend
    ├── src/
    │   ├── api/              # API client modules
    │   │   ├── client.ts    # Axios instance
    │   │   ├── auth.ts      # Auth API calls
    │   │   ├── products.ts  # Product API calls
    │   │   └── orders.ts    # Order API calls
    │   ├── components/       # Reusable UI components
    │   │   ├── Header.tsx
    │   │   ├── Footer.tsx
    │   │   └── ProductCard.tsx
    │   ├── context/          # React Context
    │   │   └── CartContext.tsx
    │   ├── pages/            # Page components
    │   │   ├── HomePage.tsx
    │   │   ├── ProductListPage.tsx
    │   │   ├── ProductDetailsPage.tsx
    │   │   ├── CartPage.tsx
    │   │   ├── CheckoutPage.tsx
    │   │   ├── ConfirmationPage.tsx
    │   │   ├── AdminLoginPage.tsx
    │   │   └── AdminDashboardPage.tsx
    │   ├── types.ts          # TypeScript interfaces
    │   ├── App.tsx           # Main app with routing
    │   ├── main.tsx          # Entry point
    │   └── index.css         # Global styles
    ├── package.json
    ├── vite.config.ts
    ├── start.sh              # Startup script
    └── README.md
```

## 🛠 Tech Stack

### Backend
- **FastAPI** - Modern, fast Python web framework
- **PostgreSQL** - Robust relational database
- **SQLAlchemy** - Python ORM
- **Pydantic** - Data validation
- **JWT** - Secure authentication
- **Uvicorn** - ASGI server
- **Passlib** - Password hashing

### Frontend
- **React 18** - UI library
- **TypeScript** - Type-safe JavaScript
- **Vite** - Lightning-fast build tool
- **React Router v6** - Client-side routing
- **Axios** - HTTP client
- **Context API** - Global state (cart)
- **CSS Variables** - Themeable styling

## 📊 Database Schema

### Products
- id, name, description, short_description
- price, category, image_url, options
- created_at, updated_at

### Orders
- id, first_name, last_name, email, phone
- shipping_address, note, status, total
- created_at, updated_at

### Order Items
- id, order_id, product_id
- product_name, product_price, quantity
- selected_options, custom_engraving

### Admins
- id, email, hashed_password, created_at

## 🔐 API Endpoints

### Public Endpoints
```
GET    /products              # List all products
GET    /products/{id}         # Get product by ID
POST   /orders                # Create order (checkout)
```

### Admin Endpoints (requires auth token)
```
POST   /auth/login            # Admin login
GET    /auth/me               # Get current admin

POST   /products              # Create product
PUT    /products/{id}         # Update product
DELETE /products/{id}         # Delete product

GET    /orders                # List all orders
GET    /orders/{id}           # Get order by ID
PATCH  /orders/{id}           # Update order status
```

## 🎨 Design Features

- **Mobile-First Design** - Fully responsive on all devices
- **Dark/Light Mode** - Automatic theme based on system preferences
- **Modern UI** - Clean, professional woodworking aesthetic
- **Smooth Animations** - Hover effects and transitions
- **Accessible** - Semantic HTML and proper form labels
- **Optimized Images** - Using placeholder images from Unsplash

## 🔄 User Flows

### Customer Purchase Flow
1. Browse products on homepage or products page
2. Click product to view details
3. Select options and add custom engraving
4. Add to cart
5. Review cart and adjust quantities
6. Proceed to checkout
7. Fill customer information and shipping details
8. Submit order
9. View confirmation with order number

### Admin Management Flow
1. Navigate to `/admin`
2. Login with credentials
3. View dashboard with products and orders tabs
4. **Products Tab:**
   - View all products in table
   - Add new product with form
   - Edit existing product
   - Delete product
5. **Orders Tab:**
   - View all orders in list
   - Click order to see details
   - Update order status
   - View customer information and items

## 🚧 Future Enhancements

### Potential Features
- [ ] Payment integration (Stripe/PayPal)
- [ ] Email notifications for orders
- [ ] Image upload for products
- [ ] Product reviews and ratings
- [ ] Inventory management
- [ ] Discount codes and promotions
- [ ] Order tracking
- [ ] Multi-image galleries per product
- [ ] Search functionality
- [ ] Wishlist/favorites
- [ ] Customer accounts
- [ ] Analytics dashboard

## 🐛 Troubleshooting

### Backend Issues
- **Database connection error:** Ensure PostgreSQL is running
- **Module not found:** Run `pip install -r requirements.txt`
- **Port 8000 in use:** Change port or kill the process

### Frontend Issues
- **Module errors:** Delete `node_modules` and run `npm install`
- **API connection error:** Ensure backend is running on port 8000
- **Port 5173 in use:** Vite will automatically use next available port

## 📝 Environment Variables

### Backend (.env)
```env
DATABASE_URL=postgresql://postgres:postgres@localhost:5432/timberpunk
SECRET_KEY=your-secret-key-here
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30
ADMIN_EMAIL=admin@timberpunk.com
ADMIN_PASSWORD=admin123
FRONTEND_URL=http://localhost:5173
```

### Frontend (.env)
```env
VITE_API_URL=http://localhost:8000
```

## 📄 License

Private project for TimberPunk woodworking studio.

## 🤝 Contributing

This is a custom project for TimberPunk. For modifications or support, please contact the development team.

---

**Built with ❤️ for TimberPunk Woodworking Studio**

🪵 Handcrafted code for handcrafted wood products
