FROM registry.home.divergentlogic.com/steamcmd:latest
ARG VALHEIM_HOME
ENV VALHEIM_HOME ${VALHEIM_HOME:-"/opt/valheim"}
ARG VALHEIM_BRANCH
ENV VALHEIM_BRANCH ${VALHEIM_BRANCH}
ARG VALHEIM_BRANCH_PASSWORD
ENV VALHEIM_BRANCH_PASSWORD ${VALHEIM_BRANCH_PASSWORD}

ARG VALHEIM_SERVER_NAME
ENV VALHEIM_SERVER_NAME ${VALHEIM_SERVER_NAME:-"My server"}
ARG VALHEIM_SERVER_WORLD
ENV VALHEIM_SERVER_WORLD ${VALHEIM_SERVER_WORLD:-"Dedicated"}
ARG VALHEIM_SERVER_PORT
ENV VALHEIM_SERVER_PORT ${VALHEIM_SERVER_PORT:-"2456"}
ARG VALHEIM_SERVER_PASSWORD
ENV VALHEIM_SERVER_PASSWORD ${VALHEIM_SERVER_PASSWORD:-"secret"}

RUN set -x \
  && dpkg --add-architecture i386 \
  && apt-get update -y \
  && apt-get install -y --no-install-recommends \
    netcat \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/apt/apt.conf.d/01proxy
RUN set -x \
  && mkdir -p $VALHEIM_HOME \
  && chown $STEAM_USER:$STEAM_USER $VALHEIM_HOME

ADD docker-entrypoint.sh /
EXPOSE 2456-2458/udp
RUN mkdir /data
VOLUME ["/data", "/opt/valheim"]
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "valheim_server.x86_64" ]
