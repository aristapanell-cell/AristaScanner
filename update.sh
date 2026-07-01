echo "Updating Arista Scanner..."
cd ~/arista-scanner
git pull
pip install --upgrade aiohttp
echo "Update complete"
