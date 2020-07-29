#!/bin/sh
yum -y upgrade
yum -y install epel-release
yum -y install rpmconf
yes | rpmconf -a
yum -y remove python36-rpmconf rpmconf
yum -y install dnf
dnf -y upgrade
dnf -y install http://mirrors.163.com/centos/8/BaseOS/x86_64/os/Packages/centos-repos-8.2-2.2004.0.1.el8.x86_64.rpm http://mirrors.163.com/centos/8/BaseOS/x86_64/os/Packages/centos-release-8.2-2.2004.0.1.el8.x86_64.rpm http://mirrors.163.com/centos/8/BaseOS/x86_64/os/Packages/centos-gpg-keys-8.2-2.2004.0.1.el8.noarch.rpm
mv -f /etc/yum.repos.d/CentOS-Base.repo.rpmnew /etc/yum.repos.d/CentOS-Base.repo
rm -f /etc/yum.repos.d/CentOS-Epel.repo
dnf -y upgrade http://hkg.mirror.rackspace.com/epel/epel-release-latest-8.noarch.rpm
yum -y remove kmod-kvdo
rpm -e `rpm -q kernel-devel`
rpm -e `rpm -q kernel`
rpm -e --nodeps sysvinit-tools
dnf -y remove yum yum-metadata-parser
rm -rf /etc/yum
dnf -y --releasever=8 --allowerasing --setopt=deltarpm=false distro-sync
dnf -y install kernel-core kernel-modules
dnf -y groupupdate "Core" "Minimal Install"
rpm -qa |grep el7 | xargs dnf -y remove
systemctl enable NetworkManager
systemctl disable network
dnf -y remove tuned sssd-common

