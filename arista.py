#!/usr/bin/env python3

import asyncio
import subprocess
import re
import sys
import time
from typing import List, Tuple, Optional

class Colors:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    CYAN = '\033[96m'
    MAGENTA = '\033[95m'
    WHITE = '\033[97m'
    RESET = '\033[0m'
    BOLD = '\033[1m'
    DIM = '\033[2m'

class AristaScanner:
    def __init__(self):
        self.results = []

    def get_ips_from_source(self) -> List[str]:
        try:
            import subprocess
            cmd = "bash <(curl -fsSL https://raw.githubusercontent.com/Ptechgithub/warp/main/endip/install.sh) 2>/dev/null"
            result = subprocess.run(['bash', '-c', cmd], capture_output=True, text=True, timeout=30)
            ips = re.findall(r'(\d{1,3}\.){3}\d{1,3}:\d+', result.stdout)
            unique_ips = []
            for ip in ips:
                if ip not in unique_ips:
                    unique_ips.append(ip)
            return unique_ips[:100]
        except:
            return self.generate_fallback_ips()

    def generate_fallback_ips(self) -> List[str]:
        ips = []
        ranges = [
            '104.16.0.0/12', '104.24.0.0/13', '141.101.0.0/16',
            '162.158.0.0/15', '172.64.0.0/13'
        ]
        import random
        import ipaddress
        for cidr in ranges:
            try:
                network = ipaddress.ip_network(cidr, strict=False)
                start_ip = int(network.network_address)
                end_ip = int(network.broadcast_address)
                for _ in range(10):
                    ip_int = random.randint(start_ip + 1, end_ip - 1)
                    ip = str(ipaddress.ip_address(ip_int)) + ":443"
                    ips.append(ip)
            except:
                pass
        return ips[:50]

    def measure_latency(self, ip_port: str) -> Tuple[str, Optional[float]]:
        ip = ip_port.split(':')[0]
        try:
            result = subprocess.run(['ping', '-c', '1', '-W', '1', ip], 
                                  capture_output=True, text=True, timeout=2)
            match = re.search(r'time=([\d.]+)\s*ms', result.stdout)
            if match:
                return (ip_port, float(match.group(1)))
        except:
            pass
        return (ip_port, None)

    def scan(self, count: int = 50):
        print(f"\n{Colors.CYAN}╔═══════════════════════════════════════════════╗")
        print(f"║         Arista Scanner - IP Scanner           ║")
        print(f"╚═══════════════════════════════════════════════╝{Colors.RESET}")
        
        print(f"\n{Colors.BLUE}[*]{Colors.RESET} Fetching IPs...")
        ips = self.get_ips_from_source()
        if not ips:
            print(f"{Colors.RED}No IPs found!{Colors.RESET}")
            return
        
        print(f"{Colors.BLUE}[*]{Colors.RESET} Testing {len(ips)} IPs with ping...\n")
        
        results = []
        total = len(ips)
        for i, ip in enumerate(ips, 1):
            sys.stdout.write(f"\r{Colors.BLUE}[{i}/{total}]{Colors.RESET} Testing: {ip}     ")
            sys.stdout.flush()
            ip_port, latency = self.measure_latency(ip)
            if latency is not None:
                results.append((ip_port, latency))
            time.sleep(0.05)
        
        print(f"\n\n{Colors.CYAN}═══════════════════════════════════════════════")
        print(f"Results")
        print(f"═══════════════════════════════════════════════{Colors.RESET}")
        
        if results:
            results.sort(key=lambda x: x[1])
            print(f"\n{Colors.BOLD}{Colors.GREEN}══════════ TOP 10 IPS ══════════{Colors.RESET}\n")
            print(f"{Colors.CYAN}  IP:Port                    Latency{Colors.RESET}")
            print(f"{Colors.DIM}  -----------------------  ----------{Colors.RESET}")
            for i, (ip, latency) in enumerate(results[:10], 1):
                color = Colors.GREEN if latency < 50 else Colors.YELLOW if latency < 100 else Colors.RED
                print(f"  {color}{i:02d}. {ip:<22}  {latency:>6.1f}ms{Colors.RESET}")
            print(f"\n{Colors.GREEN}✓ Copy the IPs above{Colors.RESET}")
        else:
            print(f"\n{Colors.YELLOW}⚠ No responsive IPs found.{Colors.RESET}")

async def main():
    import argparse
    
    parser = argparse.ArgumentParser(description='Arista Scanner - Fast IP Scanner')
    parser.add_argument('--count', '-n', type=int, default=50, help='Number of IPs to test')
    parser.add_argument('--quiet', '-q', action='store_true', help='Quiet mode')
    
    args = parser.parse_args()
    
    scanner = AristaScanner()
    
    while True:
        print(f"\n{Colors.CYAN}╔═══════════════════════════════════════════════╗")
        print(f"║          Arista Scanner - Main Menu            ║")
        print(f"╚═══════════════════════════════════════════════╝{Colors.RESET}")
        print(f"\n{Colors.GREEN}1.{Colors.RESET} Scan IPv4 IPs {Colors.DIM}(Recommended){Colors.RESET}")
        print(f"{Colors.GREEN}2.{Colors.RESET} Scan IPv6 IPs")
        print(f"{Colors.GREEN}3.{Colors.RESET} Custom Count")
        print(f"\n{Colors.RED}0.{Colors.RESET} Exit")
        print()
        
        choice = input(f"{Colors.BLUE}Enter your choice: {Colors.RESET}").strip()
        
        if choice == "0":
            print(f"\n{Colors.GREEN}Goodbye!{Colors.RESET}")
            break
        elif choice == "1":
            scanner.scan(args.count)
        elif choice == "2":
            print(f"\n{Colors.YELLOW}IPv6 scan coming soon...{Colors.RESET}")
        elif choice == "3":
            count_input = input(f"{Colors.BLUE}Enter number of IPs to scan: {Colors.RESET}")
            try:
                count = int(count_input)
                if count > 0:
                    scanner.scan(count)
                else:
                    print(f"{Colors.RED}Count must be positive!{Colors.RESET}")
            except:
                print(f"{Colors.RED}Invalid number!{Colors.RESET}")
        else:
            print(f"{Colors.RED}Invalid choice!{Colors.RESET}")

if __name__ == '__main__':
    try:
        asyncio.run(main())
    except KeyboardInterrupt:
        print(f"\n{Colors.YELLOW}Interrupted by user{Colors.RESET}")
    except Exception as e:
        print(f"{Colors.RED}Error: {e}{Colors.RESET}")
