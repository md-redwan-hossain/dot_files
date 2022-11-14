#!/usr/bin/env bash

system_update() {
    sudo pacman --noconfirm -Syu
}


utility_package_setup() {
    sudo pacman -S --noconfirm --needed spectacle telegram-desktop discord nomacs obs-studio warpinator okular ffmpeg unzip zip p7zip vlc tlp tlp-rdw bluez-utils bluez firefox pavucontrol flatpak gnome-calculator nnn ncdu bat duf btop filelight cronie pacman-contrib
}

misc_package_setup() {
    sudo pacman -S --noconfirm --needed papirus-icon-theme ttf-ubuntu-font-family languagetool fuse-exfat exfat-utils ntfs-3g
}

dev_package_setup() {
    sudo pacman -S --noconfirm --needed wireguard-tools openresolv git github-cli jdk-openjdk nethogs gpick which curl wget android-tools

    curl -O --output-dir "$HOME" https://raw.githubusercontent.com/redwan-hossain/dot_files/main/arch/lazypac.py
    echo 'alias lpac="python $HOME/lazypac.py"' >>~/.bashrc
    source ~/.bashrc

}



python_setup() {
    sudo pacman -S --noconfirm --needed python python-pip
    echo 'export PATH=$PATH:"$HOME/.local/bin"' >>~/.bashrc
    source ~/.bashrc
    pip install python-lsp-server black rope pylint
    curl -O --output-dir "$HOME" https://raw.githubusercontent.com/redwan-hossain/dot_files/main/misc/settings.json
}


printer_setup() {
    sudo pacman -S --noconfirm --needed cups print-manager system-config-printer
    sudo systemctl start cups.service
    sudo systemctl enable cups.service
}


docker_setup() {
    sudo pacman -S --noconfirm --needed docker docker-compose ctop
    sudo systemctl start docker.service
    sudo systemctl enable docker.service
    sudo usermod -aG docker "$USER"
}

node_js_setup() {
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

oh_my_posh_setup() {
    echo "Installing Oh My Posh"
    sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
    sudo chmod +x /usr/local/bin/oh-my-posh
    mkdir ~/.poshthemes
    curl -O --output-dir ~/.poshthemes https://raw.githubusercontent.com/redwan-hossain/dot_files/main/misc/avid.omp.json
    echo 'eval "$(oh-my-posh init bash --config ~/.poshthemes/avid.omp.json)"' >>~/.bashrc
}

ngrok_setup() {
    echo "Installing Ngrok"
    sudo wget -O ~/ngrok.tgz https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.tgz
    sudo tar xvzf ~/ngrok.tgz -C /usr/local/bin
    sudo rm ~/ngrok.tgz
}




ssh_fix(){

	echo 'Setting SSH Key persistence fix'
	cat <<-'EOF' | tee -a "$HOME"/.bashrc >/dev/null

SSH_ENV="$HOME"/.ssh/environment

# start the ssh-agent
function start_agent {
    # spawn ssh-agent
    /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"

    chmod 600 "${SSH_ENV}"
    . "${SSH_ENV}" > /dev/null
    /usr/bin/ssh-add
}

if [ -f "${SSH_ENV}" ]; then
    . "${SSH_ENV}" > /dev/null
    ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
        start_agent;
    }
else
    start_agent;
fi
	EOF
}



service_enabler() {
    sudo systemctl start fstrim.timer
    sudo systemctl enable fstrim.timer

    sudo systemctl start cronie.service
    sudo systemctl enable cronie.service

    sudo systemctl start bluetooth.service
    sudo systemctl enable bluetooth.service

    sudo systemctl start tlp.service
    sudo systemctl enable tlp.service

    sudo systemctl start NetworkManager-dispatcher.service
    sudo systemctl enable NetworkManager-dispatcher.service

    sudo systemctl mask systemd-rfkill.service systemd-rfkill.socket
}

font_tweaks() {
    sudo pacman -S --noconfirm --needed noto-fonts

    FILE="$HOME"/.config/fontconfig/fonts.conf

    if [[ -f "$FILE" ]]; then
    echo "$FILE exists"
    cp "$HOME"/.config/fontconfig/fonts.conf "$HOME"/.config/fontconfig/fonts_bak.conf
    rm "$HOME"/.config/fontconfig/fonts.conf
    echo "$FILE is backuped and removed"
    fi

    curl -O --output-dir "$HOME"/.config/fontconfig https://raw.githubusercontent.com/redwan-hossain/dot_files/main/misc/fonts.conf

    sudo curl -O --output-dir /etc/fonts/conf.d https://raw.githubusercontent.com/redwan-hossain/dot_files/main/misc/76-bangla.conf

    echo 'export FREETYPE_PROPERTIES="truetype:interpreter-version=40 cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"' >>~/.profile
    source ~/.profile
    source ~/.bashrc
}

disable_watchdog() {

    sudo touch /etc/modprobe.d/watchdog.conf

    echo "blacklist iTCO_wdt" | sudo tee -a /etc/modprobe.d/watchdog.conf
    echo "blacklist iTCO_vendor_support" | sudo tee -a /etc/modprobe.d/watchdog.conf

    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT/#GRUB_CMDLINE_LINUX_DEFAULT/gI' /etc/default/grub
    echo 'GRUB_CMDLINE_LINUX_DEFAULT="loglevel=3 quiet nowatchdog nmi_watchdog=0"' | sudo tee -a /etc/default/grub
    echo 'GRUB_DISABLE_SUBMENU=y' | sudo tee -a /etc/default/grub
    echo 'GRUB_DEFAULT=saved' | sudo tee -a /etc/default/grub
    echo 'GRUB_SAVEDEFAULT=true' | sudo tee -a /etc/default/grub
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

yay_setup() {
    sudo pacman -S --noconfirm --needed base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay && makepkg -si
}

system_update
utility_package_setup
misc_package_setup
python_setup
dev_package_setup
oh_my_posh_setup
printer_setup
docker_setup
node_js_setup
ngrok_setup
ssh_fix
font_tweaks
service_enabler
disable_watchdog
yay_setup
