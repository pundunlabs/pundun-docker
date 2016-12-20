#!/bin/sh
_dockerize(){
    ./pundun-docker build pundun-$1 $2
    ./pundun-docker run pundun-$1 $2
    ./pundun-docker fetch_tar pundun-$1 $2
    ./pundun-docker stop pundun-$1 $2
    ./pundun-docker rm pundun-$1 $2
    mkdir -p ../archive/$2
    mv *.tar.gz ../$2/
    docker push pundunlabs/pundun-$1:$2
}

tag="$(git ls-remote --tags https://github.com/pundunlabs/pundun.git | cut -d "/" -f 3 |grep -v -|grep -v {| sort -n -t. -k1 -k2 -k3 -r | head -n1)"
if [ "$(docker images -q pundunlabs/pundun-$tag:centos-6.7 2> /dev/null)" = "" ]; then
{
    _dockerize $tag centos-6.7
    _dockerize $tag ubuntu-16.04
    docker images -q --filter "dangling=true" | xargs docker rmi
}
else
    echo "image already pulled."
fi
#Cleanup dangling images
