# vim:set ft=dockerfile:

############################################################
# Begin multi-stage build!
FROM ubuntu:16.04 as stage1

COPY ./requirements.txt /

RUN apt update \
    && apt install --yes python-dev \
    && apt install --yes \
        # coreutils for stdbuf
        coreutils \
        # g++ required for circusd's use of cython
        g++ \
        python \
        python-pip \
    && pip install wheel \
    && pip wheel --wheel-dir /wheels -r /requirements.txt

############################################################
# Begin stage2!
FROM ubuntu:16.04

COPY ./requirements.txt /

COPY --from=stage1 /wheels /wheels
COPY --from=stage1 /opt /opt

RUN apt update \
    && apt --yes dist-upgrade \
    && rm -rf /var/lib/apt/lists \
    && apt autoclean \
    && apt clean

COPY ./circusbase /opt/Circusbase/circusbase
COPY ./setup.py /opt/Circusbase/

RUN apt update \
    && apt install --yes \
        # coreutils for stdbuf
        coreutils \
        # g++ required for circusd's use of cython
        g++ \
        python \
        python-pip \
    && pip install --no-index --find-links=/wheels -r /requirements.txt \
    && pip install --no-cache-dir /opt/Circusbase \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean


COPY ./circus.ini /etc/
COPY ./99-stats.ini /etc/circus.d/

ENTRYPOINT ["stdbuf", "-oL", "circusd"]
CMD ["/etc/circus.ini"]
