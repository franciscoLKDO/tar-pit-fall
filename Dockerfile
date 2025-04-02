ARG BUILDER_IMAGE=amd64/golang:1.20-alpine
ARG FROM_IMAGE=alpine:3.21

FROM ${BUILDER_IMAGE} AS builder

ARG GUNTAR_BRANCH=ctf-challenge

RUN apk update && apk add git

RUN git clone https://github.com/franciscoLKDO/guntar.git \
    && cd guntar \
    && git checkout ${GUNTAR_BRANCH} \
    && go build -o /guntar

ARG FLAG="You found Me!"
RUN echo ${FLAG} > /flag.txt

ARG USER=user
ARG USER_PASSWORD=testuser
RUN echo -n "${USER}:${USER_PASSWORD}" > /user_pass

FROM ${FROM_IMAGE}

COPY --from=builder /guntar /usr/local/bin/guntar
COPY --from=builder /flag.txt /root/flag.txt
COPY --from=builder /user_pass /user_pass

COPY ./start.sh /root
COPY motd /etc/motd

ARG USER=user
ENV USER=${USER}

ENV WORKDIR=/home/${USER}
WORKDIR ${WORKDIR}

RUN addgroup ${USER} && adduser -D -G ${USER} ${USER}
RUN chmod +s /usr/local/bin/guntar

RUN apk add --no-cache openssh
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config

RUN cat /user_pass | chpasswd \
    && rm /user_pass

EXPOSE 22

ENTRYPOINT ["/root/start.sh"]

ARG COMMIT_ID
ENV COMMIT_ID=${COMMIT_ID}