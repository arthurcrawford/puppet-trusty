FROM ubuntu:trusty
ENV TERM=linux
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    && wget https://apt.puppetlabs.com/puppetlabs-release-pc1-trusty.deb \
    && dpkg -i puppetlabs-release-pc1-trusty.deb \
    && apt-get install -y puppet \
    && rm -rf /var/lib/apt/lists/*

#COPY docker-entrypoint.sh /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]

