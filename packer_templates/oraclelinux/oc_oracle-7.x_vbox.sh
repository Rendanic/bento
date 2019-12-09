packer build -only=virtualbox-iso \
             -var="disk_size=16384" \
             -var="ks_path=7/ks_oc.cfg" \
             "$1"

echo "possible import with:"
echo "vagrant box add --name Rendanic/oraclelinux-7.x file://../../builds/oracle-7.7.virtualbox.box"