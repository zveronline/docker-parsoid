FROM alpine:3.14

LABEL maintainer="mail@zveronline.ru"

ENV PARSOID_HOME=/var/lib/parsoid \
    PARSOID_USER=parsoid \
    # PARSOID_VERSION [v0.8.1, v0.9.0, v0.10.0, v0.11.0, master]
    PARSOID_VERSION=v0.11.1

COPY run-parsoid.sh /run-parsoid.sh

# Parsoid setup
RUN set -x \
    # Install required packages
    && apk add --no-cache npm python2 git tar bash make g++  \
    # Add user
    && adduser -D -u 1000 -s /bin/bash $PARSOID_USER \
    # Set permissions
    && chmod -v +x /run-parsoid.sh \
    # Core
    && mkdir -p $PARSOID_HOME

RUN set -x && git clone \
        --branch ${PARSOID_VERSION} \
        --single-branch \
        --depth 1 \
        --quiet \
        https://github.com/wikimedia/mediawiki-services-parsoid \
        $PARSOID_HOME \
    && cd $PARSOID_HOME \
    && pwd \
    && ls \
    && npm install

EXPOSE 8000
EXPOSE 8001

CMD ["/run-parsoid.sh"]
