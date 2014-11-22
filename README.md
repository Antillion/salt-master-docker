# Docker Salt-Master

A Docker image which allows you to run a containerised Salt-Master server. Based on of
[thisissoon/Docker-Salt-Master](https://github.com/thisissoon/Docker-Salt-Master)

## Running the Container

For a test you can easily run the container like so:
```
docker run --rm -it asmaps/salt-master
```

A more advanced configuration that mounts the volumes to a local directory and exposes the ports to the world is this:
```
docker run -d -p 4505:4505 -p 4506:4506 --restart=always -v /opt/salt/pki:/etc/salt/pki -v /opt/salt/cache:/var/salt/cache
-v /opt/salt/logs:/var/logs/salt -v /srv/salt:/srv/salt -v /srv/salt/master.d:/etc/salt/master.d --name salt-master
asmaps/salt-master
```

## Environment Variables

The following environment variables can be set:

* `LOG_LEVEL`: The level to log at, defaults to `error`

## Volumes

There are several volumes which can be mounted to Docker data container as
described here: https://docs.docker.com/userguide/dockervolumes/. The following
volumes can be mounted:

 * `/etc/salt/pki` - This holds the Salt Minion authentication keys
 * `/var/cache/salt` - Job and Minion data cache
 * `/var/logs/salt` - Salts log directory
 * `/etc/salt/master.d` - Master configuration include directory
 * `/srv/salt` - Holds your states, pillars etc

### Data Container

To create a data container you are going to want the thinnest possible docker
image, simply run this docker command, which will download the simplest possible
docker image:

    docker run -v /etc/salt/pki -v /var/salt/cache -v /var/logs/salt -v /etc/salt/master.d -v /srv/salt --name salt-master-data busybox true

This will create a stopped container with the name of `salt-master-data` and
will hold our persistant salt master data. Now we just need to run our master
container with the `--volumes-from` command:

    docker run --rm -it --name salt-master --volume-from salt-master-data asmaps/salt-master

### Sharing Local Folders

To share folders on your local system so you can have your own master
configuration, states, pillars etc just alter the `salt-master-data`
command:

    docker run -v /etc/salt/pki -v /var/salt/cache -v /var/logs/salt -v /path/to/local:/etc/salt/master.d -v /path/to/local:/srv/salt --name salt-master-data busybox true

Now `/path/to/local` can hold your states and master configuration.

## Ports

The following ports are exposed:

 * `4505`
 * `4506`

These ports allow minions to communicate with the Salt Master.

## Running Salt Commands

To run commands in your master container use the `docker exec` command. (This needs at least docker 1.3)

For example:
```
docker exec -t salt-master "salt '*' test.ping"
```

### Accepting new minions

To accept a new minion run the following command (replace `<minion_id>` with the actual id):
```
docker exec -t salt-master salt-key -a <minion_id>
```
