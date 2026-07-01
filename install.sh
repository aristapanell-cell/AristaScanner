#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

echo -e "${CYAN}"
echo "╔══════════════════════════════════════════════════════════╗"
echo "║                                                          ║"
echo "║   █████╗ ██████╗ ██╗███████╗████████╗ █████╗             ║"
echo "║  ██╔══██╗██╔══██╗██║██╔════╝╚══██╔══╝██╔══██╗            ║"
echo "║  ███████║██████╔╝██║███████╗   ██║   ███████║            ║"
echo "║  ██╔══██║██╔══██╗██║╚════██║   ██║   ██╔══██║            ║"
echo "║  ██║  ██║██║  ██║██║███████║   ██║   ██║  ██║            ║"
echo "║  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚══════╝   ╚═╝   ╚═╝  ╚═╝            ║"
echo "║                                                          ║"
echo "║           Arista Scanner - Termux Installer              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo -e "${NC}"

echo -e "\n${BLUE}[*]${NC} Installing Arista Scanner..."

curl -fsSL https://raw.githubusercontent.com/aristapanell-cell/AristaScanner/main/arista.sh -o ~/arista
chmod +x ~/arista
ln -sf ~/arista ~/../usr/bin/arista 2>/dev/null || echo -e "${YELLOW}Symlink not created${NC}"

echo -e "\n${GREEN}✅ Installation Complete!${NC}"
echo -e "\n${CYAN}📦 Arista Scanner installed${NC}"
echo -e "\n${YELLOW}Quick Start:${NC}"
echo -e "  ${WHITE}arista${NC}        ${BLUE}# Run scanner${NC}"
