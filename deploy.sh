#!/bin/bash

if [[ $# < 1 ]]; then
    echo "Usage: ./deploy (username on eridu)"
    exit 1
fi
#what happens locally
if [[ $(hostname) != 'eridu' ]]; then
    rsync -rvzhe ssh --delete --exclude=tmp `pwd` $1@getpatronizeme.com:/home/pm/serverdeploy/
    ssh $1@getpatronizeme.com bash "/home/pm/serverdeploy/PatronizeMe/deploy.sh eridu"
fi
#what happens remotely
if [[ $(hostname) == 'eridu' ]]; then

        SERVER_PATH="/home/pm/serverdeploy/PatronizeMe/"

        # Restart server
        echo 'Restarting server'

        cd $SERVER_PATH
        pwd
        bundle install
        bin/rails server

        # Done
        echo 'Finished'


fi
