5minbootstrap
=============

Bootstrap and secure your server in 5 minutes flat using Ansible on another Unix box you control. On a minimal Debian install, you might have to run  
$ apt-get update && apt-get install git ansible nano sshpass

A riff on these excellent posts:

http://plusbryan.com/my-first-5-minutes-on-a-server-or-essential-security-for-linux-servers  
http://practicalops.com/my-first-5-minutes-on-a-server.html

More details:
http://www.consumedconsumer.org/2014/08/how-to-quickly-set-up-your-vps.html

IB EDIT: changed .pub from fred;

TL;DR
=====

## Step 1: Set the root password

Run:

    yourmachine$ ssh root@server

Enter the initial root password from your hosting provider, then run:

	root@server# passwd


## Step 2: Fetch the bootstrap recipe

[https://github.com/ibonobo/5minbootstrap/](https://github.com/ibonobo/5minbootstrap/)

    yourmachine ~$ git clone https://github.com/ibonobo/5minbootstrap.git
	yourmachine ~$ cd 5minbootstrap


## Step 3: Edit hosts.ini

Ansible needs to know about the servers you want to manage.  There is
no fancy central database, just a text file with a list of
servers.  Oh, it's called an "inventory file."

Edit the `hosts.ini` that came with the repository.  Replace
`127.0.0.1` with your IP address, and `:2222` with your SSH port.

    [newservers]
	127.0.0.1:2222
	

## Step 4: Update the SSH public key.

    yourmachine ~/5minbootstrap$ cp ~/.ssh/id_dsa.pub ./ibonobo.pub

For simplicity I provided my public key in the repo.  Unless you want
to grant me login access to your server, you probably want to change
that. :-)


## Step 5: Modify the playbook variables.

You don't want the original author to get your logs, so modify the email accordingly as well as the password > bootstrap.yml
also, lines 44-45, if Ubuntu it deletes stable (so that only security remain) but if Debian it should be also security only so modify to remove the rest or comment out 44-45  
//      "o=Debian,a=stable";  
//      "o=Debian,a=stable-updates";  
//      "o=Debian,a=proposed-updates";  
        "origin=Debian,archive=stable,label=Debian-Security";  


## Step 6: Run the playbook

If you are logging into a fresh Linode, or another system where you only have the `root` user, you need to run this command:

    yourmachine ~/5minbootstrap$ ansible-playbook -i hosts.ini bootstrap.yml --user root --ask-pass
(otherwise, on Vagrant, --ask-pass --sudo after .yml)

IB note: On a minimal Debian install I get this error. 
"Using a SSH password instead of a key is not possible because Host Key checking is enabled and sshpass does not support this.  Please add this host's fingerprint to your known_hosts file to manage this host."
To get key: 
$ ssh-keyscan -t rsa server_ip >> ~/.ssh/known_hosts
That finally got the ball rolling.
	
## Step 7: Go get a cup of coffee because you're DONE.

I prefer hand-ground French pressed coffee myself.  Tea is also fine.

IB TO DO: 
1. ADD / modify port + 45-44
2. If you want logging, or more info, pass the -v flag to ansible-playbook on the command line and you'll see the stdout and stderr for each task executed:

$ ansible-playbook -v playbook.yaml
Ansible also has built-in support for logging. Add the following lines to your ansible configuration file:

[defaults] 
log_path=/path/to/logfile

Ansible will look in several places for the config file:

ansible.cfg in the current directory where you ran ansible-playbook
~/.ansible.cfg
/etc/ansible/ansible.cfg

3. Some servers have the time zone off, which messes up the logs. To change the timezone interactively, do  
$ dpkg-reconfigure tzdata  
to do it non-interactively (scripted), use
$ echo "US/Eastern" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata
