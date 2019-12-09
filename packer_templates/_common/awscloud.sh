#!/bin/bash -eux

case "$PACKER_BUILDER_TYPE" in
virtualbox-iso)
. /etc/os-release
OSVERSION=$(echo $VERSION | cut -d"." -f1)

yum-config-manager --enable ol${OSVERSION}_developer_EPEL > /dev/null

# switch to RHCK Kernel
# not needed for UEK5 atm!
#grub2-set-default "Oracle Linux Server 7.5, with Linux 3.10.0-862.3.3.el7.x86_64"

# inscall cloudinit
yum install -y cloud-init cloud-utils-growpart dracut-modules-growroot

cat >/etc/cloud/cloud.cfg <<-'EOF'
users:
 - default
 - name: vagrant
   shell: /bin/false
   lock_passwd: true
disable_root: 1
ssh_pwauth:   0
locale_configfile: /etc/sysconfig/i18n
mount_default_fields: [~, ~, 'auto', 'defaults,nofail', '0', '2']
resize_rootfs_tmp: /dev
ssh_deletekeys:   0
ssh_genkeytypes:  ~
syslog_fix_perms: ~
cloud_init_modules:
 - bootcmd
 - write-files
 - resizefs
 - set_hostname
 - update_hostname
 - update_etc_hosts
 - rsyslog
 - users-groups
 - ssh
 - growpart
cloud_config_modules:
 - mounts
 - locale
 - set-passwords
 - timezone
cloud_final_modules:
 - scripts-per-once
 - scripts-per-boot
 - scripts-per-instance
 - scripts-user
 - ssh-authkey-fingerprints
 - keys-to-console
 - final-message
 - runcmd
system_info:
  distro: rhel
  default_user:
    name: ec2-user
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
  paths:
    cloud_dir: /var/lib/cloud
    templates_dir: /etc/cloud/templates
  ssh_svcname: sshd
growpart:
  mode: growpart
  devices: ['/dev/xvda2']
  ignore_growroot_disabled: false
runcmd:
  - [ pvresize /dev/xvda2 ]
EOF
esac