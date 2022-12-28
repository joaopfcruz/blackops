#!/bin/bash

touch ~/.hushlogin
echo "127.0.0.1 $(hostname)" >> /etc/hosts
printf "LANG=en_US.UTF-8\nLC_ALL=en_US.UTF-8" > /etc/default/locale
apt update
useradd -d /home/blackops -m -G sudo -s /bin/bash -p "\$6\$foi8G0Lu2xTnf3ac\$z4maNK3VG.lkR0IRx4kaDnQOs4J91pqkF39XFrWTgcWybwGF/8erGV4sktOiNy/AuG4OZ1vv.ftEXX.NxrcHi/" blackops
sudo -u blackops touch /home/blackops/.hushlogin
apt -y install unzip
apt -y install python3-pip
apt -y install bzip2
apt -y install make
rm -rf /home/blackops/blackops_repo
git clone https://github.com/joaopfcruz/blackops.git /home/blackops/blackops_repo
chown -R blackops:blackops /home/blackops/blackops_repo
