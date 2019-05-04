############################################################
# Begin multi-stage build!
FROM ubuntu:18.04 as circusbasestage1

ENV cbs1 /circusbasestage1

COPY ./requirements.txt $cbs1/requirements.txt

# make python 3.7 available
RUN apt update \
    && apt install --yes software-properties-common \
    && add-apt-repository --yes ppa:deadsnakes/ppa \
    && apt update \
    # n.b. python3.7-venv is how you get `ensurepip` in this packaging structure.
    # This is fully stupid as hell.
    # See https://github.com/deadsnakes/issues/issues/79#issuecomment-463405207
    && apt install --yes \
        python3.7 \
        python3.7-venv \
        python3.7-dev \
        # someone want to explain to me why python3.7-dev doesn't pull in build-essential
        build-essential \
    && python3.7 -m ensurepip --default-pip

RUN pip install wheel \
    && pip wheel --wheel-dir $cbs1/wheels -r $cbs1/requirements.txt


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

# make python 3.7 available
RUN apt update \
    && apt install --yes software-properties-common \
    && add-apt-repository --yes ppa:deadsnakes/ppa \
    && apt install --yes \
        python3.7 \
        python3.7-venv \
        # coreutils for stdbuf
        coreutils \
    && ln -svn /usr/bin/python3.7 /usr/local/bin/python \
    && python -m ensurepip --default-pip \
    && rm -rf /var/lib/apt/lists \
    && apt autoremove --yes \
    && apt autoclean \
    && apt clean

# install circus-base pip requirements
RUN pip install -U --force-reinstall --no-cache-dir pip \
    && pip install --no-index --find-links=$cbs1/wheels -r $cbs1/requirements.txt \
    && pip install --no-cache-dir /opt/Circusbase

COPY ./circus.ini /etc/
COPY ./99-stats.ini /etc/circus.d/

ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

ENTRYPOINT ["stdbuf", "-oL", "circusd"]
CMD ["/etc/circus.ini"]
