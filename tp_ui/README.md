# TimberPunk Frontend

React + TypeScript frontend for the TimberPunk e-commerce website.

## Setup

1. **Install dependencies**
   ```bash
   npm install
   ```

2. **Start the development server**
   ```bash
   npm run dev
   ```

   The app will be available at `http://localhost:5173`

3. **Build for production**
   ```bash
   npm run build
   ```

## Features

### Public Pages
- **Homepage** - Hero section, featured products, about section
- **Products** - List all products with category filtering
- **Product Details** - View product with options for custom engraving
- **Cart** - Shopping cart with quantity management
- **Checkout** - Order form with customer information
- **Confirmation** - Order success page

### Admin Pages
- **Admin Login** - `/admin` - Login with credentials
- **Admin Dashboard** - `/admin/dashboard` - Manage products and orders

Default admin credentials:
- Email: `admin@timberpunk.com`
- Password: `admin123`

## Project Structure

```
src/
├── api/              # API client functions
│   ├── client.ts     # Axios instance
│   ├── auth.ts       # Authentication API
│   ├── products.ts   # Products API
│   └── orders.ts     # Orders API
├── components/       # Reusable components
│   ├── Header.tsx
│   ├── Footer.tsx
│   └── ProductCard.tsx
├── context/          # React context
│   └── CartContext.tsx
├── pages/            # Page components
│   ├── HomePage.tsx
│   ├── ProductListPage.tsx
│   ├── ProductDetailsPage.tsx
│   ├── CartPage.tsx
│   ├── CheckoutPage.tsx
│   ├── ConfirmationPage.tsx
│   ├── AdminLoginPage.tsx
│   └── AdminDashboardPage.tsx
├── types.ts          # TypeScript interfaces
├── App.tsx           # Main app with routing
├── main.tsx          # Entry point
└── index.css         # Global styles
```

## Environment Variables

Create a `.env` file for custom configuration:

```
VITE_API_URL=http://localhost:8000
```

## Technologies

- **React 18** - UI library
- **TypeScript** - Type safety
- **Vite** - Build tool and dev server
- **React Router** - Client-side routing
- **Axios** - HTTP client
- **Context API** - State management (cart)
- **CSS** - Styling with CSS variables for theming

## Notes

- The cart is persisted in localStorage
- JWT tokens are stored in localStorage for admin authentication
- The app supports light and dark themes based on system preferences
- Responsive design works on mobile and desktop
