#!/bin/bash

if [[ $# < 1 ]]; then
    echo "Usage: ./deploy (username on eridu)"
    exit 1
fi
#what happens locally
if [[ $(hostname) != 'eridu' ]]; then
    rsync -rve ssh --delete --exclude=tmp --exclude=.git `pwd` $1@getpatronizeme.com:/home/pm/serverdeploy/
    ssh -t $1@getpatronizeme.com "sudo chown -R :patronizeme /home/pm/serverdeploy/PatronizeMe/* && sudo chmod -R 777 /home/pm/serverdeploy/PatronizeMe/* && /home/pm/serverdeploy/PatronizeMe/deploy.sh $1"
fi
#what happens remotely
if [[ $(hostname) == 'eridu' ]]; then

        SERVER_PATH="/home/pm/serverdeploy/PatronizeMe/"

        # Restart server
        echo 'Restarting server'

        cd $SERVER_PATH
        PID=$(ps -aux | grep puma | awk  '{print $2}' | sed -sn 1p)
        echo $PID
        kill -KILL $(ps -aux | grep puma | awk  '{print $2}' | sed -sn 1p)
        pwd
        bundle install
        bin/rails server

        # Done
        echo 'Finished'


fi
