# Install dependencies
#sudo apt-get install docker
#sudo apt-get install docker-compose
#sudo groupadd docker
#sudo usermod -aG docker $USER
#newgrp docker 
#sudo systemctl restart docker
#git submodule update --init --recursive

# Environment variables
red=`tput setaf 1`
purple=`tput setaf 93`
blue=`tput setaf 21`
green=`tput setaf 2`
yellow=`tput setaf 214`
reset=`tput sgr0`

MODE_flag=``
BABEL_API_flag=``
DEBUG_flag=``
DOWNLOADDATA_flag=``

latestversion=$(curl --silent "https://api.github.com/repos/iotexproject/iotex-core/releases/latest" | grep -Po '"tag_name": "\K.*?(?=")')

echo "JRPC IoTeX Full Node Build System
"
. ./tools/setenv.sh $latestversion

# Start of script - getting necessary user input
read -p "Do you want to install Testnet (${red}T${reset}) or Mainnet (${green}M${reset})?: " MODE
MODE_flag=$(case "$MODE" in
  (T|t)    echo "Testnet"  ;;
  (M|m)    echo "Mainnet"  ;;
  ( * )    echo "Error. Wrong Selection"  ;;
esac)

# Start of script - getting necessary user input
read -p "Do you want to install the extra babel-api add-on (additional costs may be incurred)? No (${red}N${reset}) or Yes (${green}Y${reset})?: " BABEL_API
BABEL_API_flag=$(case "$BABEL_API" in
  (Y|y)    echo "babel-api"  ;;
  (N|n)    echo "minimal"    ;;
  ( * )    echo "Error. Wrong Selection"  ;;
esac)

read -p "Do you want to set up the node in Debug (${red}D${reset}) or Release (${green}R${reset}) mode?: " DEBUG
DEBUG_flag=$(case "$DEBUG" in
  (D|d)    echo ""    ;;
  (R|r)    echo "-d"  ;;
  ( * )    echo "Error. Wrong Selection"  ;;
esac)

read -p "Do you want to Download the latest data? No (${red}N${reset}) or Yes (${green}Y${reset}): " DOWNLOADDATA
DOWNLOADDATA_flag=$(case "$DOWNLOADDATA" in
  (Y|y)    echo "true"    ;;
  (N|n)    echo "false"   ;;
  ( * )    echo "Error. Wrong Selection"  ;;
esac)

case $MODE_flag in  
  Mainnet|Testnet)
    # make directory for JRPC log files
    mkdir -p $JRPC/log/$MODE_flag/JRPC
    LOGFILE=$JRPC/log/$MODE_flag/JRPC/message.log
    echo -e "\n**************" | tee -a "$LOGFILE"
    echo "$(date)" | tee -a "$LOGFILE"
    echo "Mode: $MODE_flag" | tee -a "$LOGFILE"
    case "$DEBUG" in
      D|d)    echo "Debug: Debug" | tee -a "$LOGFILE" ;;
      R|r)    echo "Debug: Release" | tee -a "$LOGFILE" ;;
      *)      echo "Debug: $DEBUG_flag" ;;
    esac
    echo "Additional Costs (trial period free): $BABEL_API_flag" | tee -a "$LOGFILE"
    echo "Download Data: $DOWNLOADDATA_flag" | tee -a "$LOGFILE"
    echo -e "*************\n" | tee -a "$LOGFILE" ;;
  *)
    echo -e "\n**************"
    echo "$(date)"
    echo "Mode: $MODE_flag"
    case "$DEBUG" in
      D|d)    echo "Debug: Debug" ;;
      R|r)    echo "Debug: Release" ;;
      *)      echo "Debug: $DEBUG_flag" ;;
    esac
    echo "Additional Costs (trial period free): $BABEL_API_flag"
    echo "Download Data: $DOWNLOADDATA_flag"
    echo -e "*************\n"
    echo "${red}Please review your choices and make sure you make a valid selection. Terminating${reset}"
    exit 0 ;;
esac

# Set URL to get testnet or mainnet data, depending on user's choice
URL=https://t.iotex.me/$MODE_flag-data-with-idx-latest

