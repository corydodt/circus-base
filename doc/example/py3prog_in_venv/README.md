# Example: Python 3 program, packaged in a virtualenv

TODO - incomplete example.


### Notes

- Set `VIRTUALENVWRAPPER_PYTHON` before running any python3 virtualenv commands
- You can change `WORKON_HOME` if you wish. If you want to install in a venv in stage1 and 
  copy that virtualenv in stage2, setting `WORKON_HOME` to the directory you want to 
  copy is one way to do that.
- Use `bash -c` to create the virtualenv. Afterwards, set `PATH` to include `WORKON_HOME/..$env../bin`
- Use `add2virtualenv` to create pth files
- In your `.ini` file, set `copy_env: true` and `virtualenv: $(circus.env.WORKON_HOME)/..$env..`


### Try it out (TODO)

- Run:

    ```
    cd doc/example/py3prog_in_venv
    docker build . -l py3prog_in_venv
    docker run py3prog_in_venv
    ```
