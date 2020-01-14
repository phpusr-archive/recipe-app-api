FROM python:3.8-alpine
MAINTAINER phpusr

ENV PYTHONUNBUFFERED 1

COPY ./Pipfile /app/Pipfile
RUN cd /app \
    && pip install --upgrade pipenv \
    && pipenv lock --requirements > requirements.txt \
    && pip install -r requirements.txt

COPY . /app/
WORKDIR /app/

RUN adduser -D user
USER user
