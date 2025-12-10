#!/bin/bash

# TimberPunk - AWS Status Check
# Proverava status servisa i daje korisne komande

echo "================================================"
echo "🪵 TimberPunk - Status Provera"
echo "================================================"
echo ""

# Boje
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

AWS_PUBLIC_DNS="ec2-52-29-195-201.eu-central-1.compute.amazonaws.com"

echo -e "${BLUE}🔍 Proveravam servise...${NC}"
echo ""

# Backend
BACKEND_PID=$(pgrep -f "gunicorn main:app")
if [ -n "$BACKEND_PID" ]; then
    echo -e "${GREEN}✓ Backend je aktivan${NC}"
    echo "  PID: $BACKEND_PID"
    echo "  Port: 8000"
    echo "  URL: http://${AWS_PUBLIC_DNS}:8000"
else
    echo -e "${RED}✗ Backend nije aktivan${NC}"
fi

echo ""

# Frontend
FRONTEND_PID=$(pgrep -f "vite preview")
if [ -n "$FRONTEND_PID" ]; then
    echo -e "${GREEN}✓ Frontend je aktivan${NC}"
    echo "  PID: $FRONTEND_PID"
    
    # Proveri koji port koristi
    if netstat -tuln | grep -q ":80 "; then
        echo "  Port: 80"
        echo "  URL: http://${AWS_PUBLIC_DNS}"
    elif netstat -tuln | grep -q ":4173 "; then
        echo "  Port: 4173"
        echo "  URL: http://${AWS_PUBLIC_DNS}:4173"
    fi
else
    echo -e "${RED}✗ Frontend nije aktivan${NC}"
fi

echo ""
echo -e "${BLUE}📋 Korisne komande:${NC}"
echo ""
echo "# Provera logova:"
echo "  tail -f /tmp/timberpunk_backend_error.log   # Backend greške"
echo "  tail -f /tmp/timberpunk_frontend.log        # Frontend log"
echo ""
echo "# Provera build procesa (ako se još build-uje):"
echo "  ps aux | grep npm"
echo "  ps aux | grep vite"
echo ""
echo "# Provera portova:"
echo "  netstat -tuln | grep -E ':(80|4173|8000)'"
echo ""
echo "# Zaustavi servise:"
echo "  ./stop-aws.sh"
echo "  # ili:"
echo "  pkill -f 'gunicorn main:app'"
echo "  pkill -f 'vite preview'"
echo ""
echo "# Ponovo pokreni:"
echo "  ./setup-aws.sh"
echo ""
echo "================================================"
