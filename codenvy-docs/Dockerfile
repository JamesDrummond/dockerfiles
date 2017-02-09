FROM eclipse/ubuntu_jdk8
EXPOSE 4403 8000 8080 9876 22

RUN export DEBIAN_FRONTEND=noninteractive \
    sudo apt-get update \
    sudo apt-get -y install apt-transport-https ca-certificates \
    sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" | sudo tee /etc/apt/sources.list.d/docker.list \
    sudo apt-get update \
    apt-cache policy docker-engine \
    sudo apt-get update \
    sudo apt-get -y install docker-engine \
    sudo apt-get -y install python-pip \
    sudo pip install docker-compose \
    sudo apt-add-repository -y ppa:brightbox/ruby-ng \
    sudo apt-get update \
    sudo apt-get -y install ruby2.2 ruby2.2-dev build-essential \
    sudo gem install jekyll -v 3.3.1 \
    sudo gem install jekyll-feed jekyll-redirect-from jekyll-sitemap \
    sudo apt-get install zlib1g-dev \
    sudo gem install html-proofer -v 3.4.0
