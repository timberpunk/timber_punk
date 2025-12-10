#!/bin/bash

# TimberPunk Frontend - Production Build & Serve Script
# Simple script to build and serve frontend

set -e

echo "🪵 TimberPunk Frontend - Production"
echo "===================================="
echo ""

# Get script directory
cd "$(dirname "$0")"

# Check if node_modules exists
if [ ! -d "node_modules" ]; then
    echo "📦 Installing dependencies..."
    npm install
else
    echo "📦 Dependencies already installed"
fi

echo ""
echo "Select option:"
echo "1) Build for production"
echo "2) Preview production build (with local server)"
echo "3) Development mode (with hot reload)"
read -p "Choice (1, 2, or 3, default: 1): " MODE
MODE=${MODE:-1}

echo ""

if [ "$MODE" = "1" ]; then
    echo "🏗️  Building for production..."
    npm run build
    echo ""
    echo "✅ Build complete!"
    echo "📁 Files are in: ./dist/"
    echo ""
    echo "To serve the build:"
    echo "  npx serve -s dist -p 5173"
    echo ""
    echo "Or upload ./dist/ folder to your web server"
    
elif [ "$MODE" = "2" ]; then
    echo "🏗️  Building for production..."
    npm run build
    echo ""
    echo "🚀 Starting preview server..."
    echo "📍 Frontend: http://localhost:5173"
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""
    npm run preview
    
else
    echo "🔧 Starting development server..."
    echo "📍 Frontend: http://localhost:5173"
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""
    npm run dev
fi
