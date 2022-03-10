# Environment variables
red=`tput setaf 1`
purple=`tput setaf 93`
blue=`tput setaf 21`
green=`tput setaf 2`
yellow=`tput setaf 214`
reset=`tput sgr0`

if [[ ! -d "$JRPC" ]]; then 
    export JRPC="$(pwd)"
    echo 'export JRPC="$(pwd)"' >> ~/.bashrc
fi

MODE_flag=``
DEBUG_flag=``
DOWNLOADDATA_flag=``

latestversion=$(curl --silent "https://api.github.com/repos/iotexproject/iotex-core/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')


# Start of script - getting necessary user input
read -p "Do you want to install Testnet (${red}T${reset}) or Mainnet (${green}M${reset})?: " MODE
MODE_flag=$(case "$MODE" in
  (T|t)    echo "Testnet"  ;;
  (M|m)    echo "Mainnet"  ;;
esac)

read -p "Do you want to set up the node in Debug (${red}D${reset}) or Release (${green}R${reset}) mode?: " DEBUG
DEBUG_flag=$(case "$DEBUG" in
  (D|d)    echo ""    ;;
  (R|r)    echo "-d"  ;;
esac)

read -p "Do you want to Download the latest data? No (${red}N${reset}) or Yes (${green}Y${reset}): " DOWNLOADDATA
DOWNLOADDATA_flag=$(case "$DOWNLOADDATA" in
  (Y|y)    echo "true"    ;;
  (N|n)    echo "false"  ;;
esac)


# make directory for JRPC log files
mkdir -p $JRPC/log/$MODE_flag/JRPC
LOGFILE=$JRPC/log/$MODE_flag/JRPC/message.log


echo "**************" | tee -a "$LOGFILE"
echo "$(date)" | tee -a "$LOGFILE"
echo "Mode: $MODE_flag" | tee -a "$LOGFILE"
echo "Debug: $DEBUG" | tee -a "$LOGFILE"
echo "Download Data: $DOWNLOADDATA_flag" | tee -a "$LOGFILE"
echo -e "*************\n" | tee -a "$LOGFILE"


# Set URL to get testnet or mainnet data, depending on user's choice
URL=https://t.iotex.me/$MODE_flag-data-with-idx-latest


# Confirm if we continue with the installation of the latest version - and inform the user of the download data filesize
case $DOWNLOADDATA_flag in
  true)
    echo "This will download ${blue}$(curl -sIL https://t.iotex.me/$MODE_flag-data-with-idx-latest | grep -i x-goog-stored-content-length | awk '{print $2/1024/1024/1024 " GB"}')${reset} from https://t.iotex.me/$MODE_flag-data-with-idx-latest" ;;
  false)
    echo "This script will attempt to use data located in ${green}$JRPC/data/$MODE_flag/IoTeX${reset}"
    echo "If there is no data in this directory, the blockchain will attempt to synchronize from block height 0. You will need to provide your infura key in the configuration files" ;;
  *)
    echo "${red}Not a valid answer. Terminating${reset}"
    exit 0 ;;
esac


read -p "${green}Do you wish to proceed with the installation?${reset} No (${red}N${reset}) or Yes (${green}Y${reset}): " CONTINUE
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


# Setting up file and folder structure, and extract the downloaded data into it
echo "${green}Creating $JRPC/data/$MODE_flag/IoTeX directory${reset}"
mkdir -p $JRPC/data/$MODE_flag/IoTeX

echo "${green}Creating $JRPC/log/$MODE_flag/IoTeX directory${reset}"
mkdir -p $JRPC/log/$MODE_flag/IoTeX

echo "${green}Creating $JRPC/temp/$MODE_flag/IoTeX directory${reset}"
mkdir -p $JRPC/temp/$MODE_flag/IoTeX


case $DOWNLOADDATA_flag in
  true) 
    echo "${green}Downloading latest data${reset}"
    curl -L -o $JRPC/temp/$MODE_flag/IoTeX/data.tar.gz https://t.iotex.me/$MODE_flag-data-with-idx-latest 

    echo "${green}Downloading db patch${reset}"
    curl https://raw.githubusercontent.com/iotexproject/iotex-bootstrap/$latestversion/trie.db.patch > $JRPC/data/$MODE_flag/IoTeX/trie.db.patch

    echo "${green}Extracting data to temporary directory${reset}"
    tar xvf $JRPC/temp/$MODE_flag/IoTeX/data.tar.gz -C $JRPC/temp/$MODE_flag/IoTeX/

    echo "${green}Moving data files to the destination directory and cleaning up the $JRPC/temp directory${reset}"
    mv $JRPC/temp/$MODE_flag/IoTeX/data/* $JRPC/data/$MODE_flag/IoTeX
    rm -r $JRPC/temp/$MODE_flag/IoTeX/data/ ;;

  false)
    echo "This script will attempt to use data located in ${green}$JRPC/data/$MODE_flag/IoTeX${reset}"
    echo "If there is no data in this directory, the blockchain will attempt to synchronize from block height 0. You will need to provide your infura key in the configuration files" ;;
  *)
    echo "${red}Not a valid answer. Terminating${reset}"
    exit 0 ;;
esac

# Start the build scripts for the iotex-core, babel-api and redis servers 

case $MODE_flag in  
  Testnet) 
    echo "${green}Building the Testnet IoTeX server node${reset}" 
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build${reset}"
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Testnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build ;; 
  
  Mainnet) 
    echo "${purple}Main network selected${reset}" 
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build${reset}"
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/Mainnet/Docker/docker-compose-$MODE_flag-minimal.yaml up $DEBUG_flag --no-deps --build ;; 
  
  *) 
    echo "${red}Not a valid mode. Please enter in M for Mainnet or T for Testnet${reset}" ;; 
esac
