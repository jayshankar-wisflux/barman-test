#!/bin/bash
echo "Base backup started -------------------------------"
barman-cloud-backup -U $POSTGRES_USER -j --immediate-checkpoint s3://$BACKUP_BUCKET $SERVER_NAME
echo "Base backup done ----------------------------------"