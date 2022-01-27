FROM node:16.13.0-slim

RUN apt-get update && apt-get install -y \
    sudo curl vim wget procps \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

ENV NEXT_TELEMETRY_DISABLED=1
ENV USER_NAME=node
ENV USER_UID=1000
ARG wkdir=/home/${USER_NAME}/app

WORKDIR ${wkdir}

COPY ./app/package*.json /home/${USER_NAME}/app/
COPY ./app/yarn.lock /home/${USER_NAME}/app/

COPY ./app/ /home/${USER_NAME}/app/

RUN yarn install

RUN yarn build

RUN echo "root:root" | chpasswd \
    && usermod -aG sudo ${USER_NAME} \
    && echo "${USER_NAME}:${USER_NAME}" | chpasswd \
    && echo "%${USER_NAME}    ALL=(ALL)    NOPASSWD:    ALL" >> /etc/sudoers.d/${USER_NAME} \
    && chmod 0440 /etc/sudoers.d/${USER_NAME} \
    && chown -hR ${USER_NAME}:${USER_NAME} ${wkdir} 

USER ${USER_NAME}


# CMD [ "yarn", "start" ]
