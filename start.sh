#!/bin/sh

WORKDIR=/opt
mkdir -p $WORKDIR/logs
LOGS=$WORKDIR/logs/start.log
WIKI_INSTANCE_NAME=${WIKI_INSTANCE:=wiki-instance}

WIKI_PATH=$WORKDIR/moin/$WIKI_INSTANCE_NAME
MOIN_PATH=/usr/local/share/moin
WIKI_NAME=${WIKI_NAME:=$WIKI_INSTANCE_NAME wiki}

MM_VERSION=$(cat $WORKDIR/version)
MM_PATH=${WORKDIR}/moin-${MM_VERSION}

echo "===== [$(date +%F)] MoinMoin ($MM_VERSION) Start Script =====" | tee -a $LOGS

if [ ! -d $WIKI_PATH ]
then
	echo "===== [$(date +%F)] MoinMoin ($MM_VERSION) Init instance =====" | tee -a $LOGS
	echo "Create instance directory $WIKI_PATH" | tee -a $LOGS
	mkdir -p $WIKI_PATH

	echo "Copying files to instance..." | tee -a $LOGS
	cp -v $MOIN_PATH/config/wikiconfig.py $WIKI_PATH | tee -a $LOGS
	cp -rv $MOIN_PATH/data $WIKI_PATH | tee -a $LOGS
	cp -rv $MOIN_PATH/underlay $WIKI_PATH | tee -a $LOGS
	cp -rv /usr/local/lib/python2.7/dist-packages/MoinMoin/web/static/htdocs $WIKI_PATH | tee -a $LOGS

	echo "Change rights..." | tee -a $LOGS
	chown moin. -R $WIKI_PATH
	chmod 750 -R $WIKI_PATH

	sed -i "s#instance_dir = wikiconfig_dir#instance_dir = '$WIKI_PATH'#" /opt/moin/chris/wikiconfig.py
	[ ! -z "$WIKI_NAME" ] && echo "Wiki Name $WIKI_NAME" && sed -i "s#sitename = .*#sitename = u'$WIKI_NAME'#" /opt/moin/chris/wikiconfig.py

fi


/usr/bin/python /usr/local/bin/moin --config-dir=$WIKI_PATH server standalone --hostname="" --docs=$WIKI_PATH/htdocs 
