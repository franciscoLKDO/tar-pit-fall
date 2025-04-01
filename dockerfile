ARG FROM_IMAGE=alpine:3.21

FROM ${FROM_IMAGE}

ARG USER=user

ENV USER=${USER}
ENV WORKDIR=/home/${USER}

WORKDIR ${WORKDIR}

RUN addgroup ${USER} && adduser -D -G ${USER} ${USER}

RUN echo "YOU GOT IT" > /root/flag.txt

COPY ./guntar /home/${USER}/guntar
COPY ./start.sh /root

RUN chmod +s /home/${USER}/guntar

RUN apk add --no-cache openssh 
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

RUN echo -n "${USER}:test" | chpasswd

EXPOSE 22

ENTRYPOINT ["/root/start.sh"]