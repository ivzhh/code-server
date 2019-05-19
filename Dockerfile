FROM vscode:apt

RUN locale-gen en_US.UTF-8
# We unfortunately cannot use update-locale because docker will not use the env variables
# configured in /etc/default/locale so we need to set it manually.
ENV LC_ALL=en_US.UTF-8

RUN adduser --gecos '' --disabled-password coder && \
	echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

USER coder
# We create first instead of just using WORKDIR as when WORKDIR creates, the user is root.
RUN mkdir -p /home/coder/project && mkdir -p /home/coder/.local/

WORKDIR /home/coder/project

# This assures we have a volume mounted even if the user forgot to do bind mount.
# So that they do not lose their data if they delete the container.
VOLUME [ "/home/coder/project", "/home/coder/.local/share" ]

COPY code-server /usr/local/bin/code-server
EXPOSE 8443

ENTRYPOINT ["dumb-init", "code-server"]
