# Node/Angular Builder
ARG BASE=kasmweb/core-debian-bookworm:develop
FROM ${BASE}

ARG AUTHOR
ARG VERSION
LABEL maintainer=${AUTHOR} version=${VERSION}

USER root

ENV HOME /home/kasm-default-profile
ENV STARTUPDIR /dockerstartup
WORKDIR $HOME

### Envrionment config
ENV DEBIAN_FRONTEND=noninteractive \
  SKIP_CLEAN=true \
  KASM_RX_HOME=$STARTUPDIR/kasmrx \
  DONT_PROMPT_WSL_INSTALL="No_Prompt_please" \
  INST_DIR=$STARTUPDIR/install \
  INST_SCRIPTS="/ubuntu/install/tools/install_tools_deluxe.sh \
  /ubuntu/install/misc/install_tools.sh \
  /ubuntu/install/chrome/install_chrome.sh \
  /ubuntu/install/chromium/install_chromium.sh \
  /ubuntu/install/sublime_text/install_sublime_text.sh \
  /ubuntu/install/vs_code/install_vs_code.sh \
  /ubuntu/install/remmina/install_remmina.sh \
  /ubuntu/install/only_office/install_only_office.sh \
  /ubuntu/install/gimp/install_gimp.sh \
  /ubuntu/install/obs/install_obs.sh \
  /ubuntu/install/ansible/install_ansible.sh \
  /ubuntu/install/terraform/install_terraform.sh \
  /ubuntu/install/gamepad_utils/install_gamepad_utils.sh \
  /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# Copy logo svc
COPY ./www/dist/images/windvnc.svg /usr/share/kasmvnc/www/dist/images/3e59b876df5d900e0b2b4a945a71f20d.svg
COPY ./www/index.html /usr/share/kasmvnc/www/index.html
COPY ./www/app/images/icons/* /usr/share/kasmvnc/www/app/images/icons/
COPY ./src/common/resources/images/bg_beagle.svg  /usr/share/backgrounds/bg_default.png

# fix noVNC bug
RUN sed -i 's/var PAGE_TITLE = "KasmVNC";/var PAGE_TITLE = "WindVNC";/g' /usr/share/kasmvnc/www/dist/main.bundle.js

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
  bash ${INST_DIR}${SCRIPT} || exit 1; \
  done && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/code && \
  chown -R 1000:0 /home/code && \
  rm -Rf ${INST_DIR}

# Userspace Runtime
ENV HOME /home/code
WORKDIR $HOME
USER 1000

ENV DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

CMD ["--tail-log"]

