import React from 'react';
import { Link } from 'react-router-dom';
import { Product } from '../types';
import { useTranslation } from 'react-i18next';

interface ProductCardProps {
  product: Product;
}

const ProductCard: React.FC<ProductCardProps> = ({ product }) => {
  const { i18n } = useTranslation();
  
  // Format price based on language
  const formatPrice = (price: number) => {
    if (i18n.language === 'sr') {
      return `${price.toFixed(2)} RSD`;
    }
    return `$${price.toFixed(2)}`;
  };

  return (
    <div className="product-card">
      <Link to={`/products/${product.id}`}>
        <img
          src={product.image_url || 'https://via.placeholder.com/300x250?text=Wood+Product'}
          alt={product.name}
        />
        <div className="product-card-body">
          <p className="category">{product.category}</p>
          <h3>{product.name}</h3>
          <p style={{ whiteSpace: 'pre-line' }}>
            {product.short_description || product.description.substring(0, 100) + '...'}
          </p>
          <p className="price">{formatPrice(product.price)}</p>
        </div>
      </Link>
    </div>
  );
};

export default ProductCard;
