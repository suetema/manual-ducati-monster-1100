FROM nginxinc/nginx-unprivileged:1.29-alpine

COPY docker/default.conf /etc/nginx/conf.d/default.conf
COPY docker/index.html /usr/share/nginx/html/index.html
COPY site/content /usr/share/nginx/html
COPY Ducati_Monster_1100_Workshop_Manual.pdf /usr/share/nginx/html/Ducati_Monster_1100_Workshop_Manual.pdf

HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://127.0.0.1:8080/ >/dev/null || exit 1
