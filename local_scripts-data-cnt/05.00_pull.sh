source ../data-cnt-backup-config.sh

if [ $# -lt 1 ];
then
    echo "+ $0: Too few arguments!"
    echo "+ use something like:"
    echo "+ $0 <docker image>" 
    echo "+ $0 ${DATA_CONT_NAME} reliableembeddedsystems/${DATA_CONT_NAME}:${TAG}"
    exit
fi

DATA_CONTAINER_NAME=$1
UPSTREAM_IMAGE_NAME=$2

set -x
# Run the data container with the data-backup image:
#docker run -v /folderToBackup --entrypoint "bin/sh" --name data-container repo/data-backup:${VERSION}
docker run -v ${DIR_OF_RUNNING_CONT_TO_BACKUP} --entrypoint "bin/sh" --name ${DATA_CONTAINER_NAME} ${UPSTREAM_IMAGE_NAME}
set +x
