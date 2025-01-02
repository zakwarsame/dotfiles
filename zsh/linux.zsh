export PATH=$HOME/.local/bin:$PATH

# nodejs
if [ -e /usr/share/nvm/init-nvm.sh ]; then
  source /usr/share/nvm/init-nvm.sh
fi

export MYOS=linux
export LIBVIRT_DEFAULT_URI='qemu:///system'
