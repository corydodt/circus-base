from setuptools import setup

_version = {}

exec(open('circusbase/_version.py').read(), _version)

setup(
  name = 'circusbase',
  packages = ['circusbase'],
  version = _version['__version__'],
  author = 'Cory Dodt',
  author_email = '121705+corydodt@users.noreply.github.com',
  url = 'https://github.com/corydodt/circus-base',
  install_requires = [
    'circus>=0.15,<1.0',
    'codado>=0.6.1,<1.0',
    'virtualenvwrapper>=4.8.2,<4.9'
  ]
)
