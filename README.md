# SWI-Prolog HTTP daemon service

Build using:

    docker build . -t royratcliffe/swi-prolog-httpd-srv:alpine

## No forking

Process number 1 has special significance for Unix and Unix-based systems.

## User

The daemon does **not** run as root.

    'Refusing to run HTTP server as root': No permission to open server `http'

Asking for all the processes reveals the PID-1 processes.

    /srv # ps
    PID   USER     TIME  COMMAND
        1 daemon    0:00 /usr/bin/swipl -f init.pl

## Port

The daemon serves HTTP on port 8080 by default. Override it using Docker environment variables.

    ENV HTTP_DAEMON_PORT=8081

## HTTP log

The `/var/log` directory has root-only access. Makes a `daemon` sub-directory for the `daemon` user and group with read-write access so that the HTTP logger can create and rotate its logs.

## Command-line arguments

Command-line arguments must override environment variables but arguments should also allow for environment variables passed by Docker within the container. Settings predicate files exist as a final backup.

The Unix daemon module defines its server options. It does not defines the expected types.
```prolog
http_unix_daemon:server_option(A).
A = port(_) ;
A = ip(_) ;
A = certfile(_) ;
A = keyfile(_) ;
A = pwfile(_) ;
A = password(_) ;
A = cipherlist(_) ;
A = workers(_) ;
A = redirect(_) ;
A = timeout(_) ;
A = keep_alive_timeout(_).
```
