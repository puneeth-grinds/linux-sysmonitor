# NOTE:
# linux-sysmonitor is a Bash application, so there are no compiled build artifacts.
# This multi-stage build demonstrates the builder/runtime pattern.
# For compiled applications (e.g., Go), the builder would compile the application,
# and the runtime would copy only the compiled binary, resulting in a much smaller image.

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
ENTRYPOINT [ "./health-check.sh" ]

