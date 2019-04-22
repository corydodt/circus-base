# Example: Python 3 program in the circus-base container

Here's a complete example of a Python 3 application container running with circus-base.

### Summary

- It uses `#!/usr/bin/env python` to run the main script, which invokes Python 2
- The Dockerfile installs everything in a virtualenv and in `/opt/py2prog`
- There is a `before_start` hook which must run before the watcher (your app) launches


### Try it out

- Run:

    ```
    cd doc/example/doit-py3
    docker build . -t doit
    docker run doit
    ```


### Files

- `doit.py` just prints "hello". It uses Python 2 syntax to prove we're
  running it with a Python 2 interpreter.
- `doit_hook.py` contains a circus hook.
- `00-doit.ini` runs the command and tells circus to use the stdout/stderr stream classes.
- `Dockerfile` sets `VIRTUALENVWRAPPER_PYTHON` and then uses virtualenvwrapper (and `bash -c`)
  to install the Python 2 application.
