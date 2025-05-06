
# Shows leftover temporary files after sync

AUTH=123456
curl "http://localhost:8888/$AUTH/sync/do/test@test.com/password"
ls -lh *.tar *.ehtml
