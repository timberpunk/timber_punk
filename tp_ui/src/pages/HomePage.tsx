import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { productApi } from '../api/products';
import { Product } from '../types';
import ProductCard from '../components/ProductCard';
import { useTranslation } from 'react-i18next';

const HomePage: React.FC = () => {
  const [featuredProducts, setFeaturedProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);
  const { t } = useTranslation();

  useEffect(() => {
    const fetchFeaturedProducts = async () => {
      try {
        const products = await productApi.getAll();
        // Take first 3 products as featured
        setFeaturedProducts(products.slice(0, 3));
      } catch (error) {
        console.error('Error fetching featured products:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchFeaturedProducts();
  }, []);

  return (
    <div className="container">
      {/* Hero Section */}
      <section className="hero">
        <h1>{t('hero.title')}</h1>
        <p className="subtitle">{t('hero.subtitle')}</p>
        <p className="description">
          {t('hero.description')}
        </p>
        <Link to="/products">
          <button className="btn btn-primary">{t('hero.cta')}</button>
        </Link>
      </section>

      {/* Featured Products */}
      <section>
        <h2 className="text-center mb-4">{t('products.featuredTitle')}</h2>
        {loading ? (
          <p className="loading">{t('common.loading')}</p>
        ) : (
          <div className="product-grid">
            {featuredProducts.map((product) => (
              <ProductCard key={product.id} product={product} />
            ))}
          </div>
        )}
      </section>

      {/* About Section */}
      <section style={{ marginTop: '4rem', textAlign: 'center' }}>
        <h2 className="mb-3">{t('about.title')}</h2>
        <p style={{ maxWidth: '700px', margin: '0 auto', lineHeight: '1.8' }}>
          {t('about.description')}
        </p>
      </section>
    </div>
  );
};

export default HomePage;
