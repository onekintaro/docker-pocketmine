# How to Run Multiplayer Minecraft on Your Own Minecraft Server using Docker and AWS

Here's how to let 2 or more people play Minecraft together in the same world, including Creative and Survival mode.

The basics:
* You *must* connect to a Minecraft Server to play multiplayer.
* If you don't want to run a Minecraft Server yourself, you can [buy a subscription to Minecraft Realms](https://minecraft.net/en-us/realms/faq/) for $3.99 or $7.99 *per month*, depending on the edition and number of simultaneous users.
* Desktop/Laptop players *cannot* play against Pocket/Mobile/Kindle/Console players. They run on completely different and incompatible Minecraft software underneath.
* See also the [Minecraft FAQ Page for Parents](http://minemum.com/FAQ)

This article assumes you do not want to buy a Minecraft Realms subscription and want to run your own Minecraft server yourself.


## For Desktop/Laptop ("Java Edition") Players

[Create a Mojang account](https://minecraft.net/en-us/store/minecraft/#register) for *each* player, if you don't already have one. Yes, you have to buy the software for *each* player.

[Download and install the Minecraft client](https://minecraft.net/en-us/) on each Desktop/Laptop that needs it.

Next, run the Minecraft Server software. Perform these steps on a laptop or desktop, or on a server hosted externally like on Amazon AWS, DigitalOcean, etc.:

1. Install [Docker Community Edition](https://www.docker.com/community-edition) for Mac, Windows, or Linux. It's free! Docker greatly simplifies the Server installation steps.

2. Run this command from a terminal or console window:
```
docker run -d -it -v /PATH_TO_A_STORAGE_FOLDER:/data -e EULA=TRUE -e MODE=creative -e OPS=user1,user2 -e DIFFICULTY=peaceful -p 25565:25565 --name mc itzg/minecraft-server
```

`PATH_TO_A_STORAGE_FOLDER` is the full path to a folder to store the Minecraft server settings and game data.

`user1,user2` are the Mojang account names of the players you want to act as operators in the game. Operators can run [commands](https://minecraft.gamepedia.com/Commands) in the game to do things like change the weather and make it daytime.

Set the `MODE` to `creative` or `survival`

Full documentation is available at [https://github.com/itzg/dockerfiles/tree/master/minecraft-server](https://github.com/itzg/dockerfiles/tree/master/minecraft-server)

3. Find the IP address of your server (e.g. `192.168.1.something`). If you are on a WiFi home network, you can usually find this under your WiFi network settings. If you are on Amazon AWS, the public IP address is listed on the EC2 Instances details.

Finally, have each player choose the "Multiplayer" option in Minecraft, and connect to your server on the IP address on port `25565`.


## For Mobile/Console ("Pocket Edition") App Players

[Create a free XBox Live account](https://www.xbox.com/en-US/live/minecraft/sign-up) for *each* player, if you don't already have one. The same XBox Live Account is used for all the mobile apps.

Purchase and install the Minecraft app for each player's platform of choice. For most platforms (e.g. Android, Kindle), you only have to buy the app once.

Next, run the Minecraft **Pocket Edition** Server software. Perform these steps on a laptop or desktop, or on a server hosted externally like on Amazon AWS, DigitalOcean, etc.:

1. Install [Docker Community Edition](https://www.docker.com/community-edition) for Mac, Windows, or Linux. It's free! Docker greatly simplifies the Server installation steps.

2. Run this command from a terminal or console window:
```
docker run --rm -it -p 19132:19132/tcp -p 19132:19132/udp -v /PATH_TO_A_STORAGE_FOLDER:/data  --name pocketmine rkuzsma/docker-pocketmine:latest
```

`PATH_TO_A_STORAGE_FOLDER` is the full path to a folder to store the Minecraft server settings and game data.

After running the container the first time, `PATH_TO_A_STORAGE_FOLDER` will be initialized with a `settings.properties` file and other server settings files. Edit the files in `PATH_TO_A_STORAGE_FOLDER` and re-run the container for the changes to take effect.

Documentation for the `settings.properties` and other configuration files, including how to change the game mode, add users as operators, etc., is available at [http://pocketmine-mp.readthedocs.io/en/latest/configuration.html](http://pocketmine-mp.readthedocs.io/en/latest/configuration.html)

3. Find the IP address of your server (e.g. `192.168.1.something`). If you are on a WiFi home network, you can usually find this under your WiFi network settings. If you are on Amazon AWS, the public IP address is listed on the EC2 Instances details.

Finally, have each player choose the "Multiplayer" option in Minecraft, and connect to your server on the IP address on port `19132`.

Side note: Minecraft Pocket Edition Server is not official Minecraft software. It is developed and supported by a community of passionate volunteer engineers. When Minecraft releases new app versions, the server may trail behind a little bit in its support. Not all features may work as well as they do in the official Minecraft Realms.


# General Step-by-Step to Host a Minecraft Server on Amazon AWS

1. Create a standard Amazon Linux AMI on EC2. Make sure you have at least 2GB memory provisioned for the instance.

2. When prompted, download the PEM key to your local computer so you can SSH into it. On Mac OSX, for example, save it to: `~/.ssh/minecraft.pem`
Then run: `chmod 600 ~/.ssh/minecraft.pem`

3. SSH into the EC2 instance, e.g.:
```
ssh -i ~/.ssh/minecraft.pem ec2-user@DNS_NAME_OF_MACHINE_INSTANCE
```

4. Install Docker. These steps work on AWS:
```
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
exit
```
Re-SSH back in to the instance and then confirm Docker is working:
```
docker info
```
Then follow the earlier instructions above as if this server were your own Desktop or Laptop.

**You get charged for the EC2 instance!** So you may want to Stop the instance when not using it to save money.
