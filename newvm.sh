#!/usr/bin/env bash
if [ -z "$1" ]
then
  echo "No VM name provided. Usage: $0 <vmname>"
  exit 1
fi
vmname=$1
vms=$(limactl list --json | jq --slurp '.[] | .name')

echo "Current VMs: $(echo $vms | tr '\n' ' ')"

if echo $vms | grep -q "$vmname" ; then
    echo "Found an existing VM that matches $vmname, Skipping creation of vm"
else
    echo "Creating new VM with name $vmname"

    limactl start --name $vmname --tty=false ./lima.yaml

    echo "Created VM"
fi

port=$(limactl list --json | jq --slurp --arg vmname $vmname '.[] | select(.name==$vmname) | .sshLocalPort')

if [ $? -eq 0 ] ; then
    echo "Found VM in 'limactl list' - here's an SSH config"
    echo -e "Host $vmname\n    HostName localhost\n    User lima\n    ForwardAgent yes\n    Port $port"
else
    echo "Could not find vm and/or its IP, did it work?"
fi
