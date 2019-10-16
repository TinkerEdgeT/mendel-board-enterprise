#!/bin/bash
#
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function partition_table_image {
    if [[ $1 -gt 7000000000 ]] && [[ $1 -lt 8000000000 ]]; then
        echo "partition-table-8gb.img"
    elif [[ $1 -gt 14000000000 ]] && [[ $1 -lt 17000000000 ]]; then
        echo "partition-table-16gb.img"
    elif [[ $1 -gt 60000000000 ]]; then
        echo "partition-table-64gb.img"
    fi
}

function die {
    echo "$@" >/dev/stderr
    exit 1
}

function try {
    $@ || die "Failed to execute $@"
}

ROOTDIR=$(dirname $0)/..
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

FASTBOOT_CMD="$(which fastboot)"
if [[ ! -x ${FASTBOOT_CMD} ]]; then
    die "Couldn't find fastboot on your PATH -- did you install it?"
fi

if [[ -n ${SERIAL} ]]; then
    FASTBOOT_CMD="fastboot -s ${SERIAL}"
fi

# Set USERSPACE_ARCH to arm64, if not set in the environment
USERSPACE_ARCH=${USERSPACE_ARCH:=arm64}

# If there's a boot.img in the same folder as flash.sh,
# find artifacts in the directory containing the script.
if [ -e ${SCRIPT_DIR}/boot_${USERSPACE_ARCH}.img ]; then
    PRODUCT_OUT=${SCRIPT_DIR}
else
    PRODUCT_OUT=${PRODUCT_OUT:=${ROOTDIR}/out/target/product/imx8m_phanbell}
fi

# Figure out which partition map we need based upon fastboot vars
MMC_SIZE=$(${FASTBOOT_CMD} getvar mmc_size 2>&1 | awk '/mmc_size:/ { print $2 }')
PART_IMAGE=$(partition_table_image ${MMC_SIZE})

if [[ -z ${PART_IMAGE} ]]; then
    die "No partition map available for an emmc of size ${MMC_SIZE}"
fi

for i in u-boot.imx boot_${USERSPACE_ARCH}.img rootfs_${USERSPACE_ARCH}.img ${PART_IMAGE}; do
    [[ ! -f ${PRODUCT_OUT}/$i ]] && die "${PRODUCT_OUT}/$i is missing."
done

# Flash bootloader
try ${FASTBOOT_CMD} flash bootloader0 ${PRODUCT_OUT}/u-boot.imx
try ${FASTBOOT_CMD} reboot-bootloader
sleep 3

# Flash partition table
try ${FASTBOOT_CMD} flash gpt ${PRODUCT_OUT}/${PART_IMAGE}
try ${FASTBOOT_CMD} reboot-bootloader
sleep 3

# Flash filesystems
try ${FASTBOOT_CMD} erase misc
#try ${FASTBOOT_CMD} flash boot ${PRODUCT_OUT}/boot_${USERSPACE_ARCH}.img
try ${FASTBOOT_CMD} erase boot
#try ${FASTBOOT_CMD} flash rootfs ${PRODUCT_OUT}/rootfs_${USERSPACE_ARCH}.img
try ${FASTBOOT_CMD} reboot
