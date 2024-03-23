FROM ubuntu as guetzli

WORKDIR /app

RUN apt-get update && \
    apt-get install -y wget && \
    wget https://github.com/google/guetzli/releases/download/v1.0.1/guetzli_linux_x86-64 && \
    chmod +x guetzli_linux_x86-64 && \
    mv guetzli_linux_x86-64 ./guetzli

FROM ubuntu:22.04 as final

# Geography
ENV TZ=Europe/Rome \
    DEBIAN_FRONTEND=noninteractive \
    DATA_FOLDER=/app/data \
    GUETZLI=/bin/guetzli

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Luatex installation
RUN apt-get update && \
    apt-get install -y texlive-full

# Python installation
RUN apt install software-properties-common -y && \
    add-apt-repository ppa:deadsnakes/ppa -y && \
    apt-get update -y && \
    apt install python3.11 python3-pip -y && \
    python3.11 -m pip install poetry && \
    apt-get install -y git npm fontforge zip unzip curl wget && \
    npm install -g sass

COPY --from=guetzli /app/guetzli /bin/guetzli

WORKDIR /app

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf ./aws && \
    rm -rf ./awscliv2.zip

RUN apt-get install -y openjdk-8-jdk

RUN wget https://github.com/w3c/epubcheck/releases/download/v5.1.0/epubcheck-5.1.0.zip && \
    unzip epubcheck-5.1.0.zip && \
    mkdir /epubcheck && \
    mv epubcheck-5.1.0 /epubcheck && \
    rm -rf epubcheck-5.1.0 && \
    rm -rf epubcheck-5.1.0.zip && \
    echo "#!/bin/env bash\njava -jar /epubcheck/epubcheck-5.1.0/epubcheck.jar \$@" > /bin/epubcheck && \
    chmod +x /bin/epubcheck

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

ENV NVM_DIR=/root/.nvm \
    NODE_VERSION=19.3.0
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"

RUN npm install -g gatsby-cli

COPY . .

RUN mv install-font.sh /bin/install-font && \
    chmod +x /bin/install-font && \
    mv pip-gz.sh /bin/pip-gz && \
    chmod +x /bin/pip-gz && \
    mv ffont.sh /bin/ffont && \
    chmod +x /bin/ffont &&\
    echo "#!/bin/env bash\npython3.11 -O \$@" > /bin/python && \
    chmod +x /bin/python
