# update pacman.conf
update_pacman_conf()
cat >> "/etc/pacman.conf" << EOF
[chaotic-aur]
Server = http://lonewolf-builder.duckdns.org/$repo/x86_64
Server = http://chaotic.bangl.de/$repo/x86_64
Server = https://repo.kitsuna.net/x86_64
EOF

pacman-key --init
pacman-key --keyserver keys.mozilla.org -r 3056513887B78AEB
pacman-key --lsign-key 3056513887B78AEB