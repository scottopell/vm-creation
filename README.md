# Configuration scripts for local VMs

I currently use [lima-vm](https://github.com/lima-vm/lima)
to run local linux VMs on my M1 macbook.

I don't generally use any lima features aside from start/stop.

I connect to my VMs via SSH manually instead of `limactl shell XYZ`
so that I can specify `ForwardAgent yes` and have access to my host
ssh keys inside my VM.

This is my main pain point currently, the SSH port used changes every
time the VM restarts, so I have to manually update my `~/.ssh/config`.

See `newvm.sh` for a simple script to create a VM and get the SSH config.

See `lima.yaml` for some setup scripts that installs dependencies and sets up
my dotfiles etc.
