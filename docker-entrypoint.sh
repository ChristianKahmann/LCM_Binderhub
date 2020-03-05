#!/bin/bash
# #create new user with custom password
# if [ -z "$RSTUDIO_USERNAME" ] || [ -z "$RSTUDIO_PASSWORD" ];
# then echo "at least one custom parameter missing to set custom username"
# else  
# 	echo "Creating new User"
# 	useradd -m -p $(openssl passwd -1 $RSTUDIO_PASSWORD) $RSTUDIO_USERNAME
# 	chmod -R 777 /home/$RSTUDIO_USERNAME
# fi
# 
# #start solr
# su - solr -c "/opt/solr/bin/solr start -m 2g"
# 
# chmod -R 777 /home/rstudio/ilcm/
# 
# #create solr collection if its not existing already
# if [ -d /opt/solr/server/solr/iLCM ];
# then echo 'Collection already exists';
# else 
# 	su - solr -c "/opt/solr/bin/solr create_core -c iLCM -p 8983 -d /store/solr/config/iLCM";
# fi
# 
# 
# #start database
# /usr/bin/mysqld_safe --basedir=/usr & sleep 2s
# 
# 
# # init rstudio and shiny server
# /init

set -e
/opt/solr/bin/solr start  
mysqld &
/opt/solr/bin/solr create_core -c iLCM -p 8983 -d /store/solr/config/iLCM & sleep 2s
exec "$@"
