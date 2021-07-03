source ../data-cnt-backup-config.sh
echo "reliableembeddedsystems/${DATA_CONT_NAME}:${TAG}"
echo "press <ENTER> to go on"
read r

if [ "$#" -ne 1 ]; then
    echo "Usage:"
    echo "./special_tag_push.sh <tag>"
    echo "./special_tag_push.sh ${TAG}"
    exit
fi

set -x
docker images
docker tag reslocal/${DATA_CONT_NAME}:${TAG} reliableembeddedsystems/${DATA_CONT_NAME}:$1
docker images
docker login --username reliableembeddedsystems
docker push reliableembeddedsystems/${DATA_CONT_NAME}:$1
set +x
