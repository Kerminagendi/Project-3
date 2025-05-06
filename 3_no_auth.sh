
# Accesses the delete interface without logging in, using only the auth code

AUTH=123456
curl "http://localhost:8888/$AUTH/del/start"
