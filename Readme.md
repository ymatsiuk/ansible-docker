# how to run

### Prerequisites

* Install vagrant
* Install the following plugins:

```
vagrant plugin install ansibler vagrant-hostmanager vagrant-hosts vagrant-persistent-storage
vagrant up
vagrant hosts list >> /etc/hosts
ansible-playbook -i vagrant-swarm -b -K -D docker.yml
```
