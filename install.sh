# Environment variables
red=`tput setaf 1`
purple=`tput setaf 93`
blue=`tput setaf 21`
green=`tput setaf 2`
yellowish=`tput setaf 214`
reset=`tput sgr0`

export JRPC=$(pwd)

MODE_flag=``
DEBUG_flag=``

# Start of script - getting necessary user input
read -p "Do you want to download Testnet (${red}T${reset}) or Mainnet (${green}M${reset}) data?: " MODE
MODE_flag=$(case "$MODE" in
  (T|t)    echo "Testnet"  ;;
  (M|m)    echo "Mainnet"  ;;
esac)

read -p "Do you want to set up the node in Debug (${red}D${reset}) or Release (${green}R${reset}) mode?: " DEBUG
DEBUG_flag=$(case "$DEBUG" in
  (D|d)    echo ""    ;;
  (R|r)    echo "-d"  ;;
esac)

URL=https://t.iotex.me/$MODE_flag-data-with-idx-latest

latestversion=$(curl --silent "https://api.github.com/repos/iotexproject/iotex-bootstrap/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')
echo "The latest version is ${yellowish}$latestversion${reset}"
echo "This will download ${blue}$(curl -sIL https://t.iotex.me/$MODE_flag-data-with-idx-latest | grep -i x-goog-stored-content-length | awk '{print $2/1024/1024/1024 " GB"}')${reset} from https://t.iotex.me/$MODE_flag-data-with-idx-latest"
read -p "Do you wish to proceed with the installation? No (${red}N${reset}) or Yes (${green}Y${reset}): "${reset} CONTINUE

case $CONTINUE in
  y|Y)
    echo "We will now install the $MODE_flag IoTeX server node $latestversion" ;;
  n|N)
    echo "${red}Terminating install${reset}"
    exit 0 ;;
  *)
    echo "${red}Not a valid answer. Terminating${reset}"
    exit 0 ;;
esac

echo "${green}Creating $JRPC/data/$MODE_flag/IoTeX directory${reset}"
mkdir -p $JRPC/data/$MODE_flag/IoTeX

echo "${green}Creating $JRPC/log/$MODE_flag/IoTeX directory${reset}"
mkdir -p $JRPC/log/$MODE_flag/IoTeX

echo "${green}Creating $JRPC/temp/$MODE_flag/IoTeX directory${reset}"
mkdir -p $JRPC/temp/$MODE_flag/IoTeX

echo "${green}Downloading latest data${reset}"
curl -L -o $JRPC/temp/$MODE_flag/IoTeX/data.tar.gz https://t.iotex.me/$MODE_flag-data-with-idx-latest 

echo "${green}Downloading db patch${reset}"
curl https://raw.githubusercontent.com/iotexproject/iotex-bootstrap/$latestversion/trie.db.patch > $JRPC/data/$MODE_flag/IoTeX/trie.db.patch

echo "${green}Extracting data to temporary directory${reset}"
tar xvf $JRPC/temp/$MODE_flag/IoTeX/data.tar.gz -C $JRPC/temp/$MODE_flag/IoTeX/

echo "${green}Moving data files to the destination directory and cleaning up the $JRPC/temp directory${reset}"
mv $JRPC/temp/$MODE_flag/IoTeX/data/* $JRPC/data/$MODE_flag/IoTeX
rm -r $JRPC/temp

case $MODE in  
  t|T) 
    echo "${green}Building the Testnet IoTeX server node${reset}" 
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build${reset}"
    
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build   ;; 
  
  m|M) 
    echo "${purple}Main network selected${reset}" 
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build${reset}"
    
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build    ;; 
  
  *) echo "${red}Not a valid mode. Please enter in M for Mainnet or T for Testnet${reset}" ;; 
esac
