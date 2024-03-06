FROM ubuntu:22.04

# Geography
ENV TZ=Europe/Rome \
    DEBIAN_FRONTEND=noninteractive \
    DATA_FOLDER=/app/data
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Luatex installation
RUN apt-get update && \
    apt-get install -y texlive-full

# Python installation
RUN apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update -y && \
    apt install python3.11 python3-pip -y && \
    python3.11 -m pip install poetry
