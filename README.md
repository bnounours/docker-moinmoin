# Docker for moinmoin wiki
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
