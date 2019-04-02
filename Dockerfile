FROM ubuntu:bionic

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
RUN apt update && apt install -y build-essential software-properties-common wget links curl rsync bc git \ 
    git-core apt-transport-https libxml2 libxml2-dev libcurl4-gnutls-dev \
    openssl gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev \
    automake libtool bison libffi-dev libpq-dev xvfb imagemagick libldap2-dev \
    libsasl2-dev zip libgmp-dev postgresql-client \
    openssh-client \
    chromium-chromedriver

RUN wget -q https://downloads.wkhtmltopdf.org/0.12/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
RUN apt install -y ./wkhtmltox_0.12.5-1.bionic_amd64.deb && rm wkhtmltox_0.12.5-1.bionic_amd64.deb

## Nodejs engine
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

## YARN
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

## Ruby (must install libssl1.0-dev instead of libssl-dev for 2.3.x)
RUN apt install -y libssl1.0-dev zlib1g-dev libgdbm5
RUN wget http://ftp.ruby-lang.org/pub/ruby/2.3/ruby-2.3.7.tar.gz
RUN tar -xzvf ruby-2.3.7.tar.gz
RUN cd ruby-2.3.7/ && ./configure && make && make install

RUN apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

# Chromedriver whole setup (TODO: get CHROME_DRIVER_VERSION from chromedriver.storage.googleapis.com/LATEST_RELEASE)
ENV CHROME_DRIVER_VERSION=2.42
ENV SELENIUM_STANDALONE_VERSION=3.4.0
# TODO: get SELENIUM_STANDALONE_VERSION like so: $(echo "$SELENIUM_STANDALONE_VERSION" | cut -d"." -f-2)
ENV SELENIUM_SUBDIR=3.4

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
