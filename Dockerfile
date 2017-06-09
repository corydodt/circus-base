# vim:set ft=dockerfile:
FROM alpine:3.5

RUN apk update \
    && apk add --no-cache --virtual build-dependencies \
        python-dev \
        linux-vanilla-dev \
        linux-headers \
    && apk add --no-cache \
        bash \
        coreutils \
        # g++ required for circusd's use of cython
        g++ \
        python \
    && python -m ensurepip \
    && pip install -U --no-cache-dir circus \
    && apk del build-dependencies

COPY ./circus.ini /etc/
COPY ./99-stats.ini /etc/circus.d/

ENTRYPOINT ["stdbuf", "-oL", "circusd"]
CMD ["/etc/circus.ini"]

