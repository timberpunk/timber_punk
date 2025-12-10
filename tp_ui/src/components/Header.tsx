import React from 'react';
import { Link } from 'react-router-dom';
import { useCart } from '../context/CartContext';
import { useTranslation } from 'react-i18next';
import LanguageSwitcher from './LanguageSwitcher';

const Header: React.FC = () => {
  const { getItemCount } = useCart();
  const itemCount = getItemCount();
  const { t } = useTranslation();

  return (
    <header>
      <div className="container">
        <nav>
          <Link to="/" className="logo">
            🪵 TimberPunk
          </Link>
          <ul className="nav-links">
            <li>
              <Link to="/">{t('nav.home')}</Link>
            </li>
            <li>
              <Link to="/products">{t('nav.products')}</Link>
            </li>
          </ul>
          <div style={{ display: 'flex', gap: '1rem', alignItems: 'center' }}>
            <LanguageSwitcher />
            <Link to="/cart" className="cart-icon">
              🛒
              {itemCount > 0 && <span className="cart-count">{itemCount}</span>}
            </Link>
          </div>
        </nav>
      </div>
    </header>
  );
};

export default Header;
