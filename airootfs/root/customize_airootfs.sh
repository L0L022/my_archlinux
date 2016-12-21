#!/bin/bash

set -e -u

usermod -s /usr/bin/zsh root
#root ne doit pas etre utilise
#cp -aT /etc/skel/ /root/
chmod 700 /root

sed -i 's/#\(PermitRootLogin \).\+/\1yes/' /etc/ssh/sshd_config
sed -i "s/#Server/Server/g" /etc/pacman.d/mirrorlist
sed -i 's/#\(Storage=\)auto/\1volatile/' /etc/systemd/journald.conf

sed -i 's/#\(HandleSuspendKey=\)suspend/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleHibernateKey=\)hibernate/\1ignore/' /etc/systemd/logind.conf
sed -i 's/#\(HandleLidSwitch=\)suspend/\1ignore/' /etc/systemd/logind.conf

#echo "archlinux-loic" > /etc/hostname

#echo "KEYMAP=fr-latin9" >> /etc/vconsole.conf
#echo "FONT=lat9w-16" >> /etc/vconsole.conf

#echo "LANG=fr_FR.UTF-8" >> /etc/locale.conf
#echo "LC_COLLATE=C" >> /etc/locale.conf

sed -i 's/#\(en_US\.UTF-8\)/\1/' /etc/locale.gen
sed -i 's/#\(fr_FR\.UTF-8\)/\1/' /etc/locale.gen
locale-gen

ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime

if [ $(uname -m) == 'x86_64' ]; then
systemctl set-default graphical.target

systemctl enable NetworkManager.service
systemctl enable lightdm.service
systemctl enable accounts-daemon.service
systemctl enable ntpd.service
systemctl enable cronie.service

#groupadd -r autologin
#useradd -m -p "" -g users -G "wheel,autologin" -c "Loïc" -s /bin/zsh loic

sed -i 's/# \(%wheel ALL=(ALL) NOPASSWD: ALL\)/\1/' /etc/sudoers

sed -i 's/#\(greeter-setup-script=\)/\1\/usr\/bin\/numlockx\ on/' /etc/lightdm/lightdm.conf
sed -i 's/#\(autologin-user=\)/\1loic/' /etc/lightdm/lightdm.conf
sed -i 's/#\(autologin-user-timeout=0\)/\1/' /etc/lightdm/lightdm.conf
sed -i 's/#\(pam-service=lightdm\)/\1/' /etc/lightdm/lightdm.conf
sed -i 's/#\(pam-autologin-service=lightdm-autologin\)/\1/' /etc/lightdm/lightdm.conf

sed -i 's/#\(background=\)/\1\/usr\/share\/backgrounds\/mate\/desktop\/Ubuntu-Mate-Warm-no-logo.png/' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/#\(theme-name=\)/\1Numix/' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/#\(icon-theme-name=\)/\1matefaenzagray/' /etc/lightdm/lightdm-gtk-greeter.conf
sed -i 's/#\(font-name=\)/\1Noto\ Sans\ 10/' /etc/lightdm/lightdm-gtk-greeter.conf

#use script in /root instead
#export ATOM_HOME=/etc/skel/.atom
#apm install --packages-file /root/atom-packages.txt

mkdir /etc/skel/Desktop/
cp /usr/share/applications/{mate-terminal,firefox,atom}.desktop /etc/skel/Desktop/
chmod u+x /etc/skel/Desktop/{mate-terminal,firefox,atom}.desktop

groupadd -r autologin
useradd -m -p "" -g users -G "wheel,autologin" -c "Loïc" -s /bin/zsh loic

else
systemctl set-default multi-user.target
fi

systemctl enable pacman-init.service choose-mirror.service
