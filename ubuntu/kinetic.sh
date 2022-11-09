#!/usr/bin/env bash

add_ppa() {
  echo "Adding PPAs"
  sudo apt update
  sudo add-apt-repository ppa:git-core/ppa -y
  sudo add-apt-repository ppa:libreoffice/ppa -y
  sudo add-apt-repository ppa:deluge-team/stable -y
  sudo add-apt-repository ppa:papirus/papirus -y
  sudo add-apt-repository ppa:ubuntubudgie/backports -y
  sudo add-apt-repository ppa:mozillateam/ppa -y
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
  sudo apt install python-is-python3 python3-pip python3-venv codeblocks codeblocks-contrib build-essential openssh-server curl git git-extras clang-format-14 libgconf-2-4 libffi-dev libncurses5-dev default-jre default-jdk vim graphviz android-tools-adb android-tools-fastboot -y

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null && sudo apt update && sudo apt install gh -y

}

install_utility_apps() {
 echo "Adding utility_apps"
 sudo apt install libfuse2 gnome-calculator gnome-system-monitor nnn ncdu duf bat webp-pixbuf-loader tlp tlp-rdw nvme-cli iotop btop neofetch stacer nomacs gpick p7zip-full mlocate pavucontrol flatpak gedit-plugin-text-size muon qapt-deb-installer -y
}

install_other_apps() {
  sudo apt install papirus-icon-theme font-manager deluge -y
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

install_oh_my_posh() {
  echo "Installing Oh My Posh"
  sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
  sudo chmod +x /usr/local/bin/oh-my-posh
}

install_docker() {
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  sudo usermod -aG docker "$USER"
}

install_python_packages() {
  pip3 install autopep8 pytube pip-review clint yt-dlp pipreqs pyinstaller pygithub requests flake8 black static-ffmpeg types-requests pytest mypy httpie
  # /usr/bin/python3.11 -m pip install -U 
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

install_zoom() {
  echo "Installing Zoom"
  wget -O zoom.deb https://zoom.us/client/latest/zoom_amd64.deb
  sudo apt install libegl1-mesa libgl1-mesa-glx libxcb-image0 libxcb-keysyms1 libxcb-xinerama0 libxcb-xtest0 -y
  sudo dpkg -i ./zoom.deb
  sudo apt -f install -y
}

install_ngrok() {
  echo "Installing Ngrok"
  sudo wget -O ~/ngrok.tgz https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
  sudo tar xvzf ~/ngrok.tgz -C /usr/local/bin
  sudo rm ~/ngrok.tgz
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


uninstall_bloat() {
  echo "Uninstalling some bloats"
  sudo sudo apt purge gpodder goodvibes guvcview parole lollypop gnome-mahjongg gnome-mines gnome-sudoku gnome-2048 gthumb aisleriot transmission-gtk transmission-common mate-system-monitor mate-system-monitor-common mate-calc mate-calc-common thunderbird thunderbird-gnome-support deja-dup gnome-software -y
  sudo apt autoremove -y
}

misc_tweak() {
  # sudo cp 76-bangla.conf /etc/fonts/conf.d
  # echo 'export PATH="$PATH:/usr/bin/python3"' >> ~/.bashrc

  echo 'export PATH=$PATH:"$HOME/.local/bin"' >> ~/.bashrc


  echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"' >> ~/.profile
  gsettings set org.gnome.desktop.peripherals.touchpad click-method areas
  sudo flatpak override --filesystem="$HOME"/.themes
  sudo systemctl enable tlp.service
  sudo tlp start
  sudo nvme smart-log /dev/nvme0n1 | grep "percentage_used"
}

add_ppa
update_and_upgrade
install_budgie_applets
install_dev_apps
install_utility_apps
install_other_apps
install_oh_my_posh
install_node_js
install_docker
install_docker_ctop
#install_python_packages
install_google_chrome
install_vs_code
install_ngrok
install_zoom
uninstall_bloat
uninstall_snap
misc_tweak

# sudo nano /usr/share/im-config/data/21_ibus.rc
# sudo apt install plasma-theme-oxygen -y

exit
