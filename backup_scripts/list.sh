#!/bin/bash

barman-cloud-backup-list --endpoint-url $AWS_ENDPOINT s3://$BACKUP_BUCKET $SERVER_NAME
