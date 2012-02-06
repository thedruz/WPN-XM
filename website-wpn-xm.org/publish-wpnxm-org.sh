#!/bin/sh

#
# Publishes "wpn-xm.org".
#
# This script pulls the WPN-XM master branch zip from github.
# Then moves the "website-wpm-xm.org" folder.
# to the public folder of the webserver.
#
# Do not forget to sync "develop" with "master".
#
# chmod +x publish-wpnxm-org.sh
#

# pull master branch from github
wget https://github.com/jakoch/WPN-XM/zipball/master --no-check-certificate -O wpnxm-github-master.zip

# guess what...
unzip wpnxm-github-master.zip

# rename the crappy github hash directory name
mv jakoch-WPN-XM-* wpnxm

# remove *this file* for safety reasons
#rm wpnxm/website-wpn-xm.org/publish-wpnxm-org.sh

# publish, by copying the files to the webservers public folder
cp -r wpnxm/website-wpn-xm.org/* /var/www/webs/KochSST/wpnxm

# cleanup
rm wpnxm-github-master.zip
rm -r wpnxm