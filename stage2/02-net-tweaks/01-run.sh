#!/bin/bash -e

install -v -d					"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d"
install -v -m 644 files/wait.conf		"${ROOTFS_DIR}/etc/systemd/system/dhcpcd.service.d/"

install -v -d					"${ROOTFS_DIR}/etc/wpa_supplicant"
install -v -m 600 files/wpa_supplicant.conf	"${ROOTFS_DIR}/etc/wpa_supplicant/"

if [ -v WPA_COUNTRY ]; then
	echo "country=${WPA_COUNTRY}" >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf"
fi

if [ -v WPA_ESSID ] && [ -v WPA_PASSWORD ]; then
on_chroot <<EOF
set -o pipefail
wpa_passphrase "${WPA_ESSID}" "${WPA_PASSWORD}" | tee -a "/etc/wpa_supplicant/wpa_supplicant.conf"
EOF
elif [ -v WPA_ESSID ]; then
cat >> "${ROOTFS_DIR}/etc/wpa_supplicant/wpa_supplicant.conf" << EOL

network={
	ssid="${WPA_ESSID}"
	key_mgmt=NONE
}
EOL
fi

# Disable wifi on 5GHz models
mkdir -p "${ROOTFS_DIR}/var/lib/systemd/rfkill/"
echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-3f300000.mmc:wlan"
echo 1 > "${ROOTFS_DIR}/var/lib/systemd/rfkill/platform-fe300000.mmc:wlan"

on_chroot <<EOF
apt-get update
#apt-get install -y --reinstall ca-certificates
#apt install -y apt-transport-https ca-certificates curl software-properties-common
#update-ca-certificates
#add-apt-repository "deb [arch=armhf] https://download.docker.com/linux/debian  $(lsb_release -cs) stable"
#apt-get update
#apt-get install docker-ce docker-ce-cli containerd.io
usermod ${FIRST_USER_NAME} -aG docker
EOF
