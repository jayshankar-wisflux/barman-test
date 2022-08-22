#!/bin/bash

backups=`barman-cloud-backup-list s3://$BACKUP_BUCKET $SERVER_NAME`
# backups=`barman-cloud-backup-list --endpoint-url $AWS_ENDPOINT s3://$BACKUP_BUCKET $SERVER_NAME`
#echo "SELECT BACKUP"

tokens=(${backups//\w/ })
tokenCount=${#tokens[@]}
index=8
count=1
options=()
while [ $index -lt $tokenCount ]
do
	#echo "${count}. ${tokens[$index]}"
	options+=(${tokens[$index]})
	index=$((index + 4))
	count=$((count + 1))
done

#echo -ne "Selction: "
#read -r selection
selection=${#options[@]}

selectedBackup=${options[(($selection -1))]}

echo "Restoring $selectedBackup"

# barman-cloud-restore  s3://$BACKUP_BUCKET $SERVER_NAME 000000010000000000000004.bz2 $PGDATA
barman-cloud-restore  s3://$BACKUP_BUCKET $SERVER_NAME $selectedBackup $PGDATA

touch $PGDATA/recovery.signal	

echo "archive_command = 'cd .'"  >> $PGDATA/postgresql.conf
echo "restore_command = 'barman-cloud-wal-restore  s3://$BACKUP_BUCKET $SERVER_NAME %f %p'" >> $PGDATA/postgresql.conf
echo "recovery_target_timeline = 'latest'" >> $PGDATA/postgresql.conf
tail $PGDATA/postgresql.conf

echo "host all all all md5"  >> $PGDATA/pg_hba.conf