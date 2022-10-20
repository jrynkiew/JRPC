read -p "Please confirm that the iotex server process has been stopped [yes/no] (Default: no)" check

if [ "${check}"X != "yes"X ];then
    echo "the iotex server process is not stopped. Please stop the process first"
    exit 1
fi

#check JRPC variable & statedb path
if [ ! $JRPC ] || [ ! -f ${JRPC}/data/Mainnet/IoTeX/trie.db ];then
    read -p "Input your \$JRPC : " inputdir
    JRPC=${inputdir}
fi

echo "JRPC : $JRPC"


cd $JRPC

#download readtip file
curl https://storage.googleapis.com/blockchain-archive/readtip > $JRPC/tools/readtip

if [ ! -f $JRPC/tools/readtip ];then
    echo "$JRPC/tools/readtip does not exist"
    exit 1
fi

chmod a+x $JRPC/tools/readtip

tipHeight=`$JRPC/tools/readtip -state-db-path=$JRPC/data/Mainnet/IoTeX/trie.db`

if [ ! $tipHeight ];then
    echo "can't get $tipHeight"
    exit 1
fi

echo "tip height : $tipHeight"

#download the patch file
if [ $tipHeight -gt 19778036 ];then
    ServerIP='patch.iotex.io'
    patchUrl=`curl https://$ServerIP/$tipHeight`
    echo "the patch url: $patchUrl"

    patchFile=$JRPC/data/Mainnet/IoTeX/$tipHeight.patch
    curl $patchUrl > $patchFile

    if [ ! -f $patchFile ];then
        echo "$patchFile does not exist"
        exit 1
    fi
fi

echo "download $patchFile success, please upgrade to v1.8.4 and restart iotex-server"
