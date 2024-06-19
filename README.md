# JellyfinSMB Media server

### Ensure that system directory and content has the proper owner - if it is not your current user
```sh
sudo groupadd -g 1010 media && sudo useradd -u 1010 -g 1010 -s /sbin/nologin -m media
for d in "cache" "config" "media" "samba";do sudo chown media:media -R $d;done
```
### Set the uid & gid envs samba and Jellyfin will run with this user privileges
```sh
MEDIA_USER_UID=1010
MEDIA_USER_GID=1010
```
### Set user name and password for samba share in .env
You can connect from your windows machine or any SMB compilant device to upload movies
The samba share is the ./media directory and Jellyfin will serve the movies from there
```sh
SAMBA_USER=admin
SAMBA_USER_PASS=admin
```

### Start the servers - later I will create a sysdemd config for it
```sh
make run # OR
docker-compose up # OR in background
docker-compose up -d
```

### You can reach the MS with SMB client and you need to login with the given smb user and password
```sh
sudo apt-get update && \
     apt install smbclient cifs-utils

sudo mkdir -p /mnt/media

sudo mount.cifs //192.168.0.200/media /mnt/media -o username=admin,password=admin

\\192.168.0.200 # from windows machine
```

### In a browser tab go to and create your user and password and some settings
```sh
http://192.168.0.200
```

### Install Jellyfin mobile application and set the server URL to http://192.168.0.200:8096

### Clean the files
```sh
make clean
```
