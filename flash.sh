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

set -e

ROOTDIR=$(dirname $0)/..
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# If there's a boot.img in the same folder as flash.sh,
# find artifacts in the directory containing the script.
if [ -e ${SCRIPT_DIR}/boot.img ]; then
    PRODUCT_OUT=${SCRIPT_DIR}
else
    PRODUCT_OUT=${PRODUCT_OUT:=${ROOTDIR}/out/target/product/imx8m_phanbell}
fi

function partition_table_image {
    if [[ $1 -gt 7000000000 ]] && [[ $1 -lt 8000000000 ]]; then
        echo "partition-table-8gb.img"
    elif [[ $1 -gt 14000000000 ]] && [[ $1 -lt 17000000000 ]]; then
        echo "partition-table-16gb.img"
    elif [[ $1 -gt 60000000000 ]]; then
        echo "partition-table-64gb.img"
    fi
}

# Flash bootloader
fastboot flash bootloader0 ${PRODUCT_OUT}/u-boot.imx
fastboot reboot-bootloader

# Figure out which partition map we need based upon fastboot vars
MMC_SIZE=$(fastboot getvar mmc_size 2>&1 | awk '/mmc_size:/ { print $2 }')
PART_IMAGE=$(partition_table_image ${MMC_SIZE})

if [[ -z ${PART_IMAGE} ]]; then
    echo "No partition map available for an emmc of size ${MMC_SIZE}" >/dev/stderr
    exit 1
fi

# Flash partition table
fastboot flash gpt ${PRODUCT_OUT}/${PART_IMAGE}
fastboot reboot-bootloader

# Flash filesystems
fastboot erase misc
fastboot flash boot ${PRODUCT_OUT}/boot.img
fastboot flash rootfs ${PRODUCT_OUT}/rootfs.img
fastboot reboot
