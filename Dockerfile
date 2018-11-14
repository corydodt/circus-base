############################################################
# Begin multi-stage build!
FROM ubuntu:16.04 as stage1

COPY ./requirements.txt /

RUN apt update \
    && apt install --yes \
        python3 \
        python3-pip \
    && pip3 install wheel \
    && pip3 wheel --wheel-dir /wheels -r /requirements.txt

############################################################
# Begin stage2!
FROM ubuntu:16.04

COPY ./requirements.txt /

COPY --from=stage1 /wheels /wheels

RUN apt update \
    && apt --yes dist-upgrade \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean

RUN apt update \
    && apt install --yes \
        # coreutils for stdbuf
        coreutils \
        python3 \
        python3-pip \
        python-pip \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean

COPY ./circusbase /opt/Circusbase/circusbase
COPY ./setup.py /opt/Circusbase/

RUN pip3 install -U --force-reinstall --no-cache-dir pip \
    && export PATH=/usr/local/bin:$PATH \
    && pip3 install --no-index --find-links=$cbs1/wheels -r $cbs1/requirements.txt \
    && pip3 install --no-cache-dir /opt/Circusbase

COPY ./circus.ini /etc/
COPY ./99-stats.ini /etc/circus.d/

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENTRYPOINT ["stdbuf", "-oL", "circusd"]
CMD ["/etc/circus.ini"]
