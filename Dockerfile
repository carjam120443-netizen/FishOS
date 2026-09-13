# syntax=docker/dockerfile:1
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive \
    LANG=C.UTF-8 \
    TZ=Etc/UTC \
    APP_HOME=/opt/base-linux \
    FISHOS_HOME=/opt/fishos \
    FISHOS_DESKTOP=xfce

WORKDIR ${APP_HOME}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        dbus-x11 \
        fish \
        git \
        jq \
        less \
        lightdm \
        nano \
        net-tools \
        procps \
        sudo \
        tzdata \
        wget \
        xfce4 \
        xfce4-goodies \
        xorg \
        xorriso \
        xterm \
        calamares \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ >/etc/timezone \
    && rm -rf /var/lib/apt/lists/*

COPY scripts/bootstrap.sh /usr/local/bin/bootstrap.sh
COPY scripts/build-iso.sh /usr/local/bin/build-iso.sh
COPY scripts/install-branding.sh /usr/local/bin/install-branding.sh
COPY scripts/run-xfce.sh /usr/local/bin/run-xfce.sh
RUN chmod +x /usr/local/bin/bootstrap.sh /usr/local/bin/build-iso.sh /usr/local/bin/install-branding.sh /usr/local/bin/run-xfce.sh

COPY branding ${FISHOS_HOME}/branding
COPY calamares ${FISHOS_HOME}/calamares
COPY grub ${FISHOS_HOME}/grub
COPY . ${APP_HOME}

RUN /usr/local/bin/bootstrap.sh \
    && /usr/local/bin/install-branding.sh

CMD ["/usr/local/bin/run-xfce.sh"]
