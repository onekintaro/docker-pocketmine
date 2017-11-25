This fork of https://github.com/nmarus/docker-pocketmine provides a working Minecraft Pocket Edition docker container, tested on Nov 25, 2017 against the latest build of Minecraft PE, Jenkins build 452, available at https://jenkins.pmmp.io/job/PocketMine-MP/452


This fork installs PHP 7.2 and explicitly installs build 452 of Pocket Minecraft. You can change the build number by running docker with `-e POCKETMINE_BUILD_NUMBER=452` (or some other build number).  Browse build numbers at https://jenkins.pmmp.io/job/PocketMine-MP


It uses the installer.sh script available at https://raw.githubusercontent.com/pmmp/php-build-scripts/master/installer.sh

To build it:
```
docker build -t rkuzsma/docker-pocketmine .
```

To run it:
```
docker run --rm -it -p 19132:19132/tcp -p 19132:19132/udp  -v /SOME_LOCAL_DIRECTORY:/data --name pocketmine rkuzsma/docker-pocketmine
```

After running the container the first time, `/SOME_LOCAL_DIRECTORY` will be initialized with a `settings.properties` file and other server settings files. Edit the files in `/SOME_LOCAL_DIRECTORY` and re-run the container for the changes totake effect.


Original README.md starts below

# Pocketmine for Docker

This is an implementation of the [Pocketmine] (https://www.pocketmine.net) LAN server for allowing [Minecraft-PE IOS clients] (https://itunes.apple.com/us/app/minecraft-pocket-edition/id479516143?mt=8) to play. This is running the development version of pocketmine to support the [recent updates] (http://gaming.stackexchange.com/questions/222592/pocketmine-mp-installation-not-completing-connections) to the client protocol that Minecraft-PE uses. 

### To run pocketmine as a docker container:

    docker run -d -it -p 19132:19132/tcp -p 19132:19132/udp --name pocketmine nmarus/docker-pocketmine:latest
    
This creates a new container from the repository, names the container "mcpe", downloads the latest development build of pocketmine, and maps the ports for client access to the local host. This is not recommend as you will lose your configuration file when th container stops and starts. 
    
The *recommended* way is to utilize a local directory that is external to the container for your configuration files. This will allow persistent configuration if you remove the container, or if you wish to edit the configuration files manually and restart pocketmine. To do this, first create a foler on the host where you wish to store these:

    mkdir /srv/pocketmine
    
Then run the container with these added option:

    docker run -d -it -p 19132:19132/tcp -p 19132:19132/udp  -v /srv/pocketmine:/data --name pocketmine nmarus/docker-pocketmine:latest

### To start the container:
If the container is stoped (run "docker ps -a" to verify), and you wish to start it, run: 

    docker start pocketmine

### To stop the container:
If you wish to stop the container in order to rebvoot the host os or updaet configuration files, run:

    docker stop pocketmine

### To interact with pocketmine administration:

    docker attach pocketmine
    
This allows you to jump into the pocketmine administration session. Type "help" for options. If you enter the command "stop", this will end pocket mine and stop the container. To restart pocketmine with our stopping the container, enter "restart" in the pocket mine admin session.
    
*To exit the admistration interface, press control-p, control-q. This is in order to maintain the container in service.*

### To view the logs in realtime run:

    docker logs -l pocketmine
    
This allows you to view the logs generated from the pocketmine server in a "tail -f" type format. 
    
*Press control-c to exit*

###To update minecraft pe to latest version:
Simply stop the pocketmine container and then start it. the latest version of pocketmine will be downloaded. 

*This assumes you are mapping your configuration to a directory external to the container. If not, you will lose your world...*

    docker stop pocketmine
    docker start pocketmine
    
### News:

*Change log 2015-7-11*

* Added updates for mapping local data directory for pocketmine configuration files.
* Removed memory options from server.properties file as it is now defined in the yaml file. 

*Open Items:*

* Build logic to perform upgrade of server code without needing to rebuild the container. 
* Test RCON functionality.
* Implement variable in Dockerfile to specify initial configuration option in server.properties file. 
* Generate random RCON password when server.properties file does not exist.
