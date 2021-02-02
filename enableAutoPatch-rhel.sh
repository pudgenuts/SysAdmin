#!/bin/bash 

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi



/bin/yum -y install yum-cron

if [ ! -f /etc/yum/yum-cron.conf.install ] ; then
        /bin/cp /etc/yum/yum-cron.conf /etc/yum/yum-cron.conf.install
fi

cat /etc/yum/yum-cron.conf.install |\
sed -e's/^update_cmd.*/update_cmd = default/g' | \
sed -e's/^download_updates.*/download_updates = no/g'| \
sed -e's/^apply_updates.*/apply_updates = yes/g' \
> /etc/yum/yum-cron.conf


/bin/systemctl enable yum-cron
/binsystemctl start yum-cron

/bin/yum -y update 
