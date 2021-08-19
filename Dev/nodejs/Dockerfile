FROM  fgst/dev:base
MAINTAINER "tuanna47@fpt.com.vn"

# Active RSA
RUN sudo sed 's@\#AuthorizedKeysFile@AuthorizedKeysFile@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#RSAAuthentication@RSAAuthentication@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#PubkeyAuthentication@PubkeyAuthentication@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#UsePAM@UsePAM@g' -i /etc/ssh/sshd_config && \
    sudo sed 's@\#PasswordAuthentication\syes@PasswordAuthentication no@g' -i /etc/ssh/sshd_config && \
    mkdir -p /home/user/.ssh && \
    touch /home/user/.ssh/authorized_keys && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDSoMib75zc/RjJtVFaR60p/PzRKpeKCAlsatoRaRzCD+LaVNi/yIeR2bZZRY2HZKxAZeO6/PgJobuW7QQDCpCLX2I5yER8yQFhniHa1EZfrYH/IRoRmyeN7b2PZ/wypOjC5Yae9cXtcmIV4RmpFOEfTxoLEzVbU54JYIa8QejYfQ== user@scclab.pri" >> /home/user/.ssh/authorized_keys && \
    chown -R user:user /home/user/.ssh/ && \
    chmod 0400 /home/user/.ssh/authorized_keys && \
    echo "secret" | sudo passwd user --stdin

# Starup
USER user
ENTRYPOINT ["/home/user/entrypoint.sh"]
CMD sudo /usr/sbin/sshd -D && tail -f /dev/null
