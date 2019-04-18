FROM corydodt/circus-base:0.5 as py2prog1

ENV py2prog /opt/py2prog

ENV VIRTUALENVWRAPPER_PYTHON=/usr/bin/python

RUN mkdir -vp /opt/py2prog \
    && pip2 install virtualenvwrapper \
    && bash -c ". /usr/local/bin/virtualenvwrapper.sh \
    && mkvirtualenv -a $py2prog py2prog \
    && add2virtualenv $py2prog \
    "

ENV PYTHONUSERBASE ${WORKON_HOME}/py2prog
ENV PATH ${PYTHONUSERBASE}/bin:${PATH}:${py2prog}
WORKDIR ${py2prog}

COPY 00-py2prog.ini /etc/circus.d/
COPY *.py ${py2prog}/
