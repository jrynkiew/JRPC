This is JRPC, a webOS based and Linux compatible platform for web and game development. You can build atop the JRPC game platform, to expose your in-game currency into the management of the global JRPC platform. Any rewards gained by your users in-game will be available at a given exchange rate depending on time spent in-game. Any in-game currency can be sent directly to another game in your collection for a specified exchange rate, and or can also be sent directly to the wallets of other users on the gaming platform network via the internet connection (broadband required). 

Each node required to be run by a client to operate said gaming network platform will need to run the executable, which will spawn a swarm of docker containers using a docker compose script - the consensus and gaming platform of IoTeX. Consensus is achieved via central nodes which anyone can publish and expose to host - it would simply be up to the users which platform they choose as their main point of central system. Users sign up to the central node exposing their IP's to the central node, which would then send all other users of your network those credentaials to connect to one another and establish a gaming platform. 

Users active on one platform can redeem the same points on another gaming platform - at the same exchange rate as everyone else. 

install:
cmake-gui . //then set build location to JRPC/build folder configure and generate
cd build
make

deploy docker swarm:
docker-compose up
