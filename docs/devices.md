# Devices

## Overview

| name     | hardware                  | comment                            |
| -------- | ------------------------- | ---------------------------------- |
| thinkpad | ThinkBook 16 G6+ IMH 21LE | yeah, not exactly think\***pad**\* |
| rpi5-k   | RaspberryPi 5 16GB        | main server                        |
| rpi4-f   | RaspberryPi 4 8GB         | test server                        |
| opi2-c   | OrangePi Zero 2 W 4GB     | minivan brains and mesh radio      |

### Details

All devices use sops for secret managment and all of them are using impermanence
to wipe root at boot. All devies marked as `Backup` backup all other devices
state (if any).

#### thinkpad

Storage: BTRFS 1TB SSD\
Backup:

- kiwix-images
- zroot
- home-assistant
- disk-images

#### rpi5-k

Storage: ZFS mirror 1TB\
Services: home-assistant NAS mediaserver\
Backup:

- code
- zroot
- kiwix-images
- disk-images
- media
- home
- home-assistant

#### rpi4-f

#### opi2-c
