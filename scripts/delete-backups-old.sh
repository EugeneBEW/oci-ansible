#!/bin/env bash

# # All envinroments
LAST_KEEP=1

list=$(cat list-hosts.txt)

for i in $list
do
    b_l=$(openstack volume backup list | grep $i | awk -F "|" '{print $3}')
    echo "$b_l" | sort -ur | tail -n +$(($LAST_KEEP+1)) | xargs -i echo openstack volume backup delete {}

done

