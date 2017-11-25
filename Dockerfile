# Minecraft PE Server
FROM ubuntu:xenial
MAINTAINER  Nicholas Marus <nmarus@gmail.com>

# Setup APT
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update, Install Prerequisites
RUN DEBIAN_FRONTEND=noninteractive apt-get -y update && \
  apt-get install -y vim sudo wget perl gcc g++ make automake libtool autoconf m4 gcc-multilib && \
  apt-get install -y language-pack-en-base software-properties-common python-software-properties && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Stage Files
COPY installer.sh /
COPY docker-start.sh /

# Setup User
RUN useradd -d /data -s /bin/bash --uid 1000 minecraft

# Setup container
EXPOSE 19132
VOLUME ["/data"]
WORKDIR /data

# When launching, set POCKETMINE_BUILD_NUMBER to the build you want to install and use.
# "452" is the build number from pmmp.io to install, e.g.
# on Nov 25, 2017 the latest version produced was 452:
# https://jenkins.pmmp.io/job/PocketMine-MP/452

# Start Pocketmine
CMD ["/docker-start.sh"]

