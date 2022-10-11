[ -d "./grace" ] && cd grace && git pull && cd ..
[ ! -d "./grace" ] && git clone https://github.com/coeusit/grace.git
