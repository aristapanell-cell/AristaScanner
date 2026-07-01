#!/bin/bash

clear

BOLD='\033[1m'
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
GOLD='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                                                                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}       ${WHITE}██████╗ ${RED}██████╗ ${GREEN}██╗${YELLOW}██████╗ ${BLUE}████████╗${PURPLE} █████╗${NC}                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}      ${WHITE}██╔══██╗${RED}██╔══██╗${GREEN}██║${YELLOW}██╔══██╗${BLUE}╚══██╔══╝${PURPLE}██╔══██╗${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}      ${WHITE}██████╔╝${RED}██████╔╝${GREEN}██║${YELLOW}██████╔╝${BLUE}   ██║   ${PURPLE}███████║${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}      ${WHITE}██╔══██╗${RED}██╔══██╗${GREEN}██║${YELLOW}██╔══██╗${BLUE}   ██║   ${PURPLE}██╔══██║${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}      ${WHITE}██║  ██║${RED}██║  ██║${GREEN}██║${YELLOW}██║  ██║${BLUE}   ██║   ${PURPLE}██║  ██║${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}      ${WHITE}╚═╝  ╚═╝${RED}╚═╝  ╚═╝${GREEN}╚═╝${YELLOW}╚═╝  ╚═╝${BLUE}   ╚═╝   ${PURPLE}╚═╝  ╚═╝${NC}                 ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}            ${GOLD}⚡${WHITE} ULTRA SCANNER ${GOLD}⚡${NC} - ${RED}I${GREEN}P${BLUE} V${YELLOW}4${PURPLE} & ${CYAN}V${RED}6${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                                            ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${WHITE}GitHub:${NC} ${BLUE}https://github.com/aristapanell-cell/AristaScanner${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                                            ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${GOLD}═══${NC} ${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}Date:${NC} $(date '+%Y-%m-%d %H:%M:%S') ${GOLD}═══${NC}"
echo -e "${GOLD}═══${NC} ${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}System:${NC} $(uname -o 2>/dev/null || echo "Linux") ${GOLD}═══${NC}"
echo ""

echo -e "${CYAN}┌──────────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${WHITE}▸ OPTIONS${NC}                                                     ${CYAN}│${NC}"
echo -e "${CYAN}├──────────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}▸ 1${NC}) ${WHITE}IPv4 SCAN${NC}  ${BLUE}• Find best IPv4 addresses${NC}                        ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}▸ 2${NC}) ${WHITE}IPv6 SCAN${NC}  ${BLUE}• Find best IPv6 addresses${NC}                        ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${RED}▸ 0${NC}) ${WHITE}EXIT${NC}       ${BLUE}• Close scanner${NC}                                       ${CYAN}│${NC}"
echo -e "${CYAN}└──────────────────────────────────────────────────────────┘${NC}"

echo -en "\n${WHITE}┌─[${GREEN}SELECT${WHITE}]${NC} "
read -r user_input

measure_latency() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local latency=$(ping -c 1 -W 1 $ip 2>/dev/null | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "│  %-21s  │   %-6s   │\n" "$ip_port" "$latency"
}

measure_latency6() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d'[' -f2 | cut -d']' -f1)
    local latency=$(ping6 -c 1 -W 1 $ip 2>/dev/null | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "│  %-43s  │   %-6s   │\n" "$ip_port" "$latency"
}

display_table_ipv4() {
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${WHITE}🌟 TOP 10 IPv4 ADDRESSES${NC}                                          ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  ${CYAN}IP:PORT${NC}                    ${CYAN}LATENCY${NC}    ${CYAN}STATUS${NC}                 ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════╣${NC}"
    echo "$1" | head -n 10 | while read -r ip_port; do 
        latency=$(echo "$ip_port" | cut -d'|' -f2)
        ip=$(echo "$ip_port" | cut -d'|' -f1)
        if [ "$latency" != "N/A" ] && [ "$latency" -lt 100 ] 2>/dev/null; then
            status="${GREEN}● FAST${NC}"
        elif [ "$latency" != "N/A" ] && [ "$latency" -lt 200 ] 2>/dev/null; then
            status="${YELLOW}● GOOD${NC}"
        elif [ "$latency" != "N/A" ]; then
            status="${RED}● SLOW${NC}"
        else
            status="${RED}● DOWN${NC}"
        fi
        printf "${GREEN}║${NC}  %-21s  │  %-6s  │  %-6s  ${GREEN}║${NC}\n" "$ip" "$latency" "$status"
    done
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
}

display_table_ipv4_simple() {
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${WHITE}🌟 TOP 10 IPv4 ADDRESSES (IP ONLY)${NC}                                 ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  ${CYAN}#${NC}  ${CYAN}IP ADDRESS${NC}                         ${CYAN}LATENCY${NC}    ${CYAN}STATUS${NC}       ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════╣${NC}"
    local idx=0
    echo "$1" | head -n 10 | while read -r ip_port; do
        idx=$((idx+1))
        ip=$(echo "$ip_port" | cut -d'|' -f1)
        latency=$(echo "$ip_port" | cut -d'|' -f2)
        if [ "$latency" != "N/A" ] && [ "$latency" -lt 100 ] 2>/dev/null; then
            status="${GREEN}● FAST${NC}"
        elif [ "$latency" != "N/A" ] && [ "$latency" -lt 200 ] 2>/dev/null; then
            status="${YELLOW}● GOOD${NC}"
        elif [ "$latency" != "N/A" ]; then
            status="${RED}● SLOW${NC}"
        else
            status="${RED}● DOWN${NC}"
        fi
        printf "${GREEN}║${NC}  ${WHITE}%02d${NC}  %-25s  │  %-6s  │  %-6s  ${GREEN}║${NC}\n" "$idx" "$ip" "$latency" "$status"
    done
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════╝${NC}"
}

