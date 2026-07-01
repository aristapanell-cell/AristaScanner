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

if [ -d "/data/data/com.termux" ]; then
    echo -e "${GREEN}✓ Termux detected${NC}"
else
    echo -e "${YELLOW}⚠ Not running in Termux${NC}"
fi

echo -e "\n${BLUE}[*] Updating package lists...${NC}"
pkg update -y && pkg upgrade -y

echo -e "\n${BLUE}[*] Installing dependencies...${NC}"
pkg install -y python python-pip git openssl-tool

echo -e "\n${BLUE}[*] Installing Python packages...${NC}"
pip install --upgrade pip
pip install aiohttp

echo -e "\n${BLUE}[*] Cloning repository from GitHub...${NC}"
cd ~
rm -rf arista-scanner
git clone https://github.com/aristapanell-cell/AristaScanner.git arista-scanner

cd ~/arista-scanner

chmod +x arista

ln -sf ~/arista-scanner/arista ~/../usr/bin/arista 2>/dev/null || echo "Symlink not created"

echo -e "\n${GREEN}✅ Installation Complete!${NC}"
echo -e "\n${CYAN}📦 Arista Scanner installed in: ~/arista-scanner${NC}"
echo -e "\n${YELLOW}Quick Start:${NC}"
echo -e "  ${WHITE}arista --menu${NC}        ${BLUE}# Interactive menu${NC}"
echo -e "  ${WHITE}arista --cidr 104.16.0.0/16 --count 100${NC}    ${BLUE}# Scan CIDR range${NC}"
echo -e "  ${WHITE}arista --help${NC}        ${BLUE}# Show all options${NC}"
