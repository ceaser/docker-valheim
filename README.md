# docker-valheim
Linux Dedicated Server for the Video Game Valheim using Docker

## Features
- [x] **World-persistence** on container destruction.
- [x] **Install-persistence** on container destruction.
- [x] Configuration via **ENV** variables.
- [x] Automatic update of game files on startup
- [ ] Mods and custom **mod-configuration**.
- [ ] Automatic update of mod files.

## Examples

Here is an example of a docker run line that exposes all ports and mounts the data directory to persist world and configuration files.

```SHELL
docker run -it -p '2456-2458:2456-2458/udp' -v `pwd`/data:'/data' -v `pwd`/game:'/game ceaser/valheim:latest
```
