#!/bin/bash
BIN_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $BIN_DIR
ruby ../shell/init.rb
