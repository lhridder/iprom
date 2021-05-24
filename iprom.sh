echo "  _____                           ";
echo " |_   _|                          ";
echo "   | |  _ __  _ __ ___  _ __ ___  ";
echo "   | | | '_ \| '__/ _ \| '_ \` _ \ ";
echo "  _| |_| |_) | | | (_) | | | | | |";
echo " |_____| .__/|_|  \___/|_| |_| |_|";
echo "       | |                        ";
echo "       |_|                        ";

mkdir /srv/nodeexporter
cd /srv/nodeexporter
wget https://github.com/prometheus/node_exporter/releases/download/v1.1.2/node_exporter-1.1.2.linux-amd64.tar.gz
tar -xvf node_exporter-1.1.2.linux-amd64.tar.gz
mv node_exporter-1.1.2.linux-amd64/node_exporter ./

cat > /etc/systemd/system/nodeexporter.service <<- 'EOF'
[Unit]
Description=Node exporter

[Service]
User=root
Group=root
WorkingDirectory=/srv/nodeexporter
ExecStart=/srv/nodeexporter/node_exporter --collector.disable-defaults --collector.cpu --collector.cpufreq --collector.filesystem --collector.meminfo --collector.netdev --collector.time --collector.diskstats --collector.stat

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now nodeexporter
SERVER_IP=$(curl -s http://checkip.amazonaws.com)

echo "Connect this ip to prometheus: $SERVER_IP with port 9100"
