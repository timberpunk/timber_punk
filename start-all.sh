#!/bin/bash

# TimberPunk - Quick Start Script
# Starts both backend and frontend

echo "🪵 TimberPunk - Quick Start"
echo "==========================="
echo ""

# Get script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

echo "Starting backend and frontend..."
echo ""

# Start backend in background
echo "🔧 Starting Backend..."
cd "$SCRIPT_DIR/tp_backend"
chmod +x start-prod.sh
./start-prod.sh &
BACKEND_PID=$!

# Wait a bit for backend to start
sleep 3

# Start frontend
echo ""
echo "🎨 Starting Frontend..."
cd "$SCRIPT_DIR/tp_ui"
chmod +x start-prod.sh
./start-prod.sh

# When frontend stops, stop backend too
kill $BACKEND_PID 2>/dev/null
