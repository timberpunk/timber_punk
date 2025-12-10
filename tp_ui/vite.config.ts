import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    port: 5173,
    proxy: {
      '/api': {
        target: 'http://localhost:8000',
        changeOrigin: true,
        rewrite: (path) => path.replace(/^\/api/, '')
      }
    }
  },
  preview: {
    port: 4173,
    host: true,
    allowedHosts: [
      'localhost',
      '.amazonaws.com',
      '.compute.amazonaws.com',
      'ec2-52-29-195-201.eu-central-1.compute.amazonaws.com'
    ]
  }
})
