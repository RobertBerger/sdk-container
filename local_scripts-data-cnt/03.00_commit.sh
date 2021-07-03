source ../data-cnt-backup-config.sh

if [ $# -lt 1 ];
then
    echo "+ $0: Too few arguments!"
    echo "+ use something like:"
    echo "+ $0 <docker image>" 
    echo "+ $0 ${RUNNING_DATA_CONT_BACKUP_NAME} reslocal/${DATA_CONT_NAME}:${TAG}"
    exit
fi

BACKUP_IMAGE_NAME=$1
UPSTREAM_IMAGE_NAME=$2

set -x
#docker commit data-backup repo/data-backup:$VERSION
docker commit ${BACKUP_IMAGE_NAME} ${UPSTREAM_IMAGE_NAME}
set +x
