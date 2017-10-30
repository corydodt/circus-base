from setuptools import setup

from circusbase import _version

setup(
  name = 'circusbase',
  packages = ['circusbase'],
  version = _version.__version__,
  author = 'Cory Dodt',
  author_email = 'corydodt@gmail.com',
  url = 'https://github.com/corydodt/circus-base',
)
