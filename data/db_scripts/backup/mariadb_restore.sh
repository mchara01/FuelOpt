#!/bin/bash
# FuelOpt database restoration script

################################################################
################## CONSTANTS DECLARATION  ######################
 
DB_BACKUP_PATH='/home/ec2-user/mariadb/backup/03_Nov_2021'
MYSQL_HOST='127.0.0.1'
MYSQL_PORT='3333'
MYSQL_USER='fuelopt_main'
MYSQL_PASSWORD='N;vZu!93Gh'
DATABASE_NAME='db_fuelopt'

#################################################################

echo "Restore backup to database - ${DATABASE_NAME}"

myloader -h ${MYSQL_HOST} \
   -P ${MYSQL_PORT} \
   -u ${MYSQL_USER} \
   --password ${MYSQL_PASSWORD} \
   --threads=8 \
   --directory=${DB_BACKUP_PATH}

if [ $? -eq 0 ]; then
  echo "Database restoration successfully completed"
else
  echo "Error found during restoration"
  exit 1
fi
