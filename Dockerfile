FROM python:3.8-alpine
MAINTAINER phpusr

ENV PYTHONUNBUFFERED 1

COPY ./Pipfile /app/Pipfile

RUN apk add --update --no-cache postgresql-client \
    && apk add --update --no-cache --virtual .tmp-build-deps gcc libc-dev linux-headers postgresql-dev \
    && cd /app \
    && pip install --upgrade pipenv \
    && pipenv lock --requirements > requirements.txt \
    && pipenv lock --requirements --dev >> requirements.txt \
    && pip install -r requirements.txt \
    && apk del .tmp-build-deps

COPY . /app/
WORKDIR /app/

RUN adduser -D user
USER user
