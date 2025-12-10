import React from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useCart } from '../context/CartContext';

const CartPage: React.FC = () => {
  const { items, removeFromCart, updateQuantity, getTotal, clearCart } = useCart();
  const navigate = useNavigate();

  if (items.length === 0) {
    return (
      <div className="container" style={{ marginTop: '3rem', textAlign: 'center' }}>
        <h1>Your Cart is Empty</h1>
        <p style={{ margin: '2rem 0' }}>Add some amazing wood products to get started!</p>
        <Link to="/products">
          <button className="btn btn-primary">Shop Products</button>
        </Link>
      </div>
    );
  }

  return (
    <div className="container" style={{ marginTop: '2rem' }}>
      <h1 className="mb-4">Shopping Cart</h1>

      <div style={{ display: 'grid', gridTemplateColumns: '2fr 1fr', gap: '2rem' }}>
        {/* Cart Items */}
        <div>
          {items.map((item) => (
            <div
              key={item.product.id}
              style={{
                display: 'flex',
                gap: '1.5rem',
                padding: '1.5rem',
                backgroundColor: 'var(--bg-secondary)',
                borderRadius: '8px',
                marginBottom: '1rem',
              }}
            >
              <img
                src={item.product.image_url || 'https://via.placeholder.com/120x120?text=Wood'}
                alt={item.product.name}
                style={{ width: '120px', height: '120px', objectFit: 'cover', borderRadius: '4px' }}
              />
              <div style={{ flex: 1 }}>
                <h3>{item.product.name}</h3>
                <p style={{ color: 'var(--text-secondary)', marginTop: '0.25rem' }}>
                  {item.product.category}
                </p>
                <p className="price" style={{ marginTop: '0.5rem' }}>
                  ${item.product.price.toFixed(2)}
                </p>
                {item.selected_options && (
                  <p style={{ fontSize: '0.875rem', marginTop: '0.5rem' }}>
                    Options: {item.selected_options}
                  </p>
                )}
                {item.custom_engraving && (
                  <p style={{ fontSize: '0.875rem', marginTop: '0.25rem' }}>
                    Engraving: "{item.custom_engraving}"
                  </p>
                )}
              </div>
              <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '1rem' }}>
                <div style={{ display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                  <button
                    onClick={() => updateQuantity(item.product.id, item.quantity - 1)}
                    style={{ padding: '0.25rem 0.75rem', fontSize: '1rem' }}
                    className="btn btn-secondary"
                  >
                    -
                  </button>
                  <span style={{ minWidth: '40px', textAlign: 'center' }}>{item.quantity}</span>
                  <button
                    onClick={() => updateQuantity(item.product.id, item.quantity + 1)}
                    style={{ padding: '0.25rem 0.75rem', fontSize: '1rem' }}
                    className="btn btn-secondary"
                  >
                    +
                  </button>
                </div>
                <p style={{ fontWeight: '600', fontSize: '1.125rem' }}>
                  ${(item.product.price * item.quantity).toFixed(2)}
                </p>
                <button
                  onClick={() => removeFromCart(item.product.id)}
                  className="btn btn-danger"
                  style={{ fontSize: '0.875rem', padding: '0.5rem 1rem' }}
                >
                  Remove
                </button>
              </div>
            </div>
          ))}
        </div>

        {/* Order Summary */}
        <div>
          <div
            style={{
              backgroundColor: 'var(--bg-secondary)',
              padding: '2rem',
              borderRadius: '8px',
              position: 'sticky',
              top: '100px',
            }}
          >
            <h2 style={{ marginBottom: '1.5rem' }}>Order Summary</h2>
            <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '1rem' }}>
              <span>Subtotal:</span>
              <span>${getTotal().toFixed(2)}</span>
            </div>
            <div
              style={{
                display: 'flex',
                justifyContent: 'space-between',
                marginBottom: '1.5rem',
                paddingTop: '1rem',
                borderTop: '1px solid var(--border)',
                fontSize: '1.25rem',
                fontWeight: '700',
              }}
            >
              <span>Total:</span>
              <span>${getTotal().toFixed(2)}</span>
            </div>
            <button
              className="btn btn-primary"
              style={{ width: '100%', marginBottom: '1rem' }}
              onClick={() => navigate('/checkout')}
            >
              Proceed to Checkout
            </button>
            <button
              className="btn btn-secondary"
              style={{ width: '100%' }}
              onClick={() => {
                if (window.confirm('Are you sure you want to clear your cart?')) {
                  clearCart();
                }
              }}
            >
              Clear Cart
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CartPage;
