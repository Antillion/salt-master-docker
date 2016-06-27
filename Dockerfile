#
# Salt Stack Salt Master Container
#
FROM debian:jessie
MAINTAINER Aexea Carpentry

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
	curl \
	libffi-dev \
	libgit2-dev \
	python-dateutil \
	python-git \
	python-pip \
	sudo \
	--no-install-recommends

ENV SALT_VERSION=2016.3.1
# Add salt stack repository
RUN curl -sSL "https://repo.saltstack.com/apt/debian/8/amd64/archive/$SALT_VERSION/SALTSTACK-GPG-KEY.pub" | sudo apt-key add -
RUN sudo echo "deb http://repo.saltstack.com/apt/debian/8/amd64/archive/$SALT_VERSION jessie main" >> /etc/apt/sources.list.d/saltstack.list

# Install Salt
RUN apt-get update && apt-get install -y \
	salt-master \
	salt-cloud \
	--no-install-recommends

# Install further dependencies
RUN pip install apache-libcloud python-simple-hipchat boto dnspython cli53

# Volumes
VOLUME ["/etc/salt/pki", "/var/cache/salt", "/var/log/salt", "/etc/salt/master.d", "/srv/salt"]

# Add Run File
ADD run.sh /usr/local/bin/run.sh
RUN chmod +x /usr/local/bin/run.sh

# Ports
EXPOSE 4505 4506

# Run Command
CMD "/usr/local/bin/run.sh"
