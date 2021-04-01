FROM python:3.8.8-alpine3.13

ADD requirements /app/requirements

RUN set -ex \
    && apk add --no-cache --virtual .build-deps postgresql-dev build-base redis\
    && python -m venv /env \
    && /env/bin/pip install --upgrade pip \
    && /env/bin/pip install --no-cache-dir -r /app/requirements/prod.txt \
    && runDeps="$(scanelf --needed --nobanner --recursive /env \
        | awk '{ gsub(/,/, "\nso:", $2); print "so:" $2 }' \
        | sort -u \
        | xargs -r apk info --installed \
        | sort -u)" \
    && apk add --virtual rundeps $runDeps \
    && apk del .build-deps

COPY . /app
WORKDIR /app
RUN mkdir /data
RUN ln -sf /env/lib/python3.7/site-packages /data/venv

ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

EXPOSE 8000
ENTRYPOINT ["/bin/sh", "entrypoint.sh"]