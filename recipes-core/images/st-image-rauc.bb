SUMMARY = "STM32MP OpenSTLinux Image with A/B rootfs for RAUC OTA Updates"
LICENSE = "MIT"

require recipes-st/images/st-image-core.bb

IMAGE_INSTALL:append = " rauc"

WKS_FILE = "st-image-rauc.wks.in"

# Force WIC to be used (generates .wic file with A/B partitions)
IMAGE_FSTYPES = "wic"

# Image size settings for rootfs
IMAGE_ROOTFS_EXTRA_SPACE = "102400"
IMAGE_OVERHEAD_FACTOR = "1.3"

EXTRA_IMAGECMD:ext4 = "-i 4096 -L ${@d.getVar('IMAGE_NAME_SUFFIX').replace('.', '', 1)[:16]} -O ^metadata_csum,^dir_index"