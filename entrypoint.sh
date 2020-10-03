#!/bin/bash

useradd --shell /bin/bash -u ${TARGET_UID} -o -c "" -m sdk

EXISTS=$(cat /etc/group | grep :$TARGET_GID: | wc -l)

  # Create new group using target GID and add sdk user
  if [ $EXISTS == "0" ]; then
    groupadd -g $TARGET_GID sdkgroup
    usermod -a -G sdkgroup sdk
  else   
  # GID exists, find group name and add
   GROUP=$(getent group $TARGET_GID | cut -d: -f1)
   usermod -a -G $GROUP sdk
  fi

/usr/sbin/gosu sdk /bin/bash
