# circus-base

### Use:

Use this container as the base image for any number of possible uses. It
runs [Circus](https://circus.readthedocs.io/en/latest/), a process manager
that simplifies the initial creation of new long-running docker containers.

While running, it prints out process statistics every 5 minutes.

- To stop printing statistics, in your container, remove
  `/etc/circus.d/99-stats.ini`

Any `*.ini` files placed in `/etc/circus.d` will be used at startup. So, for
example, 

- `COPY 00-myapp.ini /etc/circus.d/` (in a Dockerfile)


## Release Notes:

* 0.1: Increase stats interval to 1 hour.
