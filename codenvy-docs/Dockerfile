FROM eclipse/ubuntu_jdk8
EXPOSE 4403 8000 8080 9876 22

LABEL che:server:8080:ref=tomcat8 che:server:8080:protocol=http che:server:8000:ref=tomcat8-debug che:server:8000:protocol=http che:server:9876:ref=codeserver che:server:9876:protocol=http

RUN export DEBIAN_FRONTEND=noninteractive \
 && sudo apt-get update \
 && sudo apt-add-repository -y ppa:brightbox/ruby-ng \
 && sudo apt-get update \
 && sudo apt-get -y install ruby2.2 ruby2.2-dev build-essential \
 && sudo gem install jekyll -v 3.3.1 \
 && sudo gem install jekyll-feed jekyll-redirect-from jekyll-sitemap \
 && sudo apt-get install zlib1g-dev \
 && sudo gem install html-proofer -v 3.4.0
 
