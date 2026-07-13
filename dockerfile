FROM debian:bookworm-slim AS builder


WORKDIR /app

COPY linux-sysmonitor/ . 
RUN chmod +x health-check.sh