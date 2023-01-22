#!/usr/bin/env bash

uninstall_bloat() {
  echo "Uninstalling some bloats"
  sudo apt purge budgie-rotation-lock-applet budgie-keyboard-autoswitch-applet budgie-hotcorners-applet aisleriot rhythmbox magnus gnome-software gnome-mahjongg deja-dup cheese gnome-mines gnome-sudoku gnome-font-viewer geary gthumb gnome-maps thunderbird thunderbird-gnome-support transmission-gtk transmission-common -y
  sudo apt autoremove -y
}

uninstall_snap() {
  echo "Uninstalling snap"
  sudo snap remove --purge firefox
  sudo snap remove --purge ubuntu-budgie-welcome
  sudo snap remove --purge gtk-common-themes
  sudo snap remove --purge gnome-3-38-2004
  sudo snap remove --purge gtk-common-themes
  sudo snap remove --purge snapd-desktop-integration
  sudo snap remove --purge bare
  sudo snap remove --purge core20
  sudo snap remove --purge snapd
  sudo systemctl disable snapd.service
  sudo systemctl disable snapd.socket
  sudo systemctl disable snapd.seeded.service
  sudo apt remove --autoremove snapd -y
  sudo rm -rf /var/cache/snapd/
  sudo rm -fr ~/snap
  sudo apt-mark hold snapd
  sudo touch /etc/apt/preferences.d/nosnap.pref
  echo "Package: snapd" | sudo tee -a /etc/apt/preferences.d/nosnap.pref
  echo "Pin: release a=*" | sudo tee -a /etc/apt/preferences.d/nosnap.pref
  echo "Pin-Priority: -10" | sudo tee -a /etc/apt/preferences.d/nosnap.pref
  sudo apt update
}

add_ppa() {
  echo "Adding PPAs"
  sudo apt update
  sudo add-apt-repository ppa:git-core/ppa -y
  sudo add-apt-repository ppa:ondrej/nginx -y
  sudo add-apt-repository ppa:ondrej/php -y
  sudo add-apt-repository ppa:libreoffice/ppa -y
  sudo add-apt-repository ppa:deluge-team/stable -y
  sudo add-apt-repository ppa:agornostal/ulauncher -y
  sudo add-apt-repository ppa:papirus/papirus -y
  sudo add-apt-repository ppa:font-manager/staging -y
  sudo add-apt-repository ppa:jonathonf/vim -y
  sudo add-apt-repository ppa:ubuntubudgie/backports -y
  sudo add-apt-repository ppa:helkaluin/webp-pixbuf-loader -y
  sudo add-apt-repository ppa:mozillateam/ppa -y
  sudo add-apt-repository ppa:linuxgndu/sqlitebrowser -y
}

update_and_upgrade() {
  echo "Updating repositories"
  sudo apt update
  sudo apt upgrade -y
}

install_budgie_applets() {
  echo "Adding budgie_applets"
  sudo apt install budgie-applications-menu-applet budgie-sysmonitor-applet budgie-brightness-controller-applet budgie-clipboard-applet budgie-calendar-applet -y
}

install_dev_apps() {
  echo "Adding dev_apps"
  sudo apt install traceroute build-essential openssh-server curl git git-extras clang-format-14 libgconf-2-4 libffi-dev libncurses5-dev default-jre default-jdk vim python3-dev graphviz libgraphviz-dev pkg-config android-tools-adb android-tools-fastboot sqlitebrowser -y

  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null && sudo apt update && sudo apt install gh -y

}

install_utility_apps() {
  echo "Adding utility_apps"
  sudo apt install libfuse2 nnn ncdu duf bat webp-pixbuf-loader tlp tlp-rdw ulauncher nvme-cli iotop btop neofetch stacer nomacs gpick p7zip-full mlocate pavucontrol flatpak gedit-plugin-text-size muon gdebi -y
}

install_other_apps() {
  sudo apt install papirus-icon-theme font-manager deluge fonts-cascadia-code -y
}

install_missing_apps() {
  sudo apt install ffmpeg drawing thermald ppa-purge gnome-logs gedit gedit-common gnome-system-monitor mpv celluloid mousetweaks zsync printer-driver-gutenprint baobab evince evince-common file-roller gnome-disk-utility folder-color folder-color-common attr fonts-noto-color-emoji fonts-opensymbol fonts-cascadia-code -y
}

