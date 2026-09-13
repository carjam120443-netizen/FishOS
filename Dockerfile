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
    && apt-get upgrade -y \
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
        linux-image-generic \
        mtools \
        nano \
        net-tools \
        opendoas \
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
    && apt-get install -y --only-upgrade sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# locale setup for image container
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
    && echo $TZ >/etc/timezone

# keep a doas-compatible command workspace in the image
RUN mkdir -p /etc/doas.d && chmod 755 /etc/doas.d

COPY scripts/bootstrap.sh /usr/local/bin/bootstrap.sh
COPY scripts/build-iso.sh /usr/local/bin/build-iso.sh
COPY scripts/install-branding.sh /usr/local/bin/install-branding.sh
COPY scripts/install-fetch-branding.sh /usr/local/bin/install-fetch-branding.sh
COPY scripts/run-xfce.sh /usr/local/bin/run-xfce.sh
RUN chmod +x /usr/local/bin/bootstrap.sh /usr/local/bin/build-iso.sh /usr/local/bin/install-branding.sh /usr/local/bin/install-fetch-branding.sh /usr/local/bin/run-xfce.sh

COPY branding ${FISHOS_HOME}/branding
COPY calamares ${FISHOS_HOME}/calamares
COPY grub ${FISHOS_HOME}/grub
COPY . ${APP_HOME}

RUN /usr/local/bin/bootstrap.sh \
    && /usr/local/bin/install-branding.sh \
    && /usr/local/bin/install-fetch-branding.sh

CMD ["/usr/local/bin/run-xfce.sh"]
