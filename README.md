# chrome
Docker Automated Build Repository based off of [siomiz/chrome](https://registry.hub.docker.com/u/siomiz/chrome/) -- Google Chrome via VNC with iptable rules to drop udp for testing 

# default switches
Chrome switches that are always used with this container: no-first-run, no-default-browser-check, user-data-dir
  
# other switches
Additional switches can be added using environment vars.

1. CHROME_URL: specify url to start chrome with.
2. CHROME_ARGS: Pass all switches to chrome command. Pass all switches in one string. example: 

```
docker run -d -p 5900:5900 --privileged -e CHROME_ARGS="--use-fake-device-for-media-stream --use-fake-ui-for-media-stream" jmartine/chrome
```
#Why run as privileged?
In order to create iptable rules from the container.  If run without privileged UDP traffic will not be dropped.

#TODO
Currently listening to audio on the host machine is not working.
