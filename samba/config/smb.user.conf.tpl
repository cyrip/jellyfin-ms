# user specified config, it will be merged with the main smb.conf file
[media]
   path = /media
   browsable = yes
   read only = no
   guest ok = no
   veto files = /.apdisk/.DS_Store/.TemporaryItems/.Trashes/desktop.ini/ehthumbs.db/Network Trash Folder/Temporary Items/Thumbs.db/
   delete veto files = yes
   valid users = {{SAMBAUSER}}
   hide dot files = yes
