#!/bin/sh

projname=mdapi-build
testtime=$(date +%Y%m%d-%H%M%Z)
hostname=$projname-$testtime

echo "STEP 1 >> Making the project configuration root as the current working directory"
cd /home/alcphost/buildcfg/mdapi/

echo "STEP 2 >> Building the container image according to the specifications"
docker build . --tag $projname:$testtime --file /home/alcphost/buildcfg/mdapi/Dockerfile --rm

echo "STEP 3 >> Executing the build and test procedure within the created container"
docker run --hostname $testtime --name $hostname $projname:$testtime

exitcode=$(echo $?)

echo "STEP 4 >> Offloading the process logs on the specified logging directory"
docker logs $hostname >> /home/alcphost/buildcfg/mdapi/buildlog/$testtime-result-$exitcode.sh

if [ $exitcode == 0 ]
then
    echo "STEP 5 >> Removing the container image after successful completion of the procedure"
    docker rmi -f $projname:$testtime
else
    echo "STEP 5 >> Retaining the container image for debugging due to a non-zero exit code"
fi

echo "STEP 6 >> Cleaning up the intermediate images used to save storage space"
docker image prune --filter label=stage=builder --filter label=build=$projname --force
