#!bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "$(dirname "$0")"
[ -d "$SCRIPT_DIR/grace" ] && cd $SCRIPT_DIR/grace && git pull && cd ..
[ ! -d "$SCRIPT_DIR/grace" ] && git clone https://github.com/coeusit/grace.git $SCRIPT_DIR/grace
source $SCRIPT_DIR/docker-conf/.env.development
docker-compose -p $COMPOSE_PROJECT_NAME -f "$SCRIPT_DIR/docker-compose.development.yml" up -d
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac
