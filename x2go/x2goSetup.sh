# Config Vars
_SSHKEY='MY_PUBLIC_SSH_KEY'
_NTPSERVER='time.apple.com'
_DOMAIN='x.example.com'
_DOMAIN_ADMIN='USERNAME@'$_DOMAIN
_HOSTNAME='HOSTNAME'$_DOMAIN

# Setup dircolors
echo "alias ls='ls --color=auto'" >> ~/.bashrc
echo "DIR 01;35'" >> ~/.dircolors

# Setup SELinux
sudo setenforce permissive
sudo sed -i 's/SELINUX=enforcing/SELINUX=permissive/g' /etc/ssh/sshd_config 

# Setup Hostname
sudo hostnamectl set=hostname $_HOSTNAME

# Setup Network
sudo sed -i 's/ONBOOT=no/ONBOOT=yes/g' /etc/sysconfig/network-scripts/ifcfg-eth0
sudo ifup eth0
sudo ip addr show dev eth0

# Setup SSH Key
sudo mkdir ~/.ssh
sudo echo $_SSHKEY >> ~/.ssh/authorized_keys

# Setup Time
sudo yum -y install ntpdate
sudo ntpdate $_NTPSERVER
sudo hwclock --systohc

# Setup Default packages
sudo yum -y install git wget

# Bind to Domain
sudo yum -y install ntpdate realmd oddjob oddjob-mkhomedir sssd samba-common-tools
sudo realm join --user=$_DOMAIN_ADMIN $_DOMAIN

# Update Yum and install epel release and other defaults
sudo yum -y update
sudo yum -y install subscription-manager epel-release
# yum install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install X
sudo groupinstall 'X Window System'

# Install Adobe Flash
sudo rpm -ivh http://linuxdownload.adobe.com/adobe-release/adobe-release-x86_64-1.0-1.noarch.rpm
sudo rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-adobe-linux
sudo yum install flash-plugin nspluginwrapper alsa-plugins-pulseaudio libcurl

# Install Chrome
cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF
sudo yum -y install google-chrome-stable

# Install Firefox
sudo yum -y install Firefox

# Install Fonts
sudo yum -y install libfont* libXfont* xorg-x11-font*

# Install X2go
sudo yum -y install httpd x2goserver x2goserver-xsession x2goserver-fmbindings x2goserver-printing x2goplugin-provider x2goplugin cups-x2go

# Install Xfce
sudo yum -y install xf*

# Install KDE
# sudo groupinstall 'KDE' 'X Window System'

