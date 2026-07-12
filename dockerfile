FROM debian:bookworm-slim


WORKDIR /app

RUN apt-get update && apt-get install -y \
procps \
iputils-ping \
bash \
&& rm -rf /var/lib/apt/lists/*
