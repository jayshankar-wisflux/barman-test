#!/bin/bash

if [[ $RUNNING_MODE = 'RECOVERY' ]];
then
	if [[ -f "$PGDATA/PG_VERSION" ]];
	then
		echo "Database already recovered. Change RUNNING_MODE to BACKUP if you want to enable backups."
	else
		echo "Restoring"
		/backup_scripts/restore.sh
	fi
fi

if [[ $RUNNING_MODE = 'BACKUP' ]];
then
	echo "Configuring backup"
	# turn on bash's job control
	set -m

	# extract environment variables for cron
	printenv | sed 's/^\(.*\)$/export \1/g' > /root/project_env.sh

	# Start the helper processes
	service rsyslog start
	service cron start

	/backup_scripts/configure_wal.sh
fi

exec /usr/local/bin/docker-entrypoint.sh "$@"
