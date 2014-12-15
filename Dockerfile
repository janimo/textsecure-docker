# Open Whisper Systems TextSecure Server

# Build the image with
# docker build --rm -t whisper .

# Run the container in a directory containing the jar/ and config/ dirs
# and the scripts referenced here
#
# docker run -p 8080:8080 -p 8081:8081 -P -v $(pwd):/home/whisper -it whisper

FROM ubuntu:14.10

MAINTAINER Jani Monoses <jani@ubuntu.com>

#Uncomment this if you want to use squid-deb-proxy from the host
#RUN /sbin/ip route | awk '/default/ { print "Acquire::http::Proxy \"http://"$3":8000\";" }' > /etc/apt/apt.conf.d/30proxy

RUN DEBIAN_FRONTEND='noninteractive' apt-get update && apt-get install -y redis-server memcached postgresql openjdk-7-jre-headless supervisor

RUN adduser --disabled-password --quiet --gecos Whisper whisper
ENV HOME /home/whisper
WORKDIR /home/whisper

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN /etc/init.d/postgresql start && \
 sudo -u postgres psql --command "CREATE USER whisper WITH SUPERUSER PASSWORD 'whisper';" && \
 sudo -u postgres createdb -O whisper whisper

EXPOSE 8080 8081

CMD ./run-server
