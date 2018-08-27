#!/bin/bash

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
    case $1 in
    7818182656)
        echo "partition-table-8gb.img" ;;
    15634268160)
        echo "partition-table-16gb.img" ;;
    62537072640)
        echo "partition-table-64gb.img" ;;
    *)
        echo "invalid-partition-table-$1.img" ;;
    esac
}

# Flash bootloader
fastboot flash bootloader0 ${PRODUCT_OUT}/u-boot.imx
fastboot reboot-bootloader

# Flash partition table
MMC_SIZE=$(fastboot getvar mmc_size 2>&1 | grep mmc_size | cut -d " " -f 2)
fastboot flash gpt ${PRODUCT_OUT}/$(partition_table_image ${MMC_SIZE})
fastboot reboot-bootloader

# Flash filesystems
fastboot erase misc
fastboot flash boot ${PRODUCT_OUT}/boot.img
fastboot flash rootfs ${PRODUCT_OUT}/rootfs.img
fastboot reboot
