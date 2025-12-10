#!/bin/bash

# TimberPunk Quick Deployment Script

echo "🪵 TimberPunk Deployment Script"
echo "================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Check if .env.docker exists
if [ ! -f .env.docker ]; then
    echo "📝 Creating .env.docker from example..."
    cp .env.docker.example .env.docker
    
    # Generate random SECRET_KEY
    SECRET_KEY=$(openssl rand -hex 32)
    sed -i.bak "s/your-super-secret-key-generate-with-openssl-rand-hex-32/$SECRET_KEY/" .env.docker
    
    echo "⚠️  Please edit .env.docker and update:"
    echo "   - DB_PASSWORD"
    echo "   - ADMIN_PASSWORD"
    echo "   - FRONTEND_URL"
    echo "   - API_URL"
    echo ""
    read -p "Press Enter after updating .env.docker..."
fi

echo "🚀 Starting deployment..."
echo ""

# Build and start containers
docker-compose --env-file .env.docker up -d --build

echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Service Status:"
docker-compose ps
echo ""
echo "🌐 API should be available at: http://localhost:8000"
echo "📚 API Docs: http://localhost:8000/docs"
echo ""
echo "📝 View logs with: docker-compose logs -f"
echo "🛑 Stop services with: docker-compose down"
