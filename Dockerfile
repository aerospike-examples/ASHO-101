FROM ubuntu:24.04 AS build

# remove default ubuntu user
RUN touch /var/mail/ubuntu && \
    chown ubuntu /var/mail/ubuntu && \
    userdel -r ubuntu

USER root

ARG TARGETPLATFORM
ARG ED_USER=aero_edu
ARG ED_UID=1000
ARG NODE_VERSION=22
ARG AEROSPIKE_VERSION=8.0.0.8
ARG AEROSPIKE_TOOLS_VERSION=11.2.2
ARG AEROSPIKE_ARCH

ENV HOME=/home/${ED_USER}
ENV NVM_DIR=${HOME}/.nvm

RUN useradd -l -m -s /bin/bash -N -u "${ED_UID}" "${ED_USER}"

WORKDIR /home/${ED_USER}

# basic setup
RUN mkdir -p /var/log/aerospike /var/run/aerospike /aerospike && \
    apt-get update -y && \
    apt-get install -y --no-install-recommends \ 
        curl software-properties-common build-essential \
        g++ libx11-dev libxkbfile-dev libsecret-1-dev libkrb5-dev \
        wget python3-pip python3-dev python3-venv python-is-python3 && \
    apt-get autoremove -y --purge && \
    rm -rf /var/lib/apt/lists/*

# install Aerospike
RUN case "$TARGETPLATFORM" in \
        "linux/amd64") \
            AEROSPIKE_ARCH="x86_64" \
        ;; \
        "linux/arm64") \
            AEROSPIKE_ARCH="aarch64" \
        ;; \
        *) exit 1 ;; \
    esac; \
    wget "https://download.aerospike.com/artifacts/aerospike-server-enterprise/${AEROSPIKE_VERSION}/aerospike-server-enterprise_${AEROSPIKE_VERSION}_tools-${AEROSPIKE_TOOLS_VERSION}_ubuntu24.04_${AEROSPIKE_ARCH}.tgz" -O aerospike-server.tgz && \  
    tar xzf aerospike-server.tgz --strip-components=1 -C /aerospike && \
    dpkg -i /aerospike/aerospike-server-*.deb && \
    dpkg -i /aerospike/aerospike-tools_*.deb && \
    usermod -a -G aerospike ${ED_USER} && \
    rm -rf aerospike-server.tgz /aerospike /var/lib/apt/lists/*

COPY /projects ${HOME}/projects/

#install Node.js and VSCode 
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    [ -s ${NVM_DIR}/nvm.sh ] && \. ${NVM_DIR}/nvm.sh && \
    [ -s ${NVM_DIR}/bash_completion ] && \. ${NVM_DIR}/bash_completion && \
    nvm install ${NODE_VERSION} && \
    npm install --global yarn && \
    curl -fsSL https://code-server.dev/install.sh | sh && \
    code-server \
        --install-extension ms-python.python \
        --install-extension ms-vscode.vscode-typescript-next \
        --install-extension dracula-theme.theme-dracula && \
    cd projects/website && \
    yarn && yarn build && cd ~

COPY /setup/start.sh /usr/local/bin/start.sh
COPY /setup/start_web.sh /usr/local/bin/start_web.sh
COPY /setup/aerospike.conf /etc/aerospike/aerospike.conf
COPY /setup/.bashrc ${HOME}/.bashrc
COPY /setup/.bashrc /root/.bashrc
COPY /setup/vscode ${HOME}/.local/share/code-server/User/

RUN chown -R ${ED_UID} ${HOME} /etc/aerospike /opt/aerospike /var/log/aerospike /var/run/aerospike && \
    chmod +x /usr/local/bin/start.sh /usr/local/bin/start_web.sh
    
# THESE TWO LINES ARE SUPPOSED TO TAKE CARE OF THE NON-EDITABLE SERVER FOLDER ISSUE FOR WINDOWS USERS
COPY --chown=${ED_UID}:${ED_UID} --chmod=ug=rwX /projects ${HOME}/projects/
RUN chmod -R ug+rwX ${HOME}/projects/server && find ${HOME}/projects/server -type d -exec chmod g+s {} \;

FROM ubuntu:24.04 AS final

USER root

ARG ED_USER=aero_edu

ENV HOME=/home/${ED_USER} \
    SHELL=/bin/bash 
ENV NVM_DIR=${HOME}/.nvm

USER root
WORKDIR /

# Load data
COPY --from=build . /

EXPOSE 8080
EXPOSE 8081

WORKDIR /home/${ED_USER}
USER ${ED_USER}

ENTRYPOINT [ "/bin/bash", "-c", "/usr/local/bin/start_web.sh ; /usr/local/bin/start.sh" ]
