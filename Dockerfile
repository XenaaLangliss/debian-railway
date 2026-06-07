FROM debian:bookworm-slim

ARG XRAY_VERSION=1.8.24

RUN apt-get update && \
    apt-get install -y ca-certificates curl unzip && \
    curl -fsSL "https://github.com/XTLS/Xray-core/releases/download/v${XRAY_VERSION}/Xray-linux-64.zip" -o /tmp/xray.zip && \
    unzip -q /tmp/xray.zip -d /tmp/xray && \
    install -m 0755 /tmp/xray/xray /usr/local/bin/xray && \
    rm -rf /tmp/xray /tmp/xray.zip /var/lib/apt/lists/*

COPY start.sh /usr/local/bin/start-xray
RUN chmod +x /usr/local/bin/start-xray

EXPOSE $PORT

CMD ["/usr/local/bin/start-xray"]
