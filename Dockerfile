# Copyright (c) 2012-2018 Red Hat, Inc.
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
#
# Contributors:
#   Red Hat, Inc. - initial API and implementation

FROM ubuntu:14.04

ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV PATH=$JAVA_HOME/bin:$PATH
RUN apt-get update && \
    apt-get -y install \
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
    python-software-properties \
    bash-completion && \
    mkdir /var/run/sshd && \
    sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
    echo "%sudo ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    # Adding user to the 'root' is a workaround for https://issues.jboss.org/browse/CDK-305
    useradd -u 1000 -G users,sudo,root -d /home/user --shell /bin/bash -m user && \
    usermod -p "*" user && \
    add-apt-repository ppa:git-core/ppa && \
    add-apt-repository ppa:openjdk-r/ppa && \
    apt-get update && \
    sudo apt-get install git subversion -y && \
    apt-get clean && \
    apt-get -y autoremove

#RUN sudo apt-get install openjdk-8-jdk-headless=openjdk-8-jdk_8u131 openjdk-8-source=openjdk-8-jdk_8u131 -y && \
RUN sudo apt-get install -y openjdk-8-jre && \ 
    update-ca-certificates -f && \
    sudo sudo /var/lib/dpkg/info/ca-certificates-java.postinst configure && \
    apt-get -y clean && \
    rm -rf /var/lib/apt/lists/*

RUN sed 's@\#AuthorizedKeysFile@AuthorizedKeysFile@g' -i /etc/ssh/sshd_config && \
    sed 's@Port\s22@Port 22222@g' -i /etc/ssh/sshd_config && \
    mkdir -p /home/user/.ssh && \
    touch /home/user/.ssh/authorized_keys && \
    echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQDSoMib75zc/RjJtVFaR60p/PzRKpeKCAlsatoRaRzCD+LaVNi/yIeR2bZZRY2HZKxAZeO6/PgJobuW7QQDCpCLX2I5yER8yQFhniHa1EZfrYH/IRoRmyeN7b2PZ/wypOjC5Yae9cXtcmIV4RmpFOEfTxoLEzVbU54JYIa8QejYfQ== user@scclab.pri" >> /home/user/.ssh/authorized_keys && \
    chown -R user:user /home/user/.ssh/ && \
    chmod 0400 /home/user/.ssh/authorized_keys


ENV LANG en_GB.UTF-8
ENV LANG en_US.UTF-8
USER user
RUN sudo locale-gen en_US.UTF-8 && \
    svn --version && \
    cd /home/user && ls -la && \
    sed -i 's/# store-passwords = no/store-passwords = yes/g' /home/user/.subversion/servers && \
    sed -i 's/# store-plaintext-passwords = no/store-plaintext-passwords = yes/g' /home/user/.subversion/servers
COPY open-jdk-source-file-location /open-jdk-source-file-location
EXPOSE 22222 4403
WORKDIR /projects

# The following instructions set the right
# permissions and scripts to allow the container
# to be run by an arbitrary user (i.e. a user
# that doesn't already exist in /etc/passwd)
ENV HOME /home/user
RUN for f in "/home/user" "/etc/passwd" "/etc/group" "/projects"; do\
           sudo chgrp -R 0 ${f} && \
           sudo chmod -R g+rwX ${f}; \
        done && \
        # Generate passwd.template \
        cat /etc/passwd | \
        sed s#user:x.*#user:x:\${USER_ID}:\${GROUP_ID}::\${HOME}:/bin/bash#g \
        > /home/user/passwd.template && \
        # Generate group.template \
        cat /etc/group | \
        sed s#root:x:0:#root:x:0:0,\${USER_ID}:#g \
        > /home/user/group.template && \
        sudo sed -ri 's/StrictModes yes/StrictModes no/g' /etc/ssh/sshd_config
COPY ["entrypoint.sh","/home/user/entrypoint.sh"]
ENTRYPOINT ["/home/user/entrypoint.sh"]
CMD sudo /usr/sbin/sshd -D && tail -f /dev/null
