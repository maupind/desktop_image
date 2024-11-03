#!/usr/bin/bash
# shellcheck disable=SC1091

set -ouex pipefail

# Apply IP Forwarding before installing Docker to prevent messing with LXC networking
sysctl -p

cp /packages.json /tmp/packages.json
rsync -rvK /system_files/dx/ /

/build_files/copr-repos-dx.sh
/build_files/install-akmods-dx.sh
/build_files/packages-dx.sh
#/ctx/build_files/image-info.sh
/build_files/fetch-install-dx.sh
/build_files/fonts-dx.sh
/build_files/workarounds.sh
/build_files/systemd-dx.sh
/build_files/branding-dx.sh
/build_files/cleanup-dx.sh
