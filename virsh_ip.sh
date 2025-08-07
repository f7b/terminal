#!/bin/bash

# Získaj názvy bežiacich VM (sudo pridané)
vms=($(sudo virsh list --name))

# Inicializuj max. šírku názvu VM a IP
max_vm_len=0
max_ip_len=0

# Mapovanie VM → IP
declare -A ip_map

# Najprv zisti max. dĺžky
for vm in "${vms[@]}"; do
  ip=$(sudo virsh domifaddr "$vm" | awk '/ipv4/ {print $4}' | cut -d'/' -f1)
  ip=${ip:-"(n/a)"}
  ip_map["$vm"]="$ip"

  [[ ${#vm} -gt $max_vm_len ]] && max_vm_len=${#vm}
  [[ ${#ip} -gt $max_ip_len ]] && max_ip_len=${#ip}
done

# Výpis
printf "\nRunning virsh VM:\n"
printf "%s\n" "$(printf '─%.0s' {1..17})"
for vm in "${vms[@]}"; do
  printf "%-${max_vm_len}s  %-${max_ip_len}s\n" "$vm" "${ip_map[$vm]}"
done

