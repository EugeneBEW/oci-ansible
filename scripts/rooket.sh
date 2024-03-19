#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

#set -x

LIST_REQUEST_INSTANCE="list-hosts.txt"
TEMP_DATA_OUTPUT="/tmp/temp-output"
TEMP_DATA_OUTPUT2="/tmp/temp-output2"

get_id_instance()
{
        create_array list_id_instances $1
        clear_data $2
        for item in ${list_id_instances[@]}
        do
                echo $item=$(openstack server show $item -f json | jq -r '.id' | sed 'N ; s/\n/=/') >> $2
        done
}

create_final_list()
{

        create_array list_name_id_instances $1
        clear_data $2


        for i in ${list_name_id_instances[@]}
        do
           echo prepare $i | cut -d '=' -f1  ### this help to find efemeral instances for exclutions
           rt=$(echo $i | cut -d '=' -f2)
           openstack volume list --status in-use -f table --long -c "Attached to" -f json | \
		   jq -r '.[][][]| .server_id, .id' | \
		   sed 'N ; s/\n/=/' | \
		   grep $rt >> $2
        done

        create_array intermediate_list_instances $2


        for s in ${intermediate_list_instances[@]}
        do
                ss=$(echo $s | cut -d '=' -f1)
                if [[ $(printf "%s\n" "${list_name_id_instances[@]}" | grep $ss) ]];
                then
                   create_backup_volume \
			   $(echo $s | cut -d '=' -f2) \
			   $(echo $(printf "%s\n" "${list_name_id_instances[@]}" | grep $ss | cut -d '=' -f1)-$(date +"%Y%m%d%H%M")) \
			   $(echo $(printf "%s\n" "${list_name_id_instances[@]}" | grep $ss | cut -d '=' -f1)) --force
                fi
        done
}


create_array()
{
        mapfile -t $1 < <(cat $2)
}

clear_data()
{
        >$1
}

create_backup_volume()
{
        openstack volume backup create $1 --force --name $2 --description $3
}


delete_temp_files()
{
        rm -rf $TEMP_DATA_OUTPUT
        rm -rf $TEMP_DATA_OUTPUT2
}


get_id_instance $LIST_REQUEST_INSTANCE $TEMP_DATA_OUTPUT
create_final_list $TEMP_DATA_OUTPUT $TEMP_DATA_OUTPUT2
#delete_temp_files


