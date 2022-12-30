#!/bin/bash

touch ~/.hushlogin
echo "127.0.0.1 $(hostname)" >> /etc/hosts
printf "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale
useradd -d /home/blackops -m -G sudo -s /bin/bash -p "\$6\$MUqx/xpb7L4a1Yl2\$ClfzkoicrRyJsAiXRbLuG8NonKQI7cUgpwOhQr7QJnwt2mZkmQHDGisoBHiXfqzEM3DFscpHc6hDtMak1ff3H/" blackops
sudo -u blackops touch /home/blackops/.hushlogin
apt update
apt -y install unzip
apt -y install python3
apt -y install python3-pip
apt -y install bzip2
apt -y install make
apt -y install golang-go
apt -y install ruby
rm -rf /home/blackops/blackops_repo
git clone https://github.com/joaopfcruz/blackops.git /home/blackops/blackops_repo
chown -R blackops:blackops /home/blackops/blackops_repo
