# everything for mining the social web (the book)
## Install
* install [virtual box](https://www.virtualbox.org/wiki/Downloads). Der Installationsort kann leider nicht geändert werden (Mac).
* install [vargrant](https://www.vagrantup.com/downloads.html). Der Installationsort kann auf Transcend geändert werden (Mac).
* clone the github repo from [GitHub](https://github.com/ptwobrussell/Mining-the-Social-Web-2nd-Edition/)

## Run
* go to the directory in the repo that contains the vagrantfile.
* Use `vagrant up` to download and install the virtual machine (takes 20 min)
* There might be an error with the permissions on the private-key file for the ssh to the virtual machine. In this case do the following:
  * let us assume that /project is the folder where the vagrant file lives.
  * So then goto /project/.vagrant/mashines/default/virtualtbox and copy the file to a local folder / home folder (let us assume /Users/rupertrebentisch/certificates/), where you can change the file permissions via `chmod 0600 key_file`
  * now set the vagrant system to find the file in this folder:
  * open the vagrant file and add the last line below the two lines (so this block look as follows:)
  ```sh
  override.vm.box = "precise64"
  override.vm.box_url = "http://files.vagrantup.com/precise64.box"
  config.ssh.private_key_path = "/Users/rupertrebentisch/certificates/private_key"
  ```
* Use `vagrant status` to check whether the vagrant mashine is up and running.
* you might have to update via `vagrant box update`
* start and stop vagrant via `vagrant up` and `vagrant halt` (do not use `vagrant suspend` in most cases)

## Maintenance
* go to the folder that contains the vagrantfile and isue `vagrant plugin install vagrant-vbguest`
* see this [blog](http://kvz.io/blog/2013/01/16/vagrant-tip-keep-virtualbox-guest-additions-in-sync/) for details.
* Nach einem `vagrant destroy`  ist zunächst der config.ssh.private_key_path wieder zu aktivieren, weil man nach einem destroy ein neues, anderes keyfile erhält.
