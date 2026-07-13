FROM debian:bookworm-slim AS builder


WORKDIR /app

COPY linux-sysmonitor/ . 
RUN chmod +x health-check.sh

FROM debian:bookworm-slim

WORKDIR /app

COPY --from=builder /app/health-check.sh .

RUN apt-get update && apt-get install -y \
    procps \
    iputils-ping \
    iproute2 \
    bash && rm -rf /var/lib/apt/lists/*
 