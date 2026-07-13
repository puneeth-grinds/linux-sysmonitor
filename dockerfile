FROM debian:bookworm-slim


WORKDIR /app

COPY linux-sysmonitor/ . 
RUN chmod +x health-check.sh