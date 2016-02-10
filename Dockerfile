FROM ubuntu:trusty
ENV TERM=linux
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-transport-https \
    wget \
    curl \
    ca-certificates \
    git \
    && rm -rf /var/lib/apt/lists/*
RUN wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb \
    && dpkg -i puppetlabs-release-pc1-trusty.deb \
    && apt-get update \
    && apt-get install -y puppet-agent \
    && rm -rf /var/lib/apt/lists/*
env PATH /opt/puppetlabs/puppet/bin:$PATH
RUN gem install r10k

