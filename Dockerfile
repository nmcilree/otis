FROM python:3.6-stretch

RUN apt-get update
RUN apt-get install -y libpq-dev zip

COPY app/ /otis
RUN pip install -r /otis/requirements.txt

VOLUME /otis
WORKDIR /otis