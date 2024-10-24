#/bin/bash

export HOME=/home/kasm-default-profile
export STARTUPDIR=/dockerstartup
export DEBIAN_FRONTEND=noninteractive
export SKIP_CLEAN=true
export KASM_RX_HOME=/dockerstartup/kasmrx
export DONT_PROMPT_WSL_INSTALL=No_Prompt_please
export INST_DIR=/dockerstartup/install

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

cp -r ./src/* $INST_DIR

cd $HOME

for SCRIPT in $INST_SCRIPTS; do
  bash ${INST_DIR}${SCRIPT} || exit 1
done

$STARTUPDIR/set_user_permission.sh $HOME

rm -f /etc/X11/xinit/Xclients

chown 1000:0 $HOME
mkdir -p /home/code
chown -R 1000:0 /home/code
