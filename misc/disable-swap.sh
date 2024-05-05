sudo swapoff -a                 # Disable all devices marked as swap in /etc/fstab
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab   # Comment the correct mounting point
sudo systemctl mask swap.target               # Completely disabled
