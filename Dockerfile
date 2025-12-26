FROM barichello/godot-ci:4.5.1
RUN apt-get update && apt-get install -y \
    ca-certificates \
    lib32gcc-s1 \
    lib32stdc++6 \
    curl \
    locales \
    && rm -rf /var/lib/apt/lists/*
RUN mkdir -p /opt/steamcmd && cd /opt/steamcmd \
    && curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -
RUN ln -s /opt/steamcmd/steamcmd.sh /usr/local/bin/steamcmd
RUN steamcmd +quit || true
WORKDIR /build