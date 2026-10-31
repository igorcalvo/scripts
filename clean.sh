sudo paccache -r --min-atime "10 days ago" -k0
yaycache --remove --min-mtime '10 days ago'
sudo trash-empty 10
sudo journalctl --vacuum-time=10d
