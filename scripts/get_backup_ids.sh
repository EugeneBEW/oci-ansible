#!/bin/env bash

get_backup_ids()
{
        ids=$(openstack volume backup list | grep $1 | awk -F"|" '{print $2}')
        echo $ids
}

get_backup_ids $1

