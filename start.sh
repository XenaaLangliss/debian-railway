#!/bin/sh
set -eu

PORT="${PORT:-8080}"
VLESS_UUID="${VLESS_UUID:-e4a3b899-0779-47a0-bc4b-724fee4c37af}"
WS_PATH="${WS_PATH:-/vless}"
CONFIG_PATH="${CONFIG_PATH:-/tmp/xray-config.json}"

cat > "$CONFIG_PATH" <<EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "listen": "0.0.0.0",
      "port": ${PORT},
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "${VLESS_UUID}"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "security": "none",
        "wsSettings": {
          "path": "${WS_PATH}"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom",
      "tag": "direct"
    }
  ]
}
EOF

if [ "${XRAY_DRY_RUN:-0}" = "1" ]; then
  cat "$CONFIG_PATH"
  exit 0
fi

exec /usr/local/bin/xray run -config "$CONFIG_PATH"
