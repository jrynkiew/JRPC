This is JRPC, a webOS based and Linux compatible platform for web and game development. You can build atop the JRPC game platform, to expose your in-game currency into the management of the global JRPC platform. Any rewards gained by your users in-game will be available at a given exchange rate depending on time spent in-game. Any in-game currency can be sent directly to another game in your collection for a specified exchange rate, and or can also be sent directly to the wallets of other users on the gaming platform network via the internet connection (broadband required). 

Each node required to be run by a client to operate said gaming network platform will need to run the executable, which will spawn a swarm of docker containers using a docker compose script - the consensus and gaming platform of IoTeX. Consensus is achieved via central nodes which anyone can publish and expose to host - it would simply be up to the users which platform they choose as their main point of central system. Users sign up to the central node exposing their IP's to the central node, which would then send all other users of your network those credentaials to connect to one another and establish a gaming platform. 

Users active on one platform can redeem the same points on another gaming platform - at the same exchange rate as everyone else. 

install:

1. Install Docker

`sudo apt-get install docker`

2. Install Docker Compose

`sudo apt-get install docker-compose`

3. clone this repo and Add JRPC home directory to your profile (Set it to the current directory)

`git clone https://github.com/jrynkiew/JRPC`

`cd JRPC`

`export JRPC=$PWD`

4. Install latest IoTeX data
5. 
`curl -L https://t.iotex.me/testnet-data-latest > $JRPC/data/Testnet/IoTeX/data.tar.gz`

`tar -xzf $JRPC/data/Testnet/IoTeX/data.tar.gz -C $JRPC/data/Testnet/IoTeX/`

`mv $JRPC/data/Testnet/IoTeX/data/* $JRPC/data/Testnet/IoTeX/`

`rm -r $JRPC/data/Testnet/IoTeX/data`

`curl https://raw.githubusercontent.com/iotexproject/iotex-bootstrap/v1.6.3/trie.db.patch > $JRPC/data/Testnet/IoTeX/trie.db.patch`

5. Run `./start.sh` from JRPC root folder to start Mainnet or Testnet

6. Run `./stop.sh` to stop a given stack (Testnet or Mainnet)


#In testing cmake the GUI application 
cmake-gui . //then set build location to JRPC/build folder configure and generate
cd build
make

#ToDo
deploy docker swarm:
docker-compose up
