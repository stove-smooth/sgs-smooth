# Kurento Media Server

## KMS 설치
```
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
```

```
sudo turnadmin -a -u <이름> -p <패스워드 -r <realm>
```
- turn 서버 설정 참고
    - https://scshim.tistory.com/6
    - http://john-home.iptime.org:8085/xe/index.php?mid=board_sKSz42&document_srl=1546

- coturn 설정 : settings/turnserver.conf
- kurento 설정 : settings/kurento

## 인증서
```
sudo apt install nginx -y
sudo apt install letsencrypt -y
```
- nginx 설정 : settings/default