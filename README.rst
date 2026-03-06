# meta-rauc-stm

RAUC support layer for STM32MP157F-DK2 and STM32MP1 platforms.

## Features

- A/B rootfs partitioning for resilient updates
- RAUC OTA update support
- U-Boot bootloader integration
- Data partition automatic growth
- Signed bundle support

## Prerequisites

- meta-st-stm32mp layer
- meta-rauc layer (from meta-openembedded)
- Yocto Scarthgap or later

## Usage

Add to `bblayers.conf`:
