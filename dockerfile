# NOTE:
# linux-sysmonitor is a Bash-based application, so there are no compiled build artifacts.
# This multi-stage build demonstrates the builder/runtime pattern. The builder prepares
# the application, while the runtime contains only the files and dependencies required
# to execute the script.

FROM debian:12.11-slim AS builder


WORKDIR /app

COPY linux-sysmonitor/ . 
RUN chmod +x health-check.sh

FROM debian:12.11-slim

WORKDIR /app

COPY --from=builder /app/health-check.sh .

RUN apt-get update && \
    apt-get install -y --no-install-recommends\
    procps \
    iputils-ping \
    iproute2 \
    bash && rm -rf /var/lib/apt/lists/*

RUN useradd --system \
    --create-home \
    --shell /var/sbin/nologin \
    appuser && \
    chown -R appuser:appuser /app
    
ENTRYPOINT [ "./health-check.sh" ]

