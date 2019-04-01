#!/usr/bin/env sh

ALREADY_INSTALLED=0
CONFIG_FILE='.nwrc'

if [ -f $CONFIG_FILE ]; then
    NODE_VERSION=`cat $CONFIG_FILE`
fi

if [ -z $NODE_VERSION ]; then
    echo "Node version not specfied. Exiting."
    exit 1
fi

if [ -d node ]; then 
    if [ ! -x node/bin/node ]; then
        echo "Install directory 'node' already exists, but doesn't contain node executable. Remove or rename 'node' directory. Exiting."
        exit 2
    fi

    INSTALLED_NODE_VERSION=`node/bin/node -v`
    if [ $NODE_VERSION = $INSTALLED_NODE_VERSION ]; then
        echo "Correct node version already installed."
        ALREADY_INSTALLED=1
    else
        echo "Detected another version of node $INSTALLED_NODE_VERSION in 'node' directory. Remove or rename 'node' directory. Exiting."
        exit 2
    fi
fi

if [ 0 -eq $ALREADY_INSTALLED ]; then
    NODE_URL=https://nodejs.org/dist/$NODE_VERSION/node-$NODE_VERSION-linux-x64.tar.xz
    DOWNLOAD_AS=node-$NODE_VERSION.tar.xz

    if ! [[ -f $DOWNLOAD_AS ]]; then
        echo "Downloading $NODE_VERSION from $NODE_URL to $DOWNLOAD_AS."
        curl -o $DOWNLOAD_AS $NODE_URL
    else
        echo "Found node distribution package $DOWNLOAD_AS."
    fi

    echo "Unpacking $DOWNLOAD_AS."
    mkdir node
    tar --strip-components=1 -xf $DOWNLOAD_AS -C node

    echo "Removing node distribution package $DOWNLOAD_AS."
    rm $DOWNLOAD_AS
fi

echo "Creating local npm access script."
cat <<EOT > npm
#!/usr/bin/env sh
node/bin/node node/bin/npm "\$@"
EOT
chmod +x npm
