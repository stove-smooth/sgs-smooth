sudo apt update -y
sudo apt upgrade -y
sudo apt-get update && sudo apt-get install --no-install-recommends --yes gnupg

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5AFA7A83
source /etc/lsb-release
sudo tee "/etc/apt/sources.list.d/kurento.list" >/dev/null <<EOF
deb [arch=amd64] http://ubuntu.openvidu.io/6.16.0 $DISTRIB_CODENAME kms6
EOF
sudo apt-get update && sudo apt-get install --no-install-recommends --yes kurento-media-server
sudo apt install coturn -y