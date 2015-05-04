#!/bin/sh

WORKDIR=/opt


if [ -z "$1" ];then
  echo "Usage : $0 <MoinMoin Version"
  echo "Exiting ..."
  exit 1
fi

MM_VERSION=$1

echo "===== [$(date +%F)] MoinMoin ($MM_VERSION) Install Script =====" | tee -a $WORKDIR/install.log

echo "Installing necessary packages ..." | tee -a $WORKDIR/install.log
apt-get -y install python wget


echo "Downloading Moinmoin package" | tee -a $WORKDIR/install.log
cd /tmp
wget -nv http://static.moinmo.in/files/moin-$MM_VERSION.tar.gz
if [ $? -neq 0 ]; then
  echo "Error while downloading MoinMoin $MM_VERSION from http://static.moinmo.in/files/moin-$MM_VERSION.tar.gz" | tee -a $WORKDIR/install.log
  exit 1
fi

echo "Untar archive to $WORKDIR" | tee -a $WORKDIR/install.log
tar -xvzf moin-$MM_VERSION.tar.gz -C $WORKDIR
rm -f moin-$MM_VERSION.tar.gz
ln -s $WORKDIR/moin-$MM_VERSION $WORKDIR/moin-current

echo "Modification of conf to listen on 0.0.0.0" | tee -a $WORKDIR/install.log
cd $WORKDIR/moin-current;
sed -i".ori" "s/hostname = 'localhost'/hostname = '0.0.0.0'/g" wikiserverconfig.py

echo "Create user moin" | tee -a $WORKDIR/install.log
useradd -Mr moin

echo "Change rights..." | tee -a $WORKDIR/install.log
chown moin. -R /opt/moin-current/wiki/data /opt/moin-current/wiki/underlay
chmod 750 /opt/moin-current/wiki/data /opt/moin-current/wiki/data/pages

echo "Create command line moin script ..." | tee -a $WORKDIR/install.log
echo -e "#!/usr/bin/env python\n# -*- coding: iso-8859-1 -*-\nimport sys, os\nsys.path.insert(0, '/opt/moin-1.9.8')\nsys.path.insert(0, '/opt/moin-1.9.8/wiki/config/wikiconfig.py')\nfrom MoinMoin.script.moin import run\nrun()" > /opt/moin_docker

chown moin. /opt/moin-current/wiki/data /opt/moin-current/wiki/data/pages /opt/moin-current/wiki/underlay /opt/moin-current/wiki/underlay/pages
chown moin. -R /opt/moin-current/wiki/data/pages /opt/moin-current/wiki/underlay/pages
chmod 750 /opt/moin-current/wiki/data /opt/moin-current/wiki/data/pages

echo "Writing Supervisor Conf" | tee -a $WORKDIR/install.log 
echo "[program:moinmoin]\ncommand=/usr/bin/python /opt/moin-$MM_VERSION/wikiserver.py\nuser=moin\nredirect_stderr=true" > /etc/supervisor/conf.d/moin.conf 
