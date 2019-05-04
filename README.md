# circus-base

A Python-based PID-1 replacement inside a container, with easy setup for applications
wanting to take advantage of Python-based process management.


### Use

Use this container as the base image for any number of possible uses. It
runs [Circus](https://circus.readthedocs.io/en/latest/), a process manager
that simplifies the initial creation of new long-running docker containers.

While running, it prints out process statistics every 5 minutes.

- To stop printing statistics, in your container, remove
  `/etc/circus.d/99-stats.ini`

Any `*.ini` files placed in `/etc/circus.d` will be used at startup. So, for
example,

- `COPY 00-myapp.ini /etc/circus.d/` (in a Dockerfile)


### Python 3

As of release 0.6.0, circus-base uses a Python 3 runtime interpreter. However,
circus can be used to launch *any* kind of service, regardless of implementation
details, as long as it has a command line you can run.

Hooks that you write must be in Python and will use the Python 3 runtime that
circus itself is using.


### Examples

Under [doc/example/](doc/example/).


### Maintainer docs

```
make images
# test with doc/example/doit-py3
make push
```


## Change Log

### [0.6.1] - May 4, 2019
#### Fixed
- (#14) /usr/bin/python is now whatever the default is, and /usr/local/bin/python is Python 3.7.

### [0.6.0] - April 22, 2019
#### Changed
- The runtime environment is now Python 3.7.3. (Closes: #9, #1, #3)

### [0.4.1] - April 19, 2019
#### Changed
- Added apt-transport-https package (Closes: #4)

### [0.4] - September 24, 2018
#### Changed
- Shrink image by using a multi-stage build

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


[0.6.1]: https://github.com/corydodt/circus-base/compare/release-0.6.0...release-0.6.1
[0.6.0]: https://github.com/corydodt/circus-base/compare/release-0.4.1...release-0.6.0
[0.4.1]: https://github.com/corydodt/circus-base/compare/release-0.4...release-0.4.1
[0.4]: https://github.com/corydodt/circus-base/compare/release-0.3...release-0.4
[0.3]: https://github.com/corydodt/circus-base/compare/release-0.2...release-0.3
[0.2]: https://github.com/corydodt/circus-base/tree/release-0.2
