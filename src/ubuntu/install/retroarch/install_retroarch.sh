#!/usr/bin/env bash
set -ex

# Install Retroarch
SCRIPT_PATH="$( cd "$(dirname "$0")" ; pwd -P )"
add-apt-repository -y ppa:libretro/stable
sed -i 's/ppa.launchpadcontent.net/launchpad.proxy.ustclug.org/g' /etc/apt/sources.list /etc/apt/sources.list.d/*.list
apt-get update
apt-get install -y retroarch unzip retroarch-assets libretro-core-info

# Deskto icon
cp /usr/share/applications/com.libretro.RetroArch.desktop $HOME/Desktop/
chmod +x $HOME/Desktop/com.libretro.RetroArch.desktop

# Config setup
mkdir -p $HOME/.config/retroarch/cores
cp $SCRIPT_PATH/retroarch.cfg $HOME/.config/retroarch/retroarch.cfg

# Wrap with VGL
mv /usr/bin/retroarch /usr/bin/retroarch-real
cat >/usr/bin/retroarch <<EOL
#!/usr/bin/env bash
if [ -f /opt/VirtualGL/bin/vglrun ] && [ ! -z "\${KASM_EGL_CARD}" ] && [ ! -z "\${KASM_RENDERD}" ] && [ -O "\${KASM_RENDERD}" ] && [ -O "\${KASM_EGL_CARD}" ] ; then
    echo "Starting Retroarch with GPU Acceleration on EGL device \${KASM_EGL_CARD}"
    vglrun -d "\${KASM_EGL_CARD}" /usr/bin/retroarch-real "\$@"
else
    echo "Starting Retroarch"
    /usr/bin/retroarch-real "\$@"
fi
EOL
chmod +x /usr/bin/retroarch

cat >/usr/bin/desktop_ready <<EOL
#!/usr/bin/env bash
until pids=\$(pidof Thunar); do sleep .5; done
EOL
chmod +x /usr/bin/desktop_ready

# Cleanup
if [ -z ${SKIP_CLEAN+x} ]; then
  apt-get autoclean
  rm -rf \
    /var/lib/apt/lists/* \
    /var/tmp/*
fi

# Cleanup for app layer
chown -R 1000:0 $HOME
find /usr/share/ -name "icon-theme.cache" -exec rm -f {} \;
