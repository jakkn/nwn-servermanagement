# nwn-servermanagement
Generic bash scripts for Neverwinter Nights server management, running nwnx2 on Linux.

The scripts in this repository are generic and only depend on the environment variables specified in the YAML file. No script customization should be necessary in order to use this with any standard nwnx2 server environment.

nwserver is launched in a tmux session which can be shared between users of a specified group.

## Dependencies
- nwnx2
- nwnstartup.sh (shell script to run nwserver with nwnx)
- customized YAML file (see default.yml)

## Configure
1. Clone `git clone https://github.com/jakkn/nwn-servermanagement.git`
2. Create your own YAML file `cd nwn-servermanagement && cp default.yml master.yml`
3. Edit the YAML file to fit the server environment

| Field | Description | Default |
| ----- | ----- | ----- |
| __server\_directory__ | absolute path to the directory containing nwserver | _/home/nwn/nwnserver_
| __user\_group__ | the linux user group to share the tmx session with | _nwn_
| __runscript__ | name of startup script in server directory | _nwnstartup.sh_
| __socket\_path__ | location of tmux session socket | _/tmp/nwn_socket_
| __target\_session__ | tmux session | _nwn_

## Use
* Display help `./server-control.sh -h`
* Start server `./server-control.sh -s master.yml`
* Stop server `./server-control.sh -S [now|friendly] master.yml`
* Restart server `./server-control.sh -r [now|friendly] master.yml`


Example of Cron jobs that start two servers  (main and test server) on computer boot, with weekly nwserver reboots

```
@reboot cd /home/nwn/nwn-servermanagement && ./server-control.sh -s master.yml  >>/home/nwn/log/cron.log 2>&1
@reboot cd /home/nwn/nwn-servermanagement && ./server-control.sh -s develop.yml  >>/home/nwn/log/cron.log 2>&1

00 13 * * 2 cd /home/nwn/nwn-servermanagement && ./server-control.sh -r friendly master.yml  >>/home/nwn/log/cron.log 2>&1

00 13 * * 2 cd /home/nwn/nwn-servermanagement && ./server-control.sh -r friendly develop.yml  >>/home/nwn/log/cron.log 2>&
```

## Credits
Based on the work of eeriegeek at http://www.entropywizard.net/nwn/crontab-entry.txt
