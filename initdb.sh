#!/bin/bash

if [[ $RUNNING_MODE = 'BACKUP' ]];
then
	/backup_scripts/configure_wal.sh
fi
