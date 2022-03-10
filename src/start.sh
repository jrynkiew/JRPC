red=`tput setaf 1`
purple=`tput setaf 93`
green=`tput setaf 2`
reset=`tput sgr0`
DEBUG_flag=``
MODE_flag=``

read -p 'Testnet (T) or Mainnet (M): ' MODE
read -p 'Debug (D) or Release (R): ' DEBUG

DEBUG_flag=$(case "$DEBUG" in
  (D|d)    echo ""    ;;
  (R|r)    echo "-d"  ;;
esac)

MODE_flag=$(case "$MODE" in
  (T|t)    echo "Testnet"  ;;
  (M|m)    echo "Mainnet"  ;;
esac)

case $MODE in  
  t|T) 
    echo "${purple}Test network selected${reset}" 
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/JRPC_Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build${reset}"
    
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build   ;; 
  
  m|M) 
    echo "${purple}Main network selected${reset}" 
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build${reset}"
    
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build    ;; 
  
  *) echo "${red}Not a valid mode. Please enter in M for Mainnet or T for Testnet${reset}" ;; 
esac
