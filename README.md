# proxmox-gpu-passthrough-selector
Choose which VM is in control of the GPU for a quasi multiboot solution

The script assumes that the VMID starts with 9 (this just makes sure it's not messing with VM's that are not supposed to be GPU enabled
Usage: `./GPU.sh $VMID` to start `./GPU.sh none` to turn them all off
