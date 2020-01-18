FROM python:3.8-alpine
MAINTAINER phpusr

ENV PYTHONUNBUFFERED 1

COPY ./Pipfile /app/Pipfile
COPY ./Pipfile.lock /app/Pipfile.lock

RUN apk add --update --no-cache postgresql-client jpeg-dev \
    && apk add --update --no-cache --virtual .tmp-build-deps gcc libc-dev linux-headers postgresql-dev musl-dev zlib zlib-dev \
    && cd /app \
    && pip install --upgrade pipenv \
    && pipenv lock --requirements > requirements.txt \
    && pipenv lock --requirements --dev >> requirements.txt \
    && pip install -r requirements.txt \
    && apk del .tmp-build-deps

COPY . /app/
WORKDIR /app/

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol
RUN chmod -R 700 /vol/web
USER user
