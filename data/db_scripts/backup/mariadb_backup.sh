#!/bin/bash
# FuelOpt database backup script

################################################################
################## CONSTANTS DECLARATION  ########################
 
DB_BACKUP_PATH='/home/ec2-user/mariadb/backup'
MYSQL_HOST='127.0.0.1'
MYSQL_PORT='3306'
MYSQL_USER='user'
MYSQL_PASSWORD='password'
DATABASE_NAME='db_fuelopt'
BACKUP_RETAIN_DAYS=14
TODAY=`date +"%d_%b_%Y"`

#################################################################

mkdir -p ${DB_BACKUP_PATH}/${TODAY}
echo "Backup started for database - ${DATABASE_NAME}"


mysqldump -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   -p${MYSQL_PASSWORD} \
   ${DATABASE_NAME} | gzip > ${DB_BACKUP_PATH}/${TODAY}/${DATABASE_NAME}-${TODAY}.sql.gz

if [ $? -eq 0 ]; then
  echo "Database backup successfully completed"
else
  echo "Error found during backup"
  exit 1
fi


##### Remove backups older than {BACKUP_RETAIN_DAYS} days #####

DBDELDATE=`date +"%d%b%Y" --date="${BACKUP_RETAIN_DAYS} days ago"`

if [ ! -z ${DB_BACKUP_PATH} ]; then
      cd ${DB_BACKUP_PATH}
      if [ ! -z ${DBDELDATE} ] && [ -d ${DBDELDATE} ]; then
            rm -rf ${DBDELDATE}
      fi
fi
