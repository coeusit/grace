SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
[ -d "$SCRIPT_DIR/grace" ] && cd $SCRIPT_DIR/grace && git pull
[ ! -d "$SCRIPT_DIR/grace" ] && git clone https://github.com/coeusit/grace.git $SCRIPT_DIR/grace
