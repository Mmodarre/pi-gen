sed -i '$ d' /etc/hosts
echo "127.0.1.1       `cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2` " >> /etc/hosts
echo `cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2` > /etc/hostname
echo  `cat /proc/cpuinfo | grep Serial | cut -d ' ' -f 2` > /proc/sys/kernel/hostname
