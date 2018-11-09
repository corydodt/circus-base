# vim:set ft=dockerfile:

############################################################
# Begin multi-stage build!
FROM ubuntu:16.04 as circusbasestage1

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
FROM ubuntu:16.04

ENV cbs1 /circusbasestage1
ENV VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3

COPY --from=circusbasestage1 ${cbs1} ${cbs1}

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
        python3 \
        python3-pip \
    && pip3 install --no-index --find-links=$cbs1/wheels -r $cbs1/requirements.txt \
    && pip3 install --no-cache-dir virtualenvwrapper /opt/Circusbase \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean


COPY ./circus.ini /etc/
COPY ./99-stats.ini /etc/circus.d/

ENTRYPOINT ["stdbuf", "-oL", "circusd"]
CMD ["/etc/circus.ini"]
