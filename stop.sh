red=`tput setaf 1`
purple=`tput setaf 93`
green=`tput setaf 2`
reset=`tput sgr0`
MODE_flag=``

read -p 'Testnet (T) or Mainnet (M): ' MODE

MODE_flag=$(case "$MODE" in
  (T|t)    echo "testnet"  ;;
  (M|m)    echo "mainnet"  ;;
esac)

case $MODE in  
  t|T) 
    echo "${purple}Test network selected${reset}" 
    echo "${red}Stopping and removing containers ${reset}"
    echo "running command ${purple}docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml down ${reset}"
    
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml down ;;

  m|M)
    echo "${purple}Main network selected${reset}" 
    echo "${red}Stopping and removing containers ${reset}"
    echo "running command ${purple}docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml down ${reset}"
    
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml down ;;
esac

echo "${red}All containers have been stopped and removed ${reset}"