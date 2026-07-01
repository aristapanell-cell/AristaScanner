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
NC='\033[0m'

echo -e "${CYAN}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║${NC}                                                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${RED}██████╗ ${GREEN}██████╗ ${YELLOW}██╗${PURPLE}██████╗ ${CYAN}████████╗${WHITE} █████╗${NC}          ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${RED}██╔══██╗${GREEN}██╔══██╗${YELLOW}██║${PURPLE}██╔══██╗${CYAN}╚══██╔══╝${WHITE}██╔══██╗${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${RED}██████╔╝${GREEN}██████╔╝${YELLOW}██║${PURPLE}██████╔╝${CYAN}   ██║   ${WHITE}███████║${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${RED}██╔══██╗${GREEN}██╔══██╗${YELLOW}██║${PURPLE}██╔══██╗${CYAN}   ██║   ${WHITE}██╔══██║${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${RED}██║  ██║${GREEN}██║  ██║${YELLOW}██║${PURPLE}██║  ██║${CYAN}   ██║   ${WHITE}██║  ██║${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${RED}╚═╝  ╚═╝${GREEN}╚═╝  ╚═╝${YELLOW}╚═╝${PURPLE}╚═╝  ╚═╝${CYAN}   ╚═╝   ${WHITE}╚═╝  ╚═╝${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}              ${WHITE}SCANNER${NC} - ${RED}I${GREEN}P${BLUE} V${YELLOW}4${PURPLE} & ${CYAN}V${RED}6${NC}              ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                                  ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}         ${WHITE}GitHub:${NC} ${BLUE}https://github.com/aristapanell-cell/AristaScanner${NC}         ${CYAN}║${NC}"
echo -e "${CYAN}║${NC}                                                                  ${CYAN}║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════════╝${NC}"

echo -e "\n${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}Date:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
echo -e "${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}System:${NC} $(uname -o 2>/dev/null || echo "Linux")"
echo ""

echo -e "${CYAN}┌────────────────────────────────────────────────────┐${NC}"
echo -e "${CYAN}│${NC}  ${WHITE}OPTIONS${NC}                                                ${CYAN}│${NC}"
echo -e "${CYAN}├────────────────────────────────────────────────────┤${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}1${NC}) ${WHITE}IPv4 SCAN${NC} - ${BLUE}Find best IPv4 addresses${NC}                 ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${GREEN}2${NC}) ${WHITE}IPv6 SCAN${NC} - ${BLUE}Find best IPv6 addresses${NC}                 ${CYAN}│${NC}"
echo -e "${CYAN}│${NC}  ${RED}0${NC}) ${WHITE}EXIT${NC} - ${BLUE}Close scanner${NC}                                    ${CYAN}│${NC}"
echo -e "${CYAN}└────────────────────────────────────────────────────┘${NC}"

echo -en "\n${WHITE}┌─[${GREEN}SELECT${WHITE}]${NC} "
read -r user_input

measure_latency() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d: -f1)
    local latency=$(ping -c 1 -W 1 $ip 2>/dev/null | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "│ %-21s │ %-10s │\n" "$ip_port" "$latency"
}

measure_latency6() {
    local ip_port=$1
    local ip=$(echo $ip_port | cut -d'[' -f2 | cut -d']' -f1)
    local latency=$(ping6 -c 1 -W 1 $ip 2>/dev/null | grep 'time=' | awk -F'time=' '{ print $2 }' | cut -d' ' -f1)
    if [ -z "$latency" ]; then
        latency="N/A"
    fi
    printf "│ %-45s │ %-10s │\n" "$ip_port" "$latency"
}

display_table_ipv4() {
    echo -e "\n${CYAN}┌───────────────────────┬────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}IP:Port${NC}               ${CYAN}│${NC} ${WHITE}Latency(ms)${NC} ${CYAN}│${NC}"
    echo -e "${CYAN}├───────────────────────┼────────────┤${NC}"
    echo "$1" | head -n 10 | while read -r ip_port; do measure_latency "$ip_port"; done
    echo -e "${CYAN}└───────────────────────┴────────────┘${NC}"
}

display_table_ipv6() {
    echo -e "\n${CYAN}┌─────────────────────────────────────────────┬────────────┐${NC}"
    echo -e "${CYAN}│${NC} ${WHITE}IP:Port${NC}                                     ${CYAN}│${NC} ${WHITE}Latency(ms)${NC} ${CYAN}│${NC}"
    echo -e "${CYAN}├─────────────────────────────────────────────┼────────────┤${NC}"
    echo "$1" | head -n 10 | while read -r ip_port; do measure_latency6 "$ip_port"; done
    echo -e "${CYAN}└─────────────────────────────────────────────┴────────────┘${NC}"
}

if [ "$user_input" -eq 1 ]; then
    echo -e "\n${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}Fetching IPv4 addresses...${NC}"
    ip_list=$(echo "1" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null | grep -oP '(\d{1,3}\.){3}\d{1,3}:\d+')
    clear
    if [ -z "$ip_list" ]; then
        echo -e "\n${WHITE}[${RED}!${WHITE}]${NC} ${RED}No IPv4 addresses found!${NC}"
    else
        echo -e "\n${WHITE}[${GREEN}+${WHITE}]${NC} ${GREEN}Top 10 IPv4 addresses with their latencies:${NC}"
        display_table_ipv4 "$ip_list"
    fi
    echo -e "\n${WHITE}[${CYAN}i${WHITE}]${NC} ${WHITE}Press Enter to continue...${NC}"
    read
    exec "$0"
elif [ "$user_input" -eq 2 ]; then
    echo -e "\n${WHITE}[${GREEN}+${WHITE}]${NC} ${CYAN}Fetching IPv6 addresses...${NC}"
    ip_list=$(echo "2" | bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null | grep -oP '(\[?[a-fA-F\d:]+\]?\:\d+)')
    clear
    if [ -z "$ip_list" ]; then
        echo -e "\n${WHITE}[${RED}!${WHITE}]${NC} ${RED}No IPv6 addresses found!${NC}"
    else
        echo -e "\n${WHITE}[${GREEN}+${WHITE}]${NC} ${GREEN}Top 10 IPv6 addresses with their latencies:${NC}"
        display_table_ipv6 "$ip_list"
    fi
    echo -e "\n${WHITE}[${CYAN}i${WHITE}]${NC} ${WHITE}Press Enter to continue...${NC}"
    read
    exec "$0"
elif [ "$user_input" -eq 0 ]; then
    echo -e "\n${WHITE}[${GREEN}+${WHITE}]${NC} ${GREEN}Goodbye!${NC}"
    exit 0
else
    echo -e "\n${WHITE}[${RED}!${WHITE}]${NC} ${RED}Invalid input. Please enter 1, 2, or 0${NC}"
    sleep 2
    exec "$0"
fi
