############################################################
# Begin multi-stage build!
FROM ubuntu:18.04 as circusbasestage1

ENV cbs1 /circusbasestage1

COPY ./requirements.txt $cbs1/requirements.txt

RUN apt update
RUN apt install --yes \
        python3-dev \
        python3-pip
RUN pip3 install wheel
RUN pip3 wheel --wheel-dir $cbs1/wheels -r $cbs1/requirements.txt


############################################################
# Begin stage2!
FROM ubuntu:18.04

ENV cbs1 /circusbasestage1

COPY --from=circusbasestage1 ${cbs1} ${cbs1}

RUN apt update \
    && apt --yes dist-upgrade \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean

COPY ./circusbase /opt/Circusbase/circusbase
COPY ./setup.py /opt/Circusbase/

RUN apt update \
    && apt install --yes \
        # coreutils for stdbuf
        coreutils \
        python \
        python-pip \
    && pip3 install --no-index --find-links=$cbs1/wheels -r $cbs1/requirements.txt \
    && pip3 install --no-cache-dir virtualenvwrapper /opt/Circusbase \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean

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
