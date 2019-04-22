import platform


# this file must be executable in python3 to use a hook from here!
def before_start(watcher, arbiter, hook_name, **kwargs):
    print("hello before_start hook for Python %s" % platform.python_version())
    return True
