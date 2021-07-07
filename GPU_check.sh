#!/bin/bash
clear
target=$1
active=0
echo "Good morning, Captain!"
qm list | awk '{print $1}' | grep '^[9]' > VM_list
if grep -Fxq "$target" /scripts/VM_list
then
	qm list | grep running | awk '{print $1}' | grep '^[9]' > running
	echo "I want to check on "$target
	for i in $(cat running)
	do
		echo $i" is on"
		if grep -Fxq "#GPU enabled" /etc/pve/qemu-server/$i.conf
		then
			echo "GPU is active"
			if [[ "$i" = "$target" ]]
			then
				echo "It's currently on"
				active=1
				/bin/true
			fi
		else
			echo "GPU is disabled"
			if [[ "$i" = "$target" ]]
			then
				/bin/false
			fi
		fi
	done
	if [[ "$target" != "none" ]] && [[ "$active" = "0" ]]
	then
		/bin/false
	fi
fi
