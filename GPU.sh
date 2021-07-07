#!/bin/bash
clear
target=$1
active=0
echo "Good morning, Captain!"
qm list | awk '{print $1}' | grep '^[9]' > VM_list
if grep -Fxq "$target" /scripts/VM_list || [[ "$target" = "none" ]]
then
	qm list | grep running | awk '{print $1}' | grep '^[9]' > running
	echo "I want to start "$target
	for i in $(cat running)
	do
		echo $i" is on"
		if grep -Fxq "#GPU enabled" /etc/pve/qemu-server/$i.conf
		then
			echo "GPU is active"
			if [[ "$i" = "$target" ]]
			then
				echo "Thats ok, I'll keep it on"
				active=1
				echo "Sending a resume in case it's sleeping"
                                qm resume $i
			else
				echo "Shutting down"
				qm shutdown $i
			fi
		else
			echo "GPU is disabled"
			if [[ "$i" = "$target" ]]
			then
				echo "Rebooting"
				qm shutdown $i
			fi
		fi
	done
	for conf in $(ls /scripts/conf/)
	do
		cat /scripts/conf/$conf > /etc/pve/qemu-server/$conf
	done
	cat /scripts/passthrough >> /etc/pve/qemu-server/$target.conf
	sed -i 's/memory: 4096/memory: 16384/g' /etc/pve/qemu-server/$target.conf
	if [[ "$target" != "none" ]] && [[ "$active" = "0" ]]
	then
		sleep 10
		echo "Starting "$target
		qm start $target
	fi
	echo "Have a nice day!"
else
	echo $target" is not a GPU enabled VM"
fi
if [[ "$target" = "none" ]]
then
	rm -f /etc/pve/qemu-server/none.conf
fi
