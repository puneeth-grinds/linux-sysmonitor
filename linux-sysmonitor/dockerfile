FROM debian:bookworm-slim


WORKDIR /app

RUN apt-get update && apt-get install -y \
    procps \
    iputils-ping \
    iproute2 \
    bash && rm -rf /var/lib/apt/lists/*

COPY . . 
RUN chmod +x health-check.sh
ENTRYPOINT [ "./health-check.sh" ]