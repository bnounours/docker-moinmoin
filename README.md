# Docker for moinmoin wiki

## Data container
Before using this docker we need to create a docker which will contain all data. It will allow an easy backup/restore and also make upgrade of application easier
To create a data container run the following command :

```Shell
docker run --name moin-data -v /opt/config -v /opt/data -v /opt/logs bnounours/docker-moinmoin echo "Data Docker"
```

To use several instance of moinmoin you just have to create several data container with different names

## Install
To create a docker from this image use the following command

```Shell
docker run -p 80:8080 bnounours/docker-moinmoin
```

This will pull the docker package and start it. 

```
-p 80:8080
```
means the the host will listen on port 80 which is linked to port 8080 inside the docker.


## TODO
- [ ] Allow customization of configuration (expose configuration volume)
- [ ] Allow storage of data (expose data volume)
- [ ] Allow plugin of data (expose data volume)
- [ ] Allow mail to be configured (link to an postfix/sendmail docker)
- [ ] Auto create an admi user using moin command line
- [ ] Allow connection with fail2ban docker to check bad login attempts
- [ ] Test backup command ```sudo docker run --volumes-from dbdata -v $(pwd):/backup ubuntu tar cvf /backup/backup.tar /dbdata```
