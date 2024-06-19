#!/bin/bash

uid=$(cat .env | grep MEDIA_USER_UID | sed 's/^[^=]*=//')
gid=$(cat .env | grep MEDIA_USER_GID | sed 's/^[^=]*=//')

for d in "cache" "config" "media" "samba";do
	echo -ne "Chown ${d} to ${uid}:${gid}\n"
	sudo chown ${uid}:${gid} -R $d
done
