#!bin/bash
cd "$(dirname "$0")"
[ -d "./grace" ] && cd grace && git pull && cd ..
[ ! -d "./grace" ] && git clone https://github.com/coeusit/grace.git
docker-compose -p coeus_development -f "./docker-compose.development.yml" up -d
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac