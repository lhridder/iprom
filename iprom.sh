#!/bin/bash

echo "  _____                           ";
echo " |_   _|                          ";
echo "   | |  _ __  _ __ ___  _ __ ___  ";
echo "   | | | '_ \| '__/ _ \| '_ \` _ \ ";
echo "  _| |_| |_) | | | (_) | | | | | |";
echo " |_____| .__/|_|  \___/|_| |_| |_|";
echo "       | |                        ";
echo "       |_|                        ";

echo "Download nodeexporter"
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.0/node_exporter-1.6.0.linux-amd64.tar.gz
tar -xvf node_exporter-1.6.0.linux-amd64.tar.gz
mv node_exporter-1.6.0.linux-amd64/node_exporter /usr/sbin/node_exporter

echo "Adding nodeexporter to systemd"
cat > /etc/systemd/system/nodeexporter.service <<- 'EOF'
[Unit]
Description=Node exporter

[Service]
User=root
Group=root
ExecStart=/usr/sbin/node_exporter --collector.disable-defaults --collector.cpu --collector.cpufreq --collector.filesystem --collector.meminfo --collector.netdev --collector.time --collector.diskstats --collector.stat --collector.mdadm

[Install]
WantedBy=multi-user.target
EOF

echo "Starting service"
systemctl daemon-reload
systemctl enable --now nodeexporter

SERVER_IP=$(curl -s http://checkip.amazonaws.com)
echo "Add this endpoint in your Prometheus instance: http://$SERVER_IP:9100"
