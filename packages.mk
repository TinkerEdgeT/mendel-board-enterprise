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

$(eval $(call make-pbuilder-bsp-package-target,imx-atf,imx-atf))
$(eval $(call make-pbuilder-bsp-package-target,imx-firmware,imx-firmware))
$(eval $(call make-pbuilder-bsp-package-target,imx-mkimage,tools/imx-mkimage))
$(eval $(call make-pbuilder-bsp-package-target,uboot-imx,uboot-imx,imx-atf imx-firmware imx-mkimage))
$(eval $(call make-pbuilder-bsp-package-target,wayland-protocols-imx,wayland-protocols-imx))
$(eval $(call make-pbuilder-bsp-package-target,weston-imx,weston-imx,wayland-protocols-imx))
$(eval $(call make-pbuilder-bsp-package-target,linux-imx,linux-imx))
$(eval $(call make-pbuilder-bsp-package-target,imx-gpu-viv,imx-gpu-viv,linux-imx,,binary))
$(eval $(call make-pbuilder-bsp-package-target,libdrm-imx,libdrm-imx))
$(eval $(call make-pbuilder-bsp-package-target,imx-vpu-hantro,imx-vpu-hantro,linux-imx,,binary))
$(eval $(call make-pbuilder-bsp-package-target,imx-vpuwrap,imx-vpuwrap,imx-vpu-hantro,,binary))
$(eval $(call make-pbuilder-bsp-package-target,imx-gstreamer,imx-gstreamer))
$(eval $(call make-pbuilder-bsp-package-target,imx-gst-plugins-base,imx-gst-plugins-base,imx-gstreamer))
$(eval $(call make-pbuilder-bsp-package-target,imx-gst-plugins-good,imx-gst-plugins-good,imx-gst-plugins-base))
$(eval $(call make-pbuilder-bsp-package-target,imx-gst-plugins-bad,imx-gst-plugins-bad,\
	libdrm-imx imx-gst-plugins-base linux-imx))
$(eval $(call make-pbuilder-bsp-package-target,imx-gst1.0-plugin,imx-gst1.0-plugin,\
	imx-vpuwrap imx-gst-plugins-bad))
$(eval $(call make-pbuilder-bsp-package-target,aiy-board-audio,packages/aiy-board-audio))
$(eval $(call make-pbuilder-bsp-package-target,aiy-board-tools,packages/aiy-board-tools))
$(eval $(call make-pbuilder-bsp-package-target,aiy-board-wlan,packages/aiy-board-wlan))
$(eval $(call make-pbuilder-bsp-package-target,bluez-imx,bluez-imx))