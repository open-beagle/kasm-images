# Node/Angular Builder
ARG BASE=kasmweb/core-debian-bookworm:develop
FROM ${BASE}

COPY ./www/app/images/icons/wsjj/368_kasm_logo_only_192x192.png /usr/share/kasmvnc/www/app/images/icons/368_kasm_logo_only_192x192.png
COPY ./www/app/images/icons/wsjj/windvnc.svg /usr/share/kasmvnc/www/dist/images/3e59b876df5d900e0b2b4a945a71f20d.svg