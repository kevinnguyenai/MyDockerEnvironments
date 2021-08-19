FROM minimum2scp/nodejs:latest
LABEL maintainer="YAMADA Tsuyoshi <tyamada@minimum2scp.org>"

# Setup more packages requirements
RUN sudo apt-get update && apt-get install -y \
    vim \
    nano \
    locales \
    rsync \
    openssh-server \
    sudo \
    procps \
    wget \
    unzip \
    mc \
    ca-certificates \
    curl \
    software-properties-common \
    bash-completion

# Active RSA
RUN sudo sed 's@\#AuthorizedKeysFile@AuthorizedKeysFile@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#RSAAuthentication@RSAAuthentication@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#PubkeyAuthentication@PubkeyAuthentication@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#UsePAM@UsePAM@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#PasswordAuthentication@PasswordAuthentication@g' -i /etc/ssh/sshd_config && \
    mkdir -p /home/debian/.ssh && \
    touch /home/debian/.ssh/authorized_keys && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDSoMib75zc/RjJtVFaR60p/PzRKpeKCAlsatoRaRzCD+LaVNi/yIeR2bZZRY2HZKxAZeO6/PgJobuW7QQDCpCLX2I5yER8yQFhniHa1EZfrYH/IRoRmyeN7b2PZ/wypOjC5Yae9cXtcmIV4RmpFOEfTxoLEzVbU54JYIa8QejYfQ== user@scclab.pri" >> /home/debian/.ssh/authorized_keys && \
    chown -R debian:debian /home/debian/.ssh/ && \
    chmod 0400 /home/debian/.ssh/authorized_keys

# Expose port and service
EXPOSE 22 3000 8443 9443

ENTRYPOINT ["/opt/init-wrapper/sbin/entrypoint.sh"]
CMD ["/sbin/init"]

