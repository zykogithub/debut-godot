FROM barichello/godot-ci:4.5.1

RUN apt-get upgrade -y && apt-get update -y && apt-get install -y curl

RUN curl https://broth.itch.zone/butler/linux-amd64/LATEST/archive/default -o /usr/local/bin/butler
RUN chmod +x /usr/local/bin/butler
