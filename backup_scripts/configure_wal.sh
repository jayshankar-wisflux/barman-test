#!/bin/bash

if [[ -f "$PGDATA/postgresql.conf" ]];
then
	if grep -q barman-cloud-wal-archive $PGDATA/postgresql.conf;
	then
		echo "WAL backup already configured"
	else
		echo "Configuring WAL backup"
		echo "wal_level = replica" >> $PGDATA/postgresql.conf
		echo "archive_mode = on" >> $PGDATA/postgresql.conf
		echo "archive_timeout = 60" >> $PGDATA/postgresql.conf
		echo "archive_command = 'barman-cloud-wal-archive  -j s3://$BACKUP_BUCKET/ $SERVER_NAME %p'" >> $PGDATA/postgresql.conf
		# echo "archive_command = 'barman-cloud-wal-archive --endpoint-url $AWS_ENDPOINT -j s3://$BACKUP_BUCKET/ $SERVER_NAME %p'" >> $PGDATA/postgresql.conf
	fi
else
	echo "No postgresql.conf file, skipping wal configuration."
fi
