#!/bin/sh

WORKDIR=/opt
mkdir -p $WORKDIR/logs
LOGS=$WORKDIR/logs/install-docker.log

if [ -z "$1" ];then
  echo "Usage : $0 <MoinMoin Version>"
  echo "Exiting ..."
  exit 1
fi

MM_VERSION=$1
MM_PATH=${WORKDIR}/moin-${MM_VERSION}

echo "===== [$(date +%F)] MoinMoin ($MM_VERSION) Install Script =====" | tee -a $LOGS

echo "Installing necessary packages ..." | tee -a $LOGS
apt-get -y install python wget >> $LOGS

echo "Downloading Moinmoin package" | tee -a $LOGS
cd /tmp
wget -nv http://static.moinmo.in/files/moin-$MM_VERSION.tar.gz 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Error while downloading MoinMoin $MM_VERSION from http://static.moinmo.in/files/moin-$MM_VERSION.tar.gz" | tee -a $LOGS
  exit 1
fi

echo "Untar archive to $WORKDIR" | tee -a $LOGS
tar -xvzf moin-$MM_VERSION.tar.gz -C $WORKDIR >> $LOGS
rm -f moin-$MM_VERSION.tar.gz

echo "Installing moin ..." |tee -a $LOGS
cd /opt/moin-$MM_VERSION
python setup.py install --force --record=/opt/logs/install-moin.log 
rm -Rf $WORKDIR/moin-$MM_VERSION

echo "Create user moin" | tee -a $LOGS
useradd -Mr moin

echo "Change $WORKDIR owner..." | tee -a $LOGS
mkdir -p $WORKDIR/moin/
chown moin. $WORKDIR -R

echo "Writing Supervisor Conf" | tee -a $LOGS 
echo "[program:moinmoin]\ncommand=/bin/bash /opt/start.sh\nuser=moin\nredirect_stderr=true" > /etc/supervisor/conf.d/moin.conf 

echo "$MM_VERSION" >$WORKDIR/version
