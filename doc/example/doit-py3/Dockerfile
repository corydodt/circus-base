FROM corydodt/circus-base:latest

ENV doit /opt/doit

RUN mkdir -vp /opt/doit

WORKDIR ${doit}

COPY 00-doit.ini /etc/circus.d/
COPY *.py ${doit}/

# _n.b._ using "develop" instead of "install" is a convenient way to put /opt/doit in Python `sys.path`.
# In a production environment you might want to do this a different way.
RUN python setup.py develop