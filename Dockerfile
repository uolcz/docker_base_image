FROM ubuntu:xenial

MAINTAINER  Andrej Antas <andrej@antas.cz>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

ENV TZ=Europe/Prague
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## Default Packages
RUN apt-get update
RUN apt-get install -y build-essential software-properties-common
RUN apt-get install -y wget links curl rsync bc git git-core apt-transport-https libxml2 libxml2-dev libcurl4-openssl-dev openssl
RUN apt-get install -y gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN apt-get install -y libpq-dev xvfb imagemagick libldap2-dev libsasl2-dev wkhtmltopdf pdftk libmysqlclient-dev zip libgmp-dev
RUN apt-get install -y openssh-client

RUN apt-get install -y chromium-chromedriver

## Latest version of Postgres from their repos
RUN add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main"
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y install postgresql-client

## Nodejs engine
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs

## YARN
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

RUN apt-get install -y ruby2.3 ruby2.3-dev

RUN apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

# Chromedriver whole setup (TODO: get CHROME_DRIVER_VERSION from chromedriver.storage.googleapis.com/LATEST_RELEASE)
ENV CHROME_DRIVER_VERSION=2.46
ENV SELENIUM_STANDALONE_VERSION=3.9.1
# TODO: get SELENIUM_STANDALONE_VERSION like so: $(echo "$SELENIUM_STANDALONE_VERSION" | cut -d"." -f-2)
ENV SELENIUM_SUBDIR=3.9

RUN wget -N https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -P ~/
RUN dpkg -i --force-depends ~/google-chrome-stable_current_amd64.deb
RUN apt-get -f install -y
RUN dpkg -i --force-depends ~/google-chrome-stable_current_amd64.deb

RUN wget -N http://chromedriver.storage.googleapis.com/$CHROME_DRIVER_VERSION/chromedriver_linux64.zip -P ~/
RUN unzip ~/chromedriver_linux64.zip -d ~/
RUN rm ~/chromedriver_linux64.zip
RUN mv -f ~/chromedriver /usr/local/bin/chromedriver
RUN chmod 0755 /usr/local/bin/chromedriver

RUN wget -N http://selenium-release.storage.googleapis.com/$SELENIUM_SUBDIR/selenium-server-standalone-$SELENIUM_STANDALONE_VERSION.jar -P ~/
RUN mv -f ~/selenium-server-standalone-$SELENIUM_STANDALONE_VERSION.jar /usr/local/bin/selenium-server-standalone.jar
RUN chown root:root /usr/local/bin/selenium-server-standalone.jar
RUN chmod 0755 /usr/local/bin/selenium-server-standalone.jar

RUN apt-get autoremove -y

RUN gem install bundler

CMD ["bash"]