# Confirm if we continue with the installation of the latest version - and inform the user of the download data filesize
case $DOWNLOADDATA_flag in
  true)
    echo "This will download ${blue}$(curl -sIL https://t.iotex.me/$MODE_flag-data-with-idx-latest | grep -i x-goog-stored-content-length | awk '{print $2/1024/1024/1024 " GB"}')${reset} from https://t.iotex.me/$MODE_flag-data-with-idx-latest" ;;
  false)
    echo "This script will attempt to use data located in ${green}$JRPC/data/$MODE_flag/IoTeX${reset}"
    echo "If there is no data in this directory, the blockchain will attempt to synchronize from block height 0. You will need to provide your Infura, Pocket or ANKR endpoint in the configuration files" ;;
  *)
    echo "${red}Not a valid Data Download answer. Terminating${reset}"
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

case $BABEL_API_flag in
  minimal)
    echo "${green}Building IoTeX node in minimal cost mode${reset}" ;;
  babel-api)
    echo "${green}Building IoTeX node with additional $BABEL_API_flag. Additiona charges may apply. This feature is still in testing phase, and is therefore free.${reset}" ;;
  *)
    echo "${red}Not a valid Additional Costs mode. Please make a valid selection and try again. Terminating${reset}" 
    exit 0 ;;
esac

case $MODE_flag in  
  Mainnet)
    # If in future releases IoTeX requires a data patch, uncomment this script to attempt to download the latest patch and install it.
    echo "${green}Downloading latest patch${reset}"
    curl https://raw.githubusercontent.com/iotexproject/iotex-bootstrap/v1.7.1/trie.db.patch > $JRPC/data/$MODE_flag/IoTeX/trie.db.patch ;;
esac

case $DOWNLOADDATA_flag in
  true)
    echo "${green}Downloading latest data${reset}"
    curl -L -o $JRPC/temp/$MODE_flag/IoTeX/data.tar.gz https://t.iotex.me/$MODE_flag-data-with-idx-latest 

    echo "${green}Extracting data to temporary directory${reset}"
    tar xvf $JRPC/temp/$MODE_flag/IoTeX/data.tar.gz -C $JRPC/temp/$MODE_flag/IoTeX/

    echo "${green}Moving data files to the destination directory and cleaning up the $JRPC/temp directory${reset}"
    mv $JRPC/temp/$MODE_flag/IoTeX/data/* $JRPC/data/$MODE_flag/IoTeX
    rm -r $JRPC/temp/$MODE_flag/IoTeX/data/ ;;

  false)
    echo "This script will attempt to use data located in ${green}$JRPC/data/$MODE_flag/IoTeX${reset}"
    echo "If there is no data in this directory, the blockchain will attempt to synchronize from block height 0. You will need to provide your Infura, Pocket or ANKR endpoint in the configuration files"
    
    # If the node does not start synching from block height 0, it might be due to incorrect Pocket Ethereum Mainnet Tracing endpoint."
    # If you do not have any endpoints to use, you can uncomment the below line to download the static poll.db data files, which will overcome the need to connect to Mainnet Ethereum Tracing nodes.
    echo "${green}Downloading latest poll.db file${reset}"
    curl -L https://storage.googleapis.com/blockchain-golden/poll."${MODE_flag,}".tar.gz > $JRPC/temp/$MODE_flag/IoTeX/poll.tar.gz; tar -xzf $JRPC/temp/$MODE_flag/IoTeX/poll.tar.gz -C $JRPC/data/$MODE_flag/IoTeX/ ;;

  *)
    echo "${red}Not a valid answer. Terminating${reset}"
    exit 0 ;;
esac

# Start the build scripts for the iotex-core, babel-api and redis servers 

case $MODE_flag in
  Testnet|Mainnet)
    echo "${green}Building the $MODE_flag IoTeX server node${reset}"
    echo "${green}Starting docker-compose scripts${reset}"
    echo "running command ${purple} docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/$MODE_flag/Docker/docker-compose-$MODE_flag-$BABEL_API_flag.yaml up $DEBUG_flag --no-deps --build${reset}"
    docker-compose -p JRPC-$MODE_flag -f $JRPC/etc/$MODE_flag/Docker/docker-compose-$MODE_flag-$BABEL_API_flag.yaml up $DEBUG_flag --no-deps --build ;; 
  *)
    echo "${red}Not a valid mode. Please enter in M for Mainnet or T for Testnet${reset}" ;; 
esac
