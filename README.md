# puppet-trusty

Basic standalone puppet setup and "Hello, World!" on a `ubuntu:trusty` based image.

This simple walkthrough, takes you through a rudimentary `puppet` node configuration using the supplied `Docker` image.  It skips a complex client-server setup and simply demonstrates the use of `puppet` to configure a node in standalone operation.  

This `puppet` example was adapted from [here](https://www.digitalocean.com/community/tutorials/how-to-install-puppet-in-standalone-mode-on-centos-7).

The first step is to build the Docker image.

    $ docker build -t mytag .
    
Run an interactive `bash` shell in a container, setting the hostname which `puppet` will use later.

    $ docker run -ti --hostname=mynode.example.com mytag bash

Check that the container's hostname is as expected and visible to `puppet` through `puppet's` own `facter` tool.

```sh
root@mynode:/# facter | grep  "hostname\|fqdn"
fqdn => mynode.example.com
hostname => mynode
```

Now inside the container, create a `puppet` configuration file which will be used to configure the node.

    root@mynode:/# vi /etc/puppet/manifests/myconfig.pp

```yaml
node "mynode.example.com" {

  file { '/root/example_file.txt':
    ensure => "file",
    owner  => "root",
    group  => "root",
    mode   => "700",
    content => "Congratulations!
Puppet created this file.
",
  }
}
```

Use `puppet` to apply this configuration to the node.

    root@mynode:/# puppet apply /etc/puppet/manifests/myconfig.pp
    
Check that the file was created with the expected properties.

```sh
root@mynode:/# cat /root/example_file.txt
Congratulations!
Puppet created this file. 
   
root@mynode:/# ls -l /root/example_file.txt
-rwx------ 1 root root 43 Dec 10 15:59 /root/example_file.txt
```

Break the config by changing the file's content and permissions.

```sh
root@mynode:/# cat > /root/example_file.txt
I'm broken!
^D (Ctrl-D)

root@mynode:/# cat /root/example_file.txt
I'm broken!

root@mynode:/# chmod +x /root/example_file.txt

root@mynode:/# ls -l /root/example_file.txt
-rwx--x--x 1 root root 43 Dec 10 15:59 /root/example_file.txt
```

Now re-apply the `puppet` configuration and check that the correct permission and content was restored.

```sh
root@mynode:/# puppet apply /etc/puppet/manifests/myconfig.pp
Notice: Compiled catalog for mynode.example.com in environment production in 0.07 seconds
Notice: /Stage[main]/Main/Node[mynode.example.com]/File[/root/example_file.txt]/mode: mode changed '0711' to '0700'
Notice: Finished catalog run in 0.03 seconds

root@mynode:/# ls -l /root/example_file.txt
-rwx------ 1 root root 43 Dec 10 15:59 /root/example_file.txt

root@mynode:/# cat /root/example_file.txt
Congratulations!
Puppet created this file.
```

That's it!