FROM ubuntu:trusty

MAINTAINER  Andrej Antas <andrej@antas.cz>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN locale-gen  en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN apt-get update

## Default Packages
RUN apt-get install -y build-essential 
RUN apt-get install -y wget links curl rsync bc git git-core apt-transport-https libxml2 libxml2-dev libcurl4-openssl-dev openssl
RUN apt-get install -y gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN apt-get install -y libpq-dev xvfb qt5-default imagemagick libqt5webkit5-dev libldap2-dev libsasl2-dev wkhtmltopdf pdftk libmysqlclient-dev zip libgmp-dev
RUN apt-get install -y postgresql-client
RUN apt-get install -y openssh-client

## Nodejs engine
RUN apt-get install -y nodejs npm
RUN ln -s  /usr/bin/nodejs  /usr/bin/node

RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

RUN npm install -g phantomjs-prebuilt

RUN apt-get install -y ruby2.3 ruby2.3-dev

RUN apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN gem install bundler

WORKDIR /app
ONBUILD ADD . /app

CMD ["bash"]
