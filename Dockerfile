FROM ubuntu:14.04

RUN apt-get update \
	&& DEBIAN_FRONTEND=noninteractive \
	apt-get install -y \
	ca-certificates \
	fonts-takao \
	gconf-service \
	gksu \
	libappindicator1 \
	libasound2 \
	libcurl3 \
	libgconf-2-4 \
	libnspr4 \
	libnss3 \
	libpango1.0-0 \
	pulseaudio \
	python-psutil \
	supervisor \
	wget \
	x11vnc \
	xbase-clients \
	xdg-utils \
	xvfb \
    iptables \
    curl \
    && curl -L https://github.com/docker-infra/reefer/releases/download/v0.0.4/reefer.gz | \
       gunzip >/usr/bin/reefer \
    && chmod a+x /usr/bin/reefer \
	&& rm -rf /var/lib/apt/lists/*

ADD https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb /chrome.deb
ADD https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb /crd.deb

RUN dpkg -i /chrome.deb && dpkg -i /crd.deb && rm /chrome.deb /crd.deb

RUN ln -s /lib/x86_64-linux-gnu/libudev.so.1 /lib/x86_64-linux-gnu/libudev.so.0

COPY supervisord.template.conf /etc/supervisor/conf.d/supervisord.template.conf
COPY supervisord-crdonly.conf /etc/supervisor/conf.d/supervisord-crdonly.conf

RUN addgroup chrome-remote-desktop && useradd -m -G chrome-remote-desktop,pulse-access chrome
ENV CHROME_REMOTE_DESKTOP_DEFAULT_DESKTOP_SIZES 1024x768

ADD crdonly /crdonly
RUN chmod +x /crdonly

ADD crd-session /crd-session

VOLUME ["/home/chrome"]

ENV CHROME_ARGS "" \
    CHROME_URL ""

EXPOSE 5900

ENTRYPOINT [ "/usr/bin/reefer", \
    "-t", "/etc/supervisor/conf.d/supervisord.template.conf:/etc/supervisor/conf.d/supervisord.conf", \
    "-E", \
    "/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf" \
]
