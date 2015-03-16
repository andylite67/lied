# Install
``sudp apt-get install nodejs``

``sudo npm install -g supervisor LiveScript``

``npm install`` # in the lied folder


# Develop
``sudo gem install compass bootstrap-sass`

# Server

``npm install -g LiveScript forever``

``mkdir ~/git/lied/
cd ~/git/lied/
git init --bare``

## /etc/init.d/lied
``#!/bin/sh

case "$1" in
  start)
  exec forever -c lsc --sourceDir=/var/www/vhosts/ecg-berlin.de/lied.ecg-berlin.de/ start web.ls
  ;;

  stop)
  exec forever -c lsc --sourceDir=/var/www/vhosts/ecg-berlin.de/lied.ecg-berlin.de/ stop web.ls
  ;;
esac

exit 0``


``chmox +x /etc/init.d/lied``

## ~/git/lied/hooks/post-receive

``echo "********************"
echo "Post receive hook: Updating website"                       
echo "********************"

#Change to working git repository to pull changes from bare repository
cd /var/www/vhosts/ecg-berlin.de/lied.ecg-berlin.de || exit 
unset GIT_DIR
git pull origin master
sh compile.sh``

