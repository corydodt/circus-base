# Example: Python 2 program in Python 3 circus

Here's a complete example of a Python 2 application container running with circus-base.

### Summary

- It uses `#!/usr/bin/env python` to run the main script, which invokes Python 2
- The Dockerfile installs everything in a virtualenv and in `/opt/py2prog`
- There is a `before_start` hook which is written in Python 2/3 syntax code. Hooks
  have to be compatible with Python 3 syntax.


### Try it out

- Run:

    ```
    cd doc/example/py2prog
    docker build . -l py2prog
    docker run py2prog
    ```


### Files

- `python2program.py` just prints "hello". It uses Python 2 syntax to prove we're
  running it with a Python 2 interpreter.
- `python2_3_hook.py` contains a circus hook. This file is compatible with Python 3
  syntax because it gets run by the same interpreter that's running circus.
- `00-py2prog.ini` runs the command and tells circus to look for code to import in
  the Python 2 virtualenv. It also sets the stdout/stderr stream classes.
- `Dockerfile` sets `VIRTUALENVWRAPPER_PYTHON` and then uses virtualenvwrapper (and `bash -c`)
  to install the Python 2 application.
