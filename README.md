# proxmox-gpu-passthrough-selector
Choose which VM is in control of the GPU for a quasi multiboot solution

The script assumes that the VMID starts with 9 (this is an arbitrary number I picked to make sure I'm not starting the wrong VM with GPU)

Usage: `./GPU.sh $VMID` to start `./GPU.sh none` to turn them all off
