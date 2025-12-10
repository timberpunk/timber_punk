import api from './client';
import { AdminLogin, AuthResponse, Admin } from '../types';

export const authApi = {
  // Admin login
  login: async (credentials: AdminLogin): Promise<AuthResponse> => {
    const response = await api.post('/auth/login', credentials);
    return response.data;
  },

  // Get current admin info
  getCurrentAdmin: async (): Promise<Admin> => {
    const response = await api.get('/auth/me');
    return response.data;
  },
};

// Helper functions
export const setAuthToken = (token: string) => {
  localStorage.setItem('token', token);
};

export const getAuthToken = (): string | null => {
  return localStorage.getItem('token');
};

export const removeAuthToken = () => {
  localStorage.removeItem('token');
};

export const isAuthenticated = (): boolean => {
  return !!getAuthToken();
};
