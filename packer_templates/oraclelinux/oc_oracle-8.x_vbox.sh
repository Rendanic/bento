packer build -only=virtualbox-iso \
             -var="disk_size=16384" \
             -var="ks_path=8/ks_oc.cfg" \
             "$1"

echo "possible import with:"
echo "vagrant box add --name Rendanic/oraclelinux-8.x file://../../builds/oracle-8.1.virtualbox.box"