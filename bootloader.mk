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

ifeq ($(ROOTDIR),)
$(error $$ROOTDIR IS NOT DEFINED -- don\'t forget to source setup.sh)
endif

include $(ROOTDIR)/build/preamble.mk

bootloader: $(PRODUCT_OUT)/u-boot.imx

$(PRODUCT_OUT)/u-boot.imx: uboot-imx | out-dirs
	$(LOG) u-boot extract
	find $(PRODUCT_OUT)/packages -name 'uboot-imx*$(USERSPACE_ARCH)*.deb' | xargs \
	dpkg --fsys-tarfile | \
	tar --strip-components 2 -C $(PRODUCT_OUT) -xf - ./boot/u-boot.imx
	$(LOG) u-boot finished

.PHONY:: bootloader
