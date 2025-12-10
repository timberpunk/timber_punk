#!/bin/bash

# TimberPunk Frontend Startup Script

echo "🪵 Starting TimberPunk Frontend..."
echo ""

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
fi

# Start the development server
echo ""
echo "✅ Starting Vite development server..."
echo "🌐 Frontend: http://localhost:5173"
echo ""
npm run dev
