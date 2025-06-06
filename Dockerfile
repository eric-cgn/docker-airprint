FROM debian:stable-slim

# Enable i386 architecture
RUN dpkg --add-architecture i386 && \
    apt-get update

# Install the packages we need, including gutenprint and necessary multiarch support
RUN apt-get install -y --no-install-recommends \
    cups \
    libcups2 \
    libcups2:i386 \
    cups-pdf \
    cups-filters \
    libcupsimage2-dev \
    ghostscript \
    hplip \
    avahi-daemon \
    inotify-tools \
    python3 \
    python3-dev \
    python3-cups \
    build-essential \
    wget \
    iproute2 \
    rsync \
    file \
    a2ps \
    libgutenprint-dev && \
    rm -rf /var/lib/apt/lists/*

# Set the default architecture (optional, but can be helpful)
ENV DEBIAN_ARCH=amd64

COPY brother /brother
RUN dpkg --install /brother/*deb

# This will use port 631
EXPOSE 631

# We want a mount for these
VOLUME /config
VOLUME /services

# Add scripts
ADD root /
RUN chmod +x /root/*

#Run Script
CMD ["/root/run_cups.sh"]

# Baked-in config file changes
RUN sed -i 's/Listen localhost:631/Listen 0.0.0.0:631/' /etc/cups/cupsd.conf && \
	sed -i 's/Browsing Off/Browsing On/' /etc/cups/cupsd.conf && \
 	sed -i 's/IdleExitTimeout/#IdleExitTimeout/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/>/<Location \/>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin>/<Location \/admin>\n  Allow All\n  Require user @SYSTEM/' /etc/cups/cupsd.conf && \
	sed -i 's/<Location \/admin\/conf>/<Location \/admin\/conf>\n  Allow All/' /etc/cups/cupsd.conf && \
	sed -i 's/.*enable\-dbus=.*/enable\-dbus\=no/' /etc/avahi/avahi-daemon.conf && \
	echo "ServerAlias *" >> /etc/cups/cupsd.conf && \
	echo "DefaultEncryption Never" >> /etc/cups/cupsd.conf && \
	echo "ReadyPaperSizes A4,TA4,4X6FULL,T4X6FULL,2L,T2L,A6,A5,B5,L,TL,INDEX5,8x10,T8x10,4X7,T4X7,Postcard,TPostcard,ENV10,EnvDL,ENVC6,Letter,Legal" >> /etc/cups/cupsd.conf && \
	echo "DefaultPaperSize Letter" >> /etc/cups/cupsd.conf
