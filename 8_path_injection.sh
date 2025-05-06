
# Tries to inject a path via BMID to write favicon outside static/

BMID="../../hacked"
curl -o "static/$BMID.ico" http://example.com/favicon.ico
