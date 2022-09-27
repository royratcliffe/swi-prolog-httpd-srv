FROM royratcliffe/swi-prolog-srv:alpine

COPY .config /root/.config

WORKDIR /srv
COPY srv .

ENV HTTPD_USER=daemon
RUN for x in "mkdir -p" "chown daemon:daemon" ; \
    do $x /var/log/daemon ; \
    done
