#! /bin/sh

containerName=mongodb
imageName=mongo

while getopts :f OPTION
do
    case $OPTION in
	f)
	    force=1
	    ;;
	*)
	    echo "invalid option $OPTARG" 1>&2
	    exit 1
    esac
done

if [ -n "$force" ] || pullLatestDocker.sh -i $imageName
then
    echo "re-building container $containerName"

    docker stop $containerName
    docker rm $containerName

    # tag image with today's date
    today=$(date '+%Y%m%d')
    docker tag $imageName:latest $imageName:$today

    # create data directory
    [ -d data ] || mkdir data
    [ -d .mongodb ] || mkdir .mongodb
    [ -f .dbshell ] || touch .dbshell

    # start 'er up
    docker run --name $containerName -v `pwd`/data:/data/db -v `pwd`/.mongodb:/.mongodb -v `pwd`/.dbshell:/.dbshell -p 27017:27017 --health-cmd="echo 'db.runCommand(\"ping\").ok' | mongosh localhost:27017/test --quiet" -d --user $(id -u):$(id -g) $imageName:$today
else
    echo "no new image so nothing to build"
fi
