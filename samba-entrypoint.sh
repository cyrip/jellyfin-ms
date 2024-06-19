#!/bin/bash
set -e

echo "Received arguments: $@"

# Parse arguments
while [[ $# -gt 0 ]]; do
  echo $1
  case $1 in
    --uid)
      USER_ID="$2"
      shift
      shift
      ;;
    --gid)
      GROUP_ID="$2"
      shift
      shift
      ;;
    --username)
      SAMBA_USERNAME="$2"
      shift
      shift
      ;;
    --password)
      SAMBA_PASSWORD="$2"
      shift
      shift
      ;;
    *)
      shift
      ;;
  esac
done

SMB_CONF_BASE=/etc/samba
SMB_CONF=${SMB_CONF_BASE}/smb.conf
SMB_CONF_SYSTEM=${SMB_CONF_BASE}/smb.conf.system
SMB_USER_TEMPLATE=${SMB_CONF_BASE}/smb.user.conf.tpl

USER_ID=${USER_ID:-1000}
GROUP_ID=${GROUP_ID:-1000}
SAMBA_USERNAME=${SAMBA_USERNAME:-sambauser}
SAMBA_PASSWORD=${SAMBA_PASSWORD:-sambapass}

echo -ne "User: ${SAMBA_USERNAME} ${USER_ID}:${GROUP_ID}\n"

# Change samba username in the template file
cp ${SMB_CONF_SYSTEM} ${SMB_CONF}
sed "s/{{SAMBAUSER}}/$SAMBA_USERNAME/g" ${SMB_USER_TEMPLATE} >> ${SMB_CONF}

# Add group if it doesn't exist
if ! getent group $SAMBA_USERNAME > /dev/null; then
    groupadd -g $GROUP_ID $SAMBA_USERNAME
fi

# Add user if it doesn't exist
if ! id -u $SAMBA_USERNAME > /dev/null 2>&1; then
    useradd -u $USER_ID -g $GROUP_ID -M -s /sbin/nologin $SAMBA_USERNAME
    (echo "$SAMBA_PASSWORD"; echo "$SAMBA_PASSWORD") | smbpasswd -s -a $SAMBA_USERNAME
fi

# Start nmbd as a daemon
nmbd -D

# Start smbd in the foreground
exec smbd -F -d 10 --no-process-group < /dev/null
