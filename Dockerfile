FROM ubuntu:18.04 as builder
RUN rm /etc/apt/sources.list; \
    echo "deb http://archive.ubuntu.com/ubuntu bionic main universe" >> /etc/apt/sources.list; \
    echo "deb http://archive.ubuntu.com/ubuntu bionic-security main universe" >> /etc/apt/sources.list; \
    echo "deb http://archive.ubuntu.com/ubuntu bionic-updates main universe" >> /etc/apt/sources.list; \ 
    echo; \
    echo; \
    echo "Contents of /etc/apt/sources.list"; \
    cat /etc/apt/sources.list; \
    apt-get update; \
    apt-get -y install build-essential libpqxx-dev libpq-dev postgresql-server-dev-all libbotan1.10-dev gettext libssl-dev autoconf libtool liblog4cplus-dev libboost1.65-all-dev git; \
    git clone 'https://gitlab.isc.org/isc-projects/kea.git' --branch=Kea-1.4.0-P1; \
    cd kea; \
    autoreconf --install --force; \
    ./configure --with-pgsql --enable-static-link  --enable-static --prefix=/usr/local/kea --exec-prefix=/usr/local/kea --disable-shared; \
    make; \
    mkdir /usr/local/kea; \
    make install

FROM ubuntu:18.04
RUN  apt-get update; \ 
     apt-get -y install screen libpq5 liblog4cplus-1.1-9 libbotan-1.10-1 libboost-system1.65.1 iproute2 vim
COPY --from=builder "/usr/local/kea" "/usr/local/kea"
COPY "./kea-dhcp4.conf" "/usr/local/kea/etc"
WORKDIR "/usr/local/kea"
CMD ["/usr/local/kea/sbin/kea-dhcp4", "-c", "/usr/local/kea/etc/kea-dhcp4.conf"]
 
