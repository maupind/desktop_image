#!/usr/bin/bash
# shellcheck disable=SC1091

set -ouex pipefail

# Apply IP Forwarding before installing Docker to prevent messing with LXC networking
sysctl -p

#cp packages.json /tmp/packages.json
#rsync -rvK /system_files/dx/ /

/tmp/build_files/copr-repos-dx.sh
/tmp/build_files/install-akmods-dx.sh
/tmp/build_files/packages-dx.sh
#/ctx/build_files/image-info.sh
/tmp/build_files/fetch-install-dx.sh
/tmp/build_files/fonts-dx.sh
/tmp/build_files/workarounds.sh
/tmp/build_files/systemd-dx.sh
/tmp/build_files/branding-dx.sh
/tmp/build_files/cleanup-dx.sh
