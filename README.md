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


## Change Log

### [0.3] - February 19, 2018
#### Changed
- Base image is ubuntu:16.04
- Current apt package updates
#### Removed
- Alpine support is discontinued

### [0.2] - October 29, 2017
#### Added
- Initial usable release
- `remoji()` in the log streams
#### Changed
- Base image is phusion/baseimage


[0.3]: https://github.com/corydodt/circus-base/compare/release-0.2...release-0.3
[0.2]: https://github.com/corydodt/circus-base/tree/release-0.2
