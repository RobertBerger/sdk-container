source ../container-name.sh
SDKDIR="/home/${USER}/projects/sdk"

if [ $# -lt 1 ];
then
    echo "+ $0: Too few arguments!"
    echo "+ use something like:"
    echo "+ $0 <docker image>" 
    echo "+ $0 reslocal/${CONTAINER_NAME}"
    exit
fi

IMAGE_NAME=$1

# remove currently running containers
set -x
ID_TO_KILL=$(docker ps -a -q  --filter ancestor=$1)

docker ps -a
docker stop ${ID_TO_KILL}
docker rm -f ${ID_TO_KILL}
docker ps -a

# -t : Allocate a pseudo-tty
# -i : Keep STDIN open even if not attached
# -d : To start a container in detached mode, you use -d=true or just -d option.
# -p : publish port PUBLIC_PORT:INTERNAL_PORT
# -l : ??? without it no root@1928719827
# --cap-drop=all: drop all (root) capabilites

docker run -e TARGET_UID=$(id -u ${USER}) -e TARGET_GID=$(stat -c "%g" /home/${USER}) -v /opt:/opt -v /workdir:/workdir -v /home/${USER}/projects:/projects -v /home/${USER}:/student -v /tftpboot:/tftpboot --interactive --tty --entrypoint=/usr/bin/entrypoint.sh ${IMAGE_NAME} --login
set +x
