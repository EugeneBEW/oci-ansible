#!/bin/bash

TMPFILE=/tmp/$$.tmp


openstack volume list --status in-use -f table --long -c "Attached to" -f json | jq -r '.[][][]| .server_id, .id, .device' | sed 'N ; N; s/\n/,/g' > $TMPFILE

mapfile all_volumes < $TMPFILE

rm -f $TMPFILE

echo "VM_Name,VM_Id,Volume_ID,Device"

for l in $(openstack server list -f json  | jq -r '.[]|.ID, .Name'| sed 'N; s/\n/,/' ); do

        n=$(echo $l | cut -f2 -d ',')
        i=$(echo $l | cut -f1 -d ',')

        #echo $i ' ### ' $v

        for s in ${all_volumes[@]} ; do
                echo "$n,$s" | grep $i
        done
done

