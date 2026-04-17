#!/bin/bash
set -e

# Instalar Brave
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update && sudo apt install -y brave-browser

# Crear wrapper X11 + WebGL
sudo mv /usr/bin/brave-browser-stable /usr/bin/brave-browser-stable.real
sudo tee /usr/bin/brave-browser-stable << 'WRAPPER'
#!/bin/bash
export OZONE_PLATFORM=x11
exec /usr/bin/brave-browser-stable.real --ozone-platform=x11 --enable-webgl --ignore-gpu-blocklist "$@"
WRAPPER
sudo chmod +x /usr/bin/brave-browser-stable

# Hook apt para restaurar wrapper tras actualizaciones
sudo tee /etc/apt/apt.conf.d/99-brave-wrapper << 'HOOK'
DPkg::Post-Invoke {
  "if [ -f /usr/bin/brave-browser-stable ] && ! grep -q 'brave-browser-stable.real' /usr/bin/brave-browser-stable; then mv /usr/bin/brave-browser-stable /usr/bin/brave-browser-stable.real && printf '#!/bin/bash\nexport OZONE_PLATFORM=x11\nexec /usr/bin/brave-browser-stable.real --ozone-platform=x11 --enable-webgl --ignore-gpu-blocklist \"$@\"\n' > /usr/bin/brave-browser-stable && chmod +x /usr/bin/brave-browser-stable; fi";
};
HOOK

echo "Brave instalado con X11 + WebGL"
