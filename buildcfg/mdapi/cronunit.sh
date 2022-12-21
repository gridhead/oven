#!/bin/sh

projname=mdapi-build
testtime=$(date +%Y%m%d-%H%M%Z)
hostname=$projname-$testtime

echo "STEP 1 >> Building the container image according to the specifications"
docker build . --tag $projname:$testtime --file /home/alcphost/buildcfg/mdapi/Dockerfile --rm

echo "STEP 2 >> Executing the build and test procedure within the created container"
docker run --hostname $testtime --name $hostname --tty --interactive $projname:$testtime

exitcode=$(echo $?)

echo "STEP 3 >> Offloading the process logs on the specified logging directory"
docker logs $hostname >> /home/alcphost/buildcfg/mdapi/buildlog/$testtime-result-$exitcode.sh

if [ $exitcode == 0 ]
then
    echo "STEP 4 >> Removing the container image successful completion of the procedure"
    docker rmi -f $projname:$testtime
else
    echo "STEP 4 >> Container image retained due to a non-zero exit code"
fi

echo "STEP 5 >> Cleaning up the intermediate images used to save storage space"
docker image prune --filter label=stage=builder --filter label=build=$projname --force