install_node_js() {
  echo "Installing node"
  sudo curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash
  source ~/.nvm/nvm.sh
  source ~/.profile
  source ~/.bashrc
  nvm install --lts
  npm install --location=global npm@latest
  npm install goinside --location=global
  npm config set fund false --location=global
}

python_setup() {

  sudo apt-get install python-is-python3 python3-pip python3-venv zlib1g-dev libffi-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev liblzma-dev python3-tk tk-dev -y
  curl https://pyenv.run | bash
  echo 'export PATH=$PATH:"$HOME/.local/bin"' >>~/.bashrc
  echo 'export PYENV_ROOT="$HOME/.pyenv"' >>~/.bashrc
  echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >>~/.bashrc
  echo 'eval "$(pyenv init -)"' >>~/.bashrc
  echo 'eval "$(pyenv virtualenv-init -)"' >>~/.bashrc
  source ~/.bashrc
}

venv_automate() {

  echo 'venv auto active'
  cat <<-'EOF' | tee -a "$HOME"/.bashrc >/dev/null
VENV_DIR_HIDDEN=".venv"
VENV_DIR_NORMAL="venv"

if [ -d "${VENV_DIR_HIDDEN}" ]; then
    source .venv/bin/activate

elif [ -d "${VENV_DIR_NORMAL}" ]; then
    source venv/bin/activate
fi
	EOF
}

oh_my_posh_setup() {
  echo "Installing Oh My Posh"
  sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
  sudo chmod +x /usr/local/bin/oh-my-posh
  mkdir ~/.poshthemes
  curl -O --output-dir ~/.poshthemes https://raw.githubusercontent.com/redwan-hossain/dot_files/main/misc/avid.omp.json
  echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/avid.omp.json)"' >>~/.bashrc
}

install_docker() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker "$USER"
}

install_docker_ctop() {
  echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ bullseye main" | sudo tee /etc/apt/sources.list.d/azlux.list
  sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg https://azlux.fr/repo.gpg
  sudo apt update
  sudo apt install docker-ctop -y
}

install_vs_code() {
  echo "Installing VS Code"
  sudo apt install software-properties-common apt-transport-https wget -y
  wget -O vscode.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
  sudo dpkg -i ./vscode.deb
  sudo apt -f install
}

install_google_chrome() {
  echo "Installing Google chrome"
  wget -O chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
  sudo dpkg -i ./chrome.deb
  sudo apt -f install
}

install_firefox() {

  echo '
Package: *
Pin: release o=LP-PPA-mozillateam
Pin-Priority: 1001
' | sudo tee /etc/apt/preferences.d/mozilla-firefox

  echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox

  sudo apt install firefox -v

}

install_zoom() {
  echo "Installing Zoom"
  wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
  sudo dpkg -i ./zoom.deb
  sudo apt -f install
}

install_ngrok() {
  echo "Installing Ngrok"
  sudo wget -O ~/ngrok.tgz https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
  sudo tar xvzf ~/ngrok.tgz -C /usr/local/bin
  sudo rm ~/ngrok.tgz
}

misc_tweak() {
  gsettings set org.gnome.desktop.peripherals.touchpad click-method areas
  sudo flatpak override --filesystem="$HOME"/.themes

  sudo curl -O --output-dir /etc/fonts/conf.d https://raw.githubusercontent.com/redwan-hossain/dot_files/main/misc/76-bangla.conf
  echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"' >>~/.profile
  echo 'alias src="source ~/.bashrc"' >>~/.bashrc

  sudo systemctl enable tlp.service
  sudo tlp start
  sudo nvme smart-log /dev/nvme0n1 | grep "percentage_used"

}

uninstall_bloat
uninstall_snap
add_ppa
update_and_upgrade
install_budgie_applets
install_dev_apps
install_utility_apps
install_other_apps
#install_missing_apps
oh_my_posh_setup
install_node_js
python_setup
venv_automate
install_docker
install_docker_ctop
install_google_chrome
install_firefox
install_vs_code
install_ngrok
install_zoom
misc_tweak

exit
