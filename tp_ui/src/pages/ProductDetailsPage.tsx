import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { productApi } from '../api/products';
import { Product } from '../types';
import { useCart } from '../context/CartContext';
import { useTranslation } from 'react-i18next';

const ProductDetailsPage: React.FC = () => {
  const { id } = useParams<{ id: string }>();
  const navigate = useNavigate();
  const { addToCart } = useCart();
  const { t, i18n } = useTranslation();

  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const [quantity, setQuantity] = useState(1);
  const [customEngraving, setCustomEngraving] = useState('');
  const [selectedOptions, setSelectedOptions] = useState('');

  useEffect(() => {
    const fetchProduct = async () => {
      try {
        if (!id) return;
        const data = await productApi.getById(parseInt(id));
        setProduct(data);
      } catch (error) {
        console.error('Error fetching product:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchProduct();
  }, [id]);

  const handleAddToCart = () => {
    if (!product) return;
    addToCart(product, quantity, selectedOptions, customEngraving);
    alert(t('products.addedToCart'));
    navigate('/cart');
  };

  if (loading) {
    return <div className="container loading">{t('common.loading')}</div>;
  }

  if (!product) {
    return <div className="container">{t('products.productNotFound')}</div>;
  }

  // Format price based on language
  const formatPrice = (price: number) => {
    if (i18n.language === 'sr') {
      return `${price.toFixed(2)} RSD`;
    }
    return `$${price.toFixed(2)}`;
  };

  return (
    <div className="container" style={{ marginTop: '2rem' }}>
      <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '3rem', alignItems: 'start' }}>
        {/* Left Column: Image and Form */}
        <div>
          {/* Product Image */}
          <img
            src={product.image_url || 'https://via.placeholder.com/600x600?text=Wood+Product'}
            alt={product.name}
            style={{ width: '100%', borderRadius: '8px', border: '1px solid var(--border)', marginBottom: '2rem' }}
          />

          {/* Options (if available) */}
          {product.options && (
            <div className="form-group">
              <label>{t('products.options')}</label>
              <input
                type="text"
                value={selectedOptions}
                onChange={(e) => setSelectedOptions(e.target.value)}
                placeholder={t('products.optionsPlaceholder')}
              />
            </div>
          )}

          {/* Custom Engraving */}
          <div className="form-group">
            <label>{t('products.customEngraving')}</label>
            <textarea
              value={customEngraving}
              onChange={(e) => setCustomEngraving(e.target.value)}
              placeholder={t('products.customEngravingPlaceholder')}
              rows={3}
            />
          </div>

          {/* Quantity */}
          <div className="form-group">
            <label>{t('products.quantity')}:</label>
            <input
              type="number"
              min="1"
              value={quantity}
              onChange={(e) => setQuantity(Math.max(1, parseInt(e.target.value) || 1))}
            />
          </div>

          {/* Add to Cart Button */}
          <button className="btn btn-primary" onClick={handleAddToCart} style={{ width: '100%' }}>
            {t('products.addToCart')}
          </button>
        </div>

        {/* Right Column: Product Details */}
        <div>
          <p style={{ color: 'var(--text-secondary)', textTransform: 'uppercase', fontSize: '0.875rem' }}>
            {product.category}
          </p>
          <h1 style={{ marginTop: '0.5rem', marginBottom: '1rem' }}>{product.name}</h1>
          <p className="price" style={{ fontSize: '2rem', marginBottom: '1.5rem' }}>
            {formatPrice(product.price)}
          </p>
          <p style={{ lineHeight: '1.8', marginBottom: '2rem', whiteSpace: 'pre-line' }}>
            {product.description}
          </p>
        </div>
      </div>
    </div>
  );
};

export default ProductDetailsPage;
