#!/bin/bash
source ../data-cnt-backup-config.sh
docker run --rm --volumes-from ${RUNNING_CONT_TO_BACKUP} --name tmp-backup -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar ${DIR_OF_RUNNING_CONT_TO_BACKUP}