display_table_ipv6() {
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${WHITE}🌟 TOP 10 IPv6 ADDRESSES${NC}                                                      ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  ${CYAN}IP:PORT${NC}                                         ${CYAN}LATENCY${NC}    ${CYAN}STATUS${NC}       ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo "$1" | head -n 10 | while read -r ip_port; do
        latency=$(echo "$ip_port" | cut -d'|' -f2)
        ip=$(echo "$ip_port" | cut -d'|' -f1)
        if [ "$latency" != "N/A" ] && [ "$latency" -lt 100 ] 2>/dev/null; then
            status="${GREEN}● FAST${NC}"
        elif [ "$latency" != "N/A" ] && [ "$latency" -lt 200 ] 2>/dev/null; then
            status="${YELLOW}● GOOD${NC}"
        elif [ "$latency" != "N/A" ]; then
            status="${RED}● SLOW${NC}"
        else
            status="${RED}● DOWN${NC}"
        fi
        printf "${GREEN}║${NC}  %-43s  │  %-6s  │  %-6s  ${GREEN}║${NC}\n" "$ip" "$latency" "$status"
    done
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
}

display_table_ipv6_simple() {
    echo -e "\n${GREEN}╔═══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║${NC}  ${WHITE}🌟 TOP 10 IPv6 ADDRESSES (IP ONLY)${NC}                                             ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    echo -e "${GREEN}║${NC}  ${CYAN}#${NC}  ${CYAN}IP ADDRESS${NC}                                   ${CYAN}LATENCY${NC}    ${CYAN}STATUS${NC}       ${GREEN}║${NC}"
    echo -e "${GREEN}╠═══════════════════════════════════════════════════════════════════════════════╣${NC}"
    local idx=0
    echo "$1" | head -n 10 | while read -r ip_port; do
        idx=$((idx+1))
        ip=$(echo "$ip_port" | cut -d'|' -f1)
        latency=$(echo "$ip_port" | cut -d'|' -f2)
        if [ "$latency" != "N/A" ] && [ "$latency" -lt 100 ] 2>/dev/null; then
            status="${GREEN}● FAST${NC}"
        elif [ "$latency" != "N/A" ] && [ "$latency" -lt 200 ] 2>/dev/null; then
            status="${YELLOW}● GOOD${NC}"
        elif [ "$latency" != "N/A" ]; then
            status="${RED}● SLOW${NC}"
        else
            status="${RED}● DOWN${NC}"
        fi
        printf "${GREEN}║${NC}  ${WHITE}%02d${NC}  %-37s  │  %-6s  │  %-6s  ${GREEN}║${NC}\n" "$idx" "$ip" "$latency" "$status"
    done
    echo -e "${GREEN}╚═══════════════════════════════════════════════════════════════════════════════╝${NC}"
}

if [ "$user_input" -eq 1 ]; then
    echo -e "\n${GOLD}═══${NC} ${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}Scanning IPv4 addresses...${NC} ${GOLD}═══${NC}"
    ip_list=$(echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+')
    clear
    if [ -z "$ip_list" ]; then
        echo -e "\n${GOLD}═══${NC} ${WHITE}[${RED}!${WHITE}]${NC} ${RED}No IPv4 addresses found!${NC} ${GOLD}═══${NC}"
    else
        display_table_ipv4 "$ip_list"
        echo ""
        display_table_ipv4_simple "$ip_list"
    fi
    echo -e "\n${GOLD}═══${NC} ${WHITE}[${CYAN}i${WHITE}]${NC} ${WHITE}Press Enter to continue...${NC} ${GOLD}═══${NC}"
    read
    exec "$0"
elif [ "$user_input" -eq 2 ]; then
    echo -e "\n${GOLD}═══${NC} ${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}Scanning IPv6 addresses...${NC} ${GOLD}═══${NC}"
    ip_list=$(echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null | grep -oP '(\[?[a-fA-F\d:]+\]?\:\d+)')
    clear
    if [ -z "$ip_list" ]; then
        echo -e "\n${GOLD}═══${NC} ${WHITE}[${RED}!${WHITE}]${NC} ${RED}No IPv6 addresses found!${NC} ${GOLD}═══${NC}"
    else
        display_table_ipv6 "$ip_list"
        echo ""
        display_table_ipv6_simple "$ip_list"
    fi
    echo -e "\n${GOLD}═══${NC} ${WHITE}[${CYAN}i${WHITE}]${NC} ${WHITE}Press Enter to continue...${NC} ${GOLD}═══${NC}"
    read
    exec "$0"
elif [ "$user_input" -eq 0 ]; then
    echo -e "\n${GOLD}═══${NC} ${WHITE}[${GREEN}+${WHITE}]${NC} ${GREEN}Goodbye!${NC} ${GOLD}═══${NC}"
    exit 0
else
    echo -e "\n${GOLD}═══${NC} ${WHITE}[${RED}!${WHITE}]${NC} ${RED}Invalid input. Please enter 1, 2, or 0${NC} ${GOLD}═══${NC}"
    sleep 2
    exec "$0"
fi
