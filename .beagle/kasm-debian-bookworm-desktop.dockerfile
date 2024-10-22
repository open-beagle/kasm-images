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
                /ubuntu/install/vs_kasm-user/install_vs_kasm-user.sh \
                /ubuntu/install/remmina/install_remmina.sh \
                /ubuntu/install/only_office/install_only_office.sh \
                /ubuntu/install/signal/install_signal.sh \
                /ubuntu/install/gimp/install_gimp.sh \
                /ubuntu/install/obs/install_obs.sh \
                /ubuntu/install/ansible/install_ansible.sh \
                /ubuntu/install/terraform/install_terraform.sh \
                /ubuntu/install/gamepad_utils/install_gamepad_utils.sh \
                /ubuntu/install/cleanup/cleanup.sh"

# Copy install scripts
COPY ./src/ $INST_DIR

# china mirror
COPY etc/apt/sources.list.d/debian.sources /etc/apt/sources.list.d/debian.sources

# fix noVNC bug
RUN sed -i "s/UI\.initSetting('path', 'websockify');/UI.initSetting('path', (window.location.pathname \+ 'websockify').substring\(1\));/g" /usr/share/kasmvnc/www/dist/main.bundle.js && \
  echo "kasm-user ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers

# Run installations
RUN \
  for SCRIPT in $INST_SCRIPTS; do \
  bash ${INST_DIR}${SCRIPT} || exit 1; \
  done && \
  $STARTUPDIR/set_user_permission.sh $HOME && \
  rm -f /etc/X11/xinit/Xclients && \
  chown 1000:0 $HOME && \
  mkdir -p /home/kasm-user && \
  chown -R 1000:0 /home/kasm-user && \
  rm -Rf ${INST_DIR}

# Userspace Runtime
ENV HOME /home/kasm-user
WORKDIR $HOME
USER 1000

CMD ["--tail-log"]

