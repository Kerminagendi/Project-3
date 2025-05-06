
# Simulates registering/resetting without verifying email ownership

curl -X POST "http://localhost:8888/register" \
  -d "email=student@localhost" \
  -d "password=hacked"
