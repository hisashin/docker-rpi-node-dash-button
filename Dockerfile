FROM hypriot/rpi-node:latest

MAINTAINER Shingo Hisakawa shingohisakawa@gmail.com

RUN apt-get update
RUN apt-get install openrc make cmake gcc g++ gfortran python python-dev libpcap-dev
RUN npm install forever -g
RUN npm install node-dash-button

ADD dash.js /
ADD start.sh /

ENTRYPOINT /start.sh
