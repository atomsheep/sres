#!/bin/sh

TIME_NOW="`date +%Y-%m-%d-%H-%M-%S`"
APP_NAME=sres
SERVER_NAME=karimu.otago.ac.nz
BACKUP_DIR=/home/richard/updates/$APP_NAME/$TIME_NOW

if [[ -z "$1" || "$1" != "deploy" ]]; then
    echo To deploy application \"$APP_NAME\" to server \"$SERVER_NAME\", run:
    echo
    echo $0 deploy
    echo
fi

# backup first
cp target/$APP_NAME/WEB-INF/web.xml /tmp/web.xml
cp target/$APP_NAME/WEB-INF/classes/log4j.properties /tmp/log4j.properties
cp target/$APP_NAME/WEB-INF/classes/config.properties /tmp/config.properties

# use the one for server
cp target/$APP_NAME/WEB-INF/web_server.xml target/$APP_NAME/WEB-INF/web.xml
cp target/$APP_NAME/WEB-INF/classes/log4j_server.properties target/$APP_NAME/WEB-INF/classes/log4j.properties
cp target/$APP_NAME/WEB-INF/classes/config_server.properties target/$APP_NAME/WEB-INF/classes/config.properties

if [[ -z "$1" || "$1" != "deploy" ]]; then
    echo DRY RUN
    echo rsync -e ssh -n -acvz --delete --backup --backup-dir=$BACKUP_DIR --exclude uploaded target/$APP_NAME/ $SERVER_NAME:webapps/$APP_NAME/
    rsync -e ssh -n -acvz --delete --backup --backup-dir=$BACKUP_DIR --exclude uploaded target/$APP_NAME/ $SERVER_NAME:webapps/$APP_NAME/
else
    echo deploying application \"$APP_NAME\" to server \"$SERVER_NAME\"
    echo rsync -e ssh -acvz --delete --backup --backup-dir=$BACKUP_DIR --exclude uploaded target/$APP_NAME/ $SERVER_NAME:webapps/$APP_NAME/
    rsync -e ssh -acvz --delete --backup --backup-dir=$BACKUP_DIR --exclude uploaded target/$APP_NAME/ $SERVER_NAME:webapps/$APP_NAME/
fi

# restore
cp /tmp/web.xml target/$APP_NAME/WEB-INF/web.xml
cp /tmp/log4j.properties target/$APP_NAME/WEB-INF/classes/log4j.properties
cp /tmp/config.properties target/$APP_NAME/WEB-INF/classes/config.properties
