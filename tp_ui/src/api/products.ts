import api from './client';
import { Product } from '../types';

export const productApi = {
  // Get all products, optionally filtered by category
  getAll: async (category?: string): Promise<Product[]> => {
    const params = category ? { category } : {};
    const response = await api.get('/products', { params });
    return response.data;
  },

  // Get a single product by ID
  getById: async (id: number): Promise<Product> => {
    const response = await api.get(`/products/${id}`);
    return response.data;
  },

  // Create a new product (admin only)
  create: async (product: Omit<Product, 'id' | 'created_at' | 'updated_at'>): Promise<Product> => {
    const response = await api.post('/products', product);
    return response.data;
  },

  // Update a product (admin only)
  update: async (id: number, product: Partial<Product>): Promise<Product> => {
    const response = await api.put(`/products/${id}`, product);
    return response.data;
  },

  // Delete a product (admin only)
  delete: async (id: number): Promise<void> => {
    await api.delete(`/products/${id}`);
  },
};
