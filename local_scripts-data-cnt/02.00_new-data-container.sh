#!/bin/bash
source ../data-cnt-backup-config.sh
set -x
docker rm -f ${RUNNING_DATA_CONT_BACKUP_NAME}
docker run -d -v $(pwd):/backup --name ${RUNNING_DATA_CONT_BACKUP_NAME} ubuntu /bin/sh -c "cd / && tar xvf /backup/backup.tar"
set +x
