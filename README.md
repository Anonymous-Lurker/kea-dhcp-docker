# kea-dhcp-docker
Based on kea 1.4 [https://gitlab.isc.org/isc-projects/kea/wikis/home]

Multi stage build that compiles kea-dhcp with the optional postgres backend driver enabled.  The config works but
would probably need to be modified for various specific subnets.  The current config file kea-dhcp4.conf does not include the bits needed
to use the postgres backend, the on disk CSV backend is enabled.  It's easier to get a quick proof of concept going with the on disk storage
configuration.

This current iteration of the container does not specify exposed ports because I am using MacVlan.

My docker network config command:

`docker network create -d macvlan --subnet=192.168.88.0/24 --gateway=192.168.88.1 -o parent=eno1 dot_88_net`


A simple command to run the container:

`docker run --net=dot_88_net --ip=192.168.88.251 -d kea-dhcp:1.4`
