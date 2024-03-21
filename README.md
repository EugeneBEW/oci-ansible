# oci-ansible
Creates DevOps tools set with ansible, openstack-cli and more in docker container environment. 
Helps to resolve version dependencies problems. 
Simplify every day admin's tasks and debugging

## Step 1: Build new container image
```
  git clone https://github.com/EugeneBEW/oci-ansible
  cd oci-ansible/
  sudo make
```

This command run a docker build  and create container with required tools

You also may run docker build manually:
```
  export VERSION=v6
  export NAME=oci-ansible
  docker build -t "$(NAME):$(VERSION)" --label "name"="$(NAME)" --label "version"="$(VERSION)" . \
    && docker save $(NAME):$(VERSION) | gzip > $(NAME)-$(VERSION).tgz
```  
 You may modify Dockerfile if needed, don't forgot change version.  

 Note: if you change version - use  
 ```  
 VERSION=YOUR_VERSION ./oci-ansible
 ```  
 or modify oci-ansible scrip directly

## Step 2: Run tools set
```
./oci-ansible bash
```
or 
```
./oci-ansible -- your_ansible_playbook.yaml
```
-- are same as ansible-playbook command
```
./oci-ansible ansible-playbook your_ansible_playbook.yaml
```
or 
```
./oci-ansible  any_command_in_container and_its_arguments
```
### Explanation

oci-ansible is a simple docker run wrapper, which simplefiya directory and file mapping into container.
It creates a desired directory structure and environment files under current dir at first start if not ./ansible/ dir exist:
```
  ./ansible/.ansible
  ./ansible/inventories/project
  ./ansible/collections
  ./ansible/roles
  ./ansible/files
  ./ansible/.env
  ./ansible/ansible.cfg
```
./ansible - is a default dir when run in container

You may set any environment variables for command execution in container via 	./ansible/.env

oci-ansible mount dirs and files into container:
```
		-v $VAULTFILE:/.vault.txt:ro \
		-v $HOME/.ssh:/root/.ssh \
		-v $ANSIBLEDIR:/ansible \
		-v $SCRIPTSDIR:/root/scripts \
		-v /etc/timezone:/etc/timezone:ro \
```
Value of $ANSIBLEDIR automatically filed if ./ansible or ../ansible or $HOME/ansible exist in such order

Value of $SCRIPTSDIR automatically filed if ./scripts or ../scripts or $HOME/scripts exist in such order

!!! Required:
 $VAULTFILE - you may create empty file if not used in ansible scripts 
 
 fully functioning ssh access to inventory hosts, assume than needed ssh config and private keys located at $HOME/.ssh

See oci-ansible script for more details.

### ansible-galaxy
ansible-galaxy also available under container environment
it place collection by default into  /ansible/collections in cis container 
which maps to ./ansible/collections dorectory on the host system

### file editing and directory navigation
use ms or vi for this 
Don't forgot that changes persist if it made on the rw mounted locations 

### /root/scripts directory
this directory is recommended place for OpenStack files like
admin-openstack.rc 

rooket.sh + list-hosts.txt help make backup of VM's volumes in openstack
