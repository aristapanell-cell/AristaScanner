apt update -y 2>/dev/null
curl -o $PREFIX/bin/arista https://raw.githubusercontent.com/aristapanell-cell/AristaScanner/main/arista.sh 2>/dev/null
chmod +x $PREFIX/bin/arista 2>/dev/null
echo -e "\033[1;32m✓ Arista Scanner installed successfully!\033[0m"
echo -e "\033[1;36mRun 'arista' to start\033[0m"
