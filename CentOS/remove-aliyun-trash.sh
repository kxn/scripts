#!/bin/sh
cd /tmp
wget http://update.aegis.aliyun.com/download/uninstall.sh
chmod +x uninstall.sh
./uninstall.sh
wget http://update.aegis.aliyun.com/download/quartz_uninstall.sh
chmod +x quartz_uninstall.sh
./quartz_uninstall.sh

pkill aliyun-service
rm -fr /etc/init.d/agentwatch /usr/sbin/aliyun-service
rm -rf /usr/local/aegis*

systemctl stop CmsGoAgent
systemctl disable CmsGoAgent
rm -rf /usr/local/cloudmonitor
rm -rf /etc/rc.d/init.d/cloudmonitor

rm -f /etc/systemd/system/CmsGoAgent.service
rm -f /etc/systemd/system/aliyun.service
systemctl daemon-reload

