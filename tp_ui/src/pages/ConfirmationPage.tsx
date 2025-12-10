import React from 'react';
import { Link, useLocation } from 'react-router-dom';

const ConfirmationPage: React.FC = () => {
  const location = useLocation();
  const orderId = location.state?.orderId;

  return (
    <div className="container" style={{ marginTop: '3rem', textAlign: 'center', maxWidth: '600px' }}>
      <div style={{ fontSize: '4rem', marginBottom: '1rem' }}>✅</div>
      <h1 style={{ marginBottom: '1rem' }}>Order Confirmed!</h1>
      <p style={{ fontSize: '1.125rem', marginBottom: '2rem', color: 'var(--text-secondary)' }}>
        Thank you for your order! We'll start crafting your custom wood products right away.
      </p>
      {orderId && (
        <p style={{ marginBottom: '2rem' }}>
          Your order number is: <strong>#{orderId}</strong>
        </p>
      )}
      <p style={{ marginBottom: '3rem' }}>
        You will receive a confirmation email shortly with your order details.
      </p>
      <Link to="/products">
        <button className="btn btn-primary">Continue Shopping</button>
      </Link>
    </div>
  );
};

export default ConfirmationPage;
