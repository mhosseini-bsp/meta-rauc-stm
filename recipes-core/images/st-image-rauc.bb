SUMMARY = "STM32MP OpenSTLinux Image with A/B rootfs for RAUC OTA Updates"
LICENSE = "MIT"

require recipes-st/images/st-image-core.bb

# Add RAUC and tools
IMAGE_INSTALL:append = " \
    rauc \
    u-boot-fw-utils \
"

WKS_FILE = "st-image-rauc.wks.in"
IMAGE_FSTYPES = "wic"

IMAGE_ROOTFS_EXTRA_SPACE = "102400"
IMAGE_OVERHEAD_FACTOR = "1.3"

EXTRA_IMAGECMD:ext4 = "-i 4096 -L ${@d.getVar('IMAGE_NAME_SUFFIX').replace('.', '', 1)[:16]} -O ^metadata_csum,^dir_index"

# Deploy RAUC boot script instead of extlinux
IMAGE_BOOT_FILES = "boot.scr"

do_image_wic[depends] += "u-boot:do_deploy"