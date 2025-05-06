
# Shows where the same key and IV are used in AES encryption

grep aes-128-ctr ../sync.c | grep -o '\-K.*\-iv.*'
