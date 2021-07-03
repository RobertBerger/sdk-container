source ../data-cnt-backup-config.sh
echo "reliableembeddedsystems/${DATA_CONT_NAME}:latest"
echo "press <ENTER> to go on"
read r
set -x
docker images
docker tag reslocal/${DATA_CONT_NAME}:${TAG} reliableembeddedsystems/${DATA_CONT_NAME}:latest
docker images
docker login --username reliableembeddedsystems
docker push reliableembeddedsystems/${DATA_CONT_NAME}:latest
set +x
