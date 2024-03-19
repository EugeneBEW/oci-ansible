#!/bin/bash

for row in $(openstack server list  --long -c Networks -c Name | cut -d'|' -f2,3 | grep -v '\-\-\-' | sed -e 's/|\s.*vlan....//' -e 's/\s*172/:172/g' -e 's/^\s//g' ); do
    string=`echo $row | cut -d':' -f1`
    ip=`echo $row | cut -d':' -f2`

    len=${#string}
    for ((i = $len - 1; i >= 0; i--))
        do
        reverse="$reverse${string:$i:1}"
        done
    echo "$reverse" '###'  "$string" '###' "$ip"
    reverse=''
done

