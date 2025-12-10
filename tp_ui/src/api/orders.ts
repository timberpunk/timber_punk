import api from './client';
import { Order, OrderCreate, OrderStatus } from '../types';

export const orderApi = {
  // Create a new order (public checkout)
  create: async (order: OrderCreate): Promise<Order> => {
    const response = await api.post('/orders', order);
    return response.data;
  },

  // Get all orders (admin only)
  getAll: async (status?: OrderStatus): Promise<Order[]> => {
    const params = status ? { status } : {};
    const response = await api.get('/orders', { params });
    return response.data;
  },

  // Get a single order by ID (admin only)
  getById: async (id: number): Promise<Order> => {
    const response = await api.get(`/orders/${id}`);
    return response.data;
  },

  // Update order status (admin only)
  updateStatus: async (id: number, status: OrderStatus): Promise<Order> => {
    const response = await api.patch(`/orders/${id}`, { status });
    return response.data;
  },
};
