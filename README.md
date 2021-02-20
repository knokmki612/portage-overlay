# knokmki612's portage overlay

## Installation

Add conf to `/etc/portage/repos.conf/knokmki612.conf` as follows:

```
[knokmki612]
priority = 50
location = # Type any location of this repository
sync-type = git
sync-uri = https://github.com/knokmki612/portage-overlay.git
auto-sync = yes
```

Then do `emerge --sync`
