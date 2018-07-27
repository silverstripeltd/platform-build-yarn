FROM stojg/node:8.1@sha256:fe45a08e0222a366125b73af3d71fdb741a2122221e5ef5f6f6d8b93de8d02e7

RUN apt-get update && apt-get install -y curl php5-cli git

RUN mkdir -p ~/.ssh
RUN chmod 0700 ~/.ssh
RUN printf "Host *\nStrictHostKeyChecking no\nUserKnownHostsFile /dev/null\n" > ~/.ssh/config
RUN chmod 400 ~/.ssh/config

RUN php -r "copy('https://getcomposer.org/installer', '/tmp/composer-setup.php');"
RUN php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN composer global require silverstripe/vendor-plugin-helper

COPY docker-entrypoint.sh /docker-entrypoint.sh

WORKDIR /app
ENTRYPOINT ["/docker-entrypoint.sh"]
