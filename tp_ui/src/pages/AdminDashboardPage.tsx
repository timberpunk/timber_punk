import React, { useEffect, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { isAuthenticated, removeAuthToken } from '../api/auth';
import { productApi } from '../api/products';
import { orderApi } from '../api/orders';
import { Product, Order, OrderStatus } from '../types';

const AdminDashboardPage: React.FC = () => {
  const navigate = useNavigate();
  const [activeTab, setActiveTab] = useState<'products' | 'orders'>('products');

  // Products state
  const [products, setProducts] = useState<Product[]>([]);
  const [loadingProducts, setLoadingProducts] = useState(false);
  const [editingProduct, setEditingProduct] = useState<Product | null>(null);
  const [showProductForm, setShowProductForm] = useState(false);

  // Orders state
  const [orders, setOrders] = useState<Order[]>([]);
  const [loadingOrders, setLoadingOrders] = useState(false);
  const [selectedOrder, setSelectedOrder] = useState<Order | null>(null);

  useEffect(() => {
    if (!isAuthenticated()) {
      navigate('/admin');
    }
  }, [navigate]);

  useEffect(() => {
    if (activeTab === 'products') {
      fetchProducts();
    } else {
      fetchOrders();
    }
  }, [activeTab]);

  const fetchProducts = async () => {
    setLoadingProducts(true);
    try {
      const data = await productApi.getAll();
      setProducts(data);
    } catch (error) {
      console.error('Error fetching products:', error);
    } finally {
      setLoadingProducts(false);
    }
  };

  const fetchOrders = async () => {
    setLoadingOrders(true);
    try {
      const data = await orderApi.getAll();
      setOrders(data);
    } catch (error) {
      console.error('Error fetching orders:', error);
    } finally {
      setLoadingOrders(false);
    }
  };

  const handleLogout = () => {
    removeAuthToken();
    navigate('/admin');
  };

  const handleDeleteProduct = async (id: number) => {
    if (!window.confirm('Are you sure you want to delete this product?')) return;
    try {
      await productApi.delete(id);
      fetchProducts();
    } catch (error) {
      console.error('Error deleting product:', error);
      alert('Failed to delete product');
    }
  };

  const handleUpdateOrderStatus = async (orderId: number, status: OrderStatus) => {
    try {
      await orderApi.updateStatus(orderId, status);
      fetchOrders();
      if (selectedOrder?.id === orderId) {
        const updated = await orderApi.getById(orderId);
        setSelectedOrder(updated);
      }
    } catch (error) {
      console.error('Error updating order status:', error);
      alert('Failed to update order status');
    }
  };

  return (
    <div className="container" style={{ marginTop: '2rem' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '2rem' }}>
        <h1>Admin Dashboard</h1>
        <button onClick={handleLogout} className="btn btn-secondary">
          Logout
        </button>
      </div>

      {/* Tabs */}
      <div style={{ display: 'flex', gap: '1rem', marginBottom: '2rem', borderBottom: '2px solid var(--border)' }}>
        <button
          onClick={() => setActiveTab('products')}
          style={{
            padding: '1rem 2rem',
            background: 'none',
            border: 'none',
            borderBottom: activeTab === 'products' ? '3px solid var(--accent)' : 'none',
            fontWeight: activeTab === 'products' ? '700' : '400',
            color: 'var(--text-primary)',
          }}
        >
          Products
        </button>
        <button
          onClick={() => setActiveTab('orders')}
          style={{
            padding: '1rem 2rem',
            background: 'none',
            border: 'none',
            borderBottom: activeTab === 'orders' ? '3px solid var(--accent)' : 'none',
            fontWeight: activeTab === 'orders' ? '700' : '400',
            color: 'var(--text-primary)',
          }}
        >
          Orders
        </button>
      </div>

      {/* Products Tab */}
      {activeTab === 'products' && (
        <div>
          <div style={{ marginBottom: '2rem' }}>
            <button
              onClick={() => {
                setEditingProduct(null);
                setShowProductForm(true);
              }}
              className="btn btn-primary"
            >
              + Add New Product
            </button>
          </div>

          {showProductForm && (
            <ProductForm
              product={editingProduct}
              onClose={() => {
                setShowProductForm(false);
                setEditingProduct(null);
              }}
              onSave={() => {
                setShowProductForm(false);
                setEditingProduct(null);
                fetchProducts();
              }}
            />
          )}

          {loadingProducts ? (
            <p className="loading">Loading products...</p>
          ) : (
            <div style={{ overflowX: 'auto' }}>
              <table style={{ width: '100%', borderCollapse: 'collapse' }}>
                <thead>
                  <tr style={{ backgroundColor: 'var(--bg-secondary)', borderBottom: '2px solid var(--border)' }}>
                    <th style={{ padding: '1rem', textAlign: 'left' }}>Name</th>
                    <th style={{ padding: '1rem', textAlign: 'left' }}>Category</th>
                    <th style={{ padding: '1rem', textAlign: 'left' }}>Price</th>
                    <th style={{ padding: '1rem', textAlign: 'left' }}>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  {products.map((product) => (
                    <tr key={product.id} style={{ borderBottom: '1px solid var(--border)' }}>
                      <td style={{ padding: '1rem' }}>{product.name}</td>
                      <td style={{ padding: '1rem' }}>{product.category}</td>
                      <td style={{ padding: '1rem' }}>${product.price.toFixed(2)}</td>
                      <td style={{ padding: '1rem' }}>
                        <button
                          onClick={() => {
                            setEditingProduct(product);
                            setShowProductForm(true);
                          }}
                          className="btn btn-secondary"
                          style={{ marginRight: '0.5rem' }}
                        >
                          Edit
                        </button>
                        <button onClick={() => handleDeleteProduct(product.id)} className="btn btn-danger">
                          Delete
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          )}
        </div>
      )}

      {/* Orders Tab */}
      {activeTab === 'orders' && (
        <div style={{ display: 'grid', gridTemplateColumns: selectedOrder ? '1fr 1fr' : '1fr', gap: '2rem' }}>
          <div>
            {loadingOrders ? (
              <p className="loading">Loading orders...</p>
            ) : (
              <div>
                {orders.map((order) => (
                  <div
                    key={order.id}
                    onClick={() => setSelectedOrder(order)}
                    style={{
                      padding: '1.5rem',
                      backgroundColor: selectedOrder?.id === order.id ? 'var(--border)' : 'var(--bg-secondary)',
                      borderRadius: '8px',
                      marginBottom: '1rem',
                      cursor: 'pointer',
                    }}
                  >
                    <div style={{ display: 'flex', justifyContent: 'space-between', marginBottom: '0.5rem' }}>
                      <strong>Order #{order.id}</strong>
                      <span
                        style={{
                          padding: '0.25rem 0.75rem',
                          borderRadius: '4px',
                          fontSize: '0.875rem',
                          backgroundColor: getStatusColor(order.status),
                          color: 'white',
                        }}
                      >
                        {order.status}
                      </span>
                    </div>
                    <p style={{ fontSize: '0.875rem', color: 'var(--text-secondary)' }}>
                      {order.first_name} {order.last_name} • {order.email}
                    </p>
                    <p style={{ marginTop: '0.5rem', fontWeight: '600' }}>Total: ${order.total.toFixed(2)}</p>
                  </div>
                ))}
              </div>
            )}
          </div>

          {selectedOrder && (
            <div
              style={{
                padding: '2rem',
                backgroundColor: 'var(--bg-secondary)',
                borderRadius: '8px',
                position: 'sticky',
                top: '100px',
              }}
            >
              <h2>Order #{selectedOrder.id}</h2>
              <p style={{ marginTop: '1rem', color: 'var(--text-secondary)' }}>
                Placed on: {new Date(selectedOrder.created_at).toLocaleDateString()}
              </p>

              <h3 style={{ marginTop: '2rem' }}>Customer Information</h3>
              <p>
                {selectedOrder.first_name} {selectedOrder.last_name}
              </p>
              <p>{selectedOrder.email}</p>
              {selectedOrder.phone && <p>{selectedOrder.phone}</p>}
              <p style={{ marginTop: '0.5rem' }}>{selectedOrder.shipping_address}</p>
              {selectedOrder.note && (
                <div style={{ marginTop: '1rem' }}>
                  <strong>Note:</strong>
                  <p>{selectedOrder.note}</p>
                </div>
              )}

              <h3 style={{ marginTop: '2rem' }}>Items</h3>
              {selectedOrder.items.map((item) => (
                <div key={item.id} style={{ marginBottom: '1rem', padding: '0.75rem', backgroundColor: 'var(--bg-primary)', borderRadius: '4px' }}>
                  <p>
                    <strong>{item.product_name}</strong> x {item.quantity}
                  </p>
                  <p>${item.product_price.toFixed(2)} each</p>
                  {item.custom_engraving && <p style={{ fontSize: '0.875rem' }}>Engraving: "{item.custom_engraving}"</p>}
                </div>
              ))}

              <h3 style={{ marginTop: '2rem' }}>Status</h3>
              <select
                value={selectedOrder.status}
                onChange={(e) => handleUpdateOrderStatus(selectedOrder.id, e.target.value as OrderStatus)}
                style={{ padding: '0.5rem', width: '100%', marginTop: '0.5rem' }}
              >
                <option value="NEW">NEW</option>
                <option value="IN_PROGRESS">IN_PROGRESS</option>
                <option value="COMPLETED">COMPLETED</option>
                <option value="CANCELED">CANCELED</option>
              </select>

              <h3 style={{ marginTop: '2rem' }}>Total: ${selectedOrder.total.toFixed(2)}</h3>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

// Product Form Component
const ProductForm: React.FC<{
  product: Product | null;
  onClose: () => void;
  onSave: () => void;
}> = ({ product, onClose, onSave }) => {
  const [formData, setFormData] = useState({
    name: product?.name || '',
    description: product?.description || '',
    short_description: product?.short_description || '',
    price: product?.price || 0,
    category: product?.category || '',
    image_url: product?.image_url || '',
    options: product?.options || '',
  });

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    try {
      if (product) {
        await productApi.update(product.id, formData);
      } else {
        await productApi.create(formData);
      }
      onSave();
    } catch (error) {
      console.error('Error saving product:', error);
      alert('Failed to save product');
    }
  };

  return (
    <div
      style={{
        position: 'fixed',
        top: 0,
        left: 0,
        right: 0,
        bottom: 0,
        backgroundColor: 'rgba(0, 0, 0, 0.5)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        zIndex: 1000,
      }}
      onClick={onClose}
    >
      <div
        onClick={(e) => e.stopPropagation()}
        style={{
          backgroundColor: 'var(--bg-primary)',
          padding: '2rem',
          borderRadius: '8px',
          maxWidth: '600px',
          width: '90%',
          maxHeight: '90vh',
          overflowY: 'auto',
        }}
      >
        <h2>{product ? 'Edit Product' : 'Add New Product'}</h2>
        <form onSubmit={handleSubmit}>
          <div className="form-group">
            <label>Name *</label>
            <input
              type="text"
              value={formData.name}
              onChange={(e) => setFormData({ ...formData, name: e.target.value })}
              required
            />
          </div>

          <div className="form-group">
            <label>Category *</label>
            <input
              type="text"
              value={formData.category}
              onChange={(e) => setFormData({ ...formData, category: e.target.value })}
              placeholder="e.g., wall art, coasters, signs, gifts"
              required
            />
          </div>

          <div className="form-group">
            <label>Price *</label>
            <input
              type="number"
              step="0.01"
              value={formData.price}
              onChange={(e) => setFormData({ ...formData, price: parseFloat(e.target.value) })}
              required
            />
          </div>

          <div className="form-group">
            <label>Short Description</label>
            <input
              type="text"
              value={formData.short_description}
              onChange={(e) => setFormData({ ...formData, short_description: e.target.value })}
              placeholder="Brief description for product cards"
            />
          </div>

          <div className="form-group">
            <label>Description *</label>
            <textarea
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={4}
              required
            />
          </div>

          <div className="form-group">
            <label>Image URL</label>
            <input
              type="text"
              value={formData.image_url}
              onChange={(e) => setFormData({ ...formData, image_url: e.target.value })}
              placeholder="https://..."
            />
          </div>

          <div className="form-group">
            <label>Options (JSON)</label>
            <textarea
              value={formData.options}
              onChange={(e) => setFormData({ ...formData, options: e.target.value })}
              rows={2}
              placeholder='e.g., {"sizes": ["Small", "Large"], "woods": ["Oak", "Walnut"]}'
            />
          </div>

          <div style={{ display: 'flex', gap: '1rem' }}>
            <button type="submit" className="btn btn-primary" style={{ flex: 1 }}>
              Save
            </button>
            <button type="button" onClick={onClose} className="btn btn-secondary" style={{ flex: 1 }}>
              Cancel
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

const getStatusColor = (status: OrderStatus): string => {
  switch (status) {
    case 'NEW':
      return '#3b82f6';
    case 'IN_PROGRESS':
      return '#f59e0b';
    case 'COMPLETED':
      return '#10b981';
    case 'CANCELED':
      return '#ef4444';
    default:
      return '#6b7280';
  }
};

export default AdminDashboardPage;
