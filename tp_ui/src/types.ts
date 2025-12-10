export interface Product {
  id: number;
  name: string;
  description: string;
  short_description?: string;
  price: number;
  category: string;
  image_url?: string;
  options?: string;
  created_at: string;
  updated_at?: string;
}

export interface OrderItem {
  product_id: number;
  quantity: number;
  selected_options?: string;
  custom_engraving?: string;
}

export interface Order {
  id: number;
  first_name: string;
  last_name: string;
  email: string;
  phone?: string;
  shipping_address: string;
  note?: string;
  status: OrderStatus;
  total: number;
  created_at: string;
  updated_at?: string;
  items: OrderItemDetail[];
}

export interface OrderItemDetail extends OrderItem {
  id: number;
  order_id: number;
  product_name: string;
  product_price: number;
}

export type OrderStatus = 'NEW' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELED';

export interface OrderCreate {
  first_name: string;
  last_name: string;
  email: string;
  phone?: string;
  shipping_address: string;
  note?: string;
  items: OrderItem[];
}

export interface CartItem {
  product: Product;
  quantity: number;
  selected_options?: string;
  custom_engraving?: string;
}

export interface AdminLogin {
  email: string;
  password: string;
}

export interface AuthResponse {
  access_token: string;
  token_type: string;
}

export interface Admin {
  id: number;
  email: string;
}
