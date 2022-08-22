FROM postgres:14

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update  -qq && \
	apt-get install -qqy cron rsyslog barman-cli

COPY startup.sh /startup.sh
COPY initdb.sh /docker-entrypoint-initdb.d/initdb.sh
COPY postgres-crontab /etc/cron.d/postgres-crontab
COPY backup_scripts/backup.sh /backup_scripts/backup.sh
COPY backup_scripts/restore.sh /backup_scripts/restore.sh
COPY backup_scripts/list.sh /backup_scripts/list.sh
COPY backup_scripts/configure_wal.sh /backup_scripts/configure_wal.sh

RUN chmod 0644 /etc/cron.d/postgres-crontab && crontab /etc/cron.d/postgres-crontab
RUN chmod +x /backup_scripts/backup.sh /backup_scripts/restore.sh /backup_scripts/list.sh /backup_scripts/configure_wal.sh /startup.sh /docker-entrypoint-initdb.d/initdb.sh
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

ENTRYPOINT ["/startup.sh"]
CMD ["postgres"]

# ENV AWS_ENDPOINT https://junctiontestbucket.s3.ap-south-1.amazonaws.com
# ENV AWS_ACCESS_KEY_ID AKIAU7QZATXO62YNEG54
# ENV AWS_SECRET_ACCESS_KEY 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
# ENV SERVER_NAME	postgres-db
# ENV BACKUP_BUCKET junctiontestbucket/jaytestdb
# ENV RUNNING_MODE BACKUP
# # ENV RUNNING_MODE RECOVERY
# ENV POSTGRES_USER jayuser
# ENV POSTGRES_PASSWORD jaypassword

