#!/usr/bin/env bash
vmname="dev-$(date +%b%y | tr '[:upper:]' '[:lower:]')"
vms=$(multipass list --format json | jq '.list[].name')

echo "Current VMs: $(echo $vms | tr '\n' ' ')"

if echo $vms | grep -q "$vmname" ; then
    echo "Found an existing VM that matches $vmname, Skipping creation of vm"
else
    echo "Creating new VM with name $vmname"

    multipass launch -n $vmname -m 8G -d 100G -c 4 --timeout 600 --cloud-init scott-agent-dev-cloud-config.yaml jammy

    echo "Created VM"
fi

ip=$(multipass list --format json | jq -e --arg vmname $vmname '.list[] | select(.name == $vmname) | .ipv4[] | select(. | startswith("192"))')

if [ $? -eq 0 ] ; then
    echo "Found VM in 'multipass list' - here's an SSH config"
    echo -e "Host $vmname\n    HostName $ip\n    User ubuntu\n    ForwardAgent yes"
else
    echo "Could not find vm and/or its IP, did it work?"
fi
