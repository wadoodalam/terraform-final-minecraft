#! /bin/bash


terraform output -raw instance_private_key > private_key.pem
chmod 400 private_key.pem  
echo "########### connecting to server and run commands in sequence ###########"

ssh -i "private_key.pem" ec2-user@$1 << EOF
    sudo rpm --import https://yum.corretto.aws/corretto.key
    sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
    sudo yum install -y java-20-amazon-corretto-devel
    sudo adduser minecraft
    sudo su
    mkdir /opt/minecraft/
    mkdir /opt/minecraft/server/
    cd /opt/minecraft/server
    wget https://launcher.mojang.com/v1/objects/c8f83c5655308435b3dcf03c06d9fe8740a77469/server.jar
    sleep 5
    sudo chown -R minecraft:minecraft /opt/minecraft/
    sed -i 's/eula=false/eula=true/' /opt/minecraft/server/eula.txt
    if pgrep -f server.jar > /dev/null; then
        # Minecraft server process found
        echo "Existing Minecraft server process found. Killing the process..."
        pkill -f server.jar
    else
        echo "No existing Minecraft server process found."
    fi
    java -Xmx1024M -Xms1024M -jar server.jar nogui
EOF

echo "Done!"

