#!/bin/sh
_dockerize(){
    ./pundun-docker build pundun-$1 $2
    ./pundun-docker fetch_package pundun-$1 $2
    mkdir -p ../archive/$2
    mv packages/* ../archive/$2/
    ./pundun-docker install pundun-$1 $2
    #docker push pundunlabs/pundun-$1:$2
}

dcleanup(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

tag="$(git ls-remote --tags https://github.com/pundunlabs/pundun.git | cut -d "/" -f 3 |grep -v -|grep -v {| sort -n -t. -k1 -k2 -k3 -r | head -n1)"
if [ "$(docker images -q pundunlabs/pundun-$tag:centos-7 2> /dev/null)" = "" ]; then
{
    _dockerize $tag centos-6.7
    _dockerize $tag centos-7
    _dockerize $tag ubuntu-14.04
    _dockerize $tag ubuntu-16.04
}
else
    echo "image already pulled."
fi
#Cleanup dangling images
dcleanup
