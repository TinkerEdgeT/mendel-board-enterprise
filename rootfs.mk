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

BSP_BASE_PACKAGES := \
	aiy-board-audio \
	aiy-board-tools \
	imx-board-wlan \
	edgetpu-api \
	linux-image-4.9.51-aiy \
	uboot-imx

BSP_GUI_PACKAGES := \
	imx-gpu-viv \
	imx-gst1.0-plugin \
	imx-vpu-hantro \
	imx-vpuwrap \
	libdrm-vivante \
	weston-imx
