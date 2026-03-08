#########################################################################
# RAUC A/B Boot Script
# Replaces extlinux.conf with direct boot commands
#########################################################################

echo "=== RAUC: Slot Selection ==="

test -n "${BOOT_ORDER}" || setenv BOOT_ORDER "A B"
test -n "${BOOT_A_LEFT}" || setenv BOOT_A_LEFT 3
test -n "${BOOT_B_LEFT}" || setenv BOOT_B_LEFT 3

setenv bootpart
setenv raucslot

for BOOT_SLOT in ${BOOT_ORDER}; do
  if test "x${bootpart}" = "x"; then
    if test "x${BOOT_SLOT}" = "xA" && itest ${BOOT_A_LEFT} -gt 0; then
      setexpr BOOT_A_LEFT ${BOOT_A_LEFT} - 1
      setenv bootpart "/dev/mmcblk0p10"
      setenv raucslot "A"
      echo "Selected slot A (${BOOT_A_LEFT} attempts left)"
    elif test "x${BOOT_SLOT}" = "xB" && itest ${BOOT_B_LEFT} -gt 0; then
      setexpr BOOT_B_LEFT ${BOOT_B_LEFT} - 1
      setenv bootpart "/dev/mmcblk0p11"
      setenv raucslot "B"
      echo "Selected slot B (${BOOT_B_LEFT} attempts left)"
    fi
  fi
done

if test -z "${bootpart}"; then
  echo "ERROR: No valid slot"
  setenv BOOT_A_LEFT 3
  setenv BOOT_B_LEFT 3
  saveenv
  reset
fi

echo "Booting from slot: ${raucslot}"
saveenv

# ============================================================================
# Optional M4 Firmware (kept for future use)
# ============================================================================

echo "Checking for M4 firmware..."
env set m4fw_name "rproc-m4-fw.elf"
env set m4fw_addr ${kernel_addr_r}

if test -e ${devtype} ${devnum}:${distro_bootpart} ${m4fw_name}; then
    echo "Loading M4 firmware..."
    if load ${devtype} ${devnum}:${distro_bootpart} ${m4fw_addr} ${m4fw_name}; then
        rproc init
        rproc load 0 ${m4fw_addr} ${filesize}
        rproc start 0
        echo "M4 started"
    fi
else
    echo "No M4 firmware - skipping"
fi

# ============================================================================
# Direct boot (replaces extlinux.conf)
# ============================================================================

echo "=== Loading kernel and initrd ==="

# Load kernel from bootfs (partition 8, ext4)
ext4load mmc 0:8 0xc0000000 /uImage
if test $? -ne 0; then
    echo "ERROR: Failed to load kernel"
    reset
fi

# Load device tree from bootfs
ext4load mmc 0:8 0xc2000000 /stm32mp157f-dk2.dtb
if test $? -ne 0; then
    echo "ERROR: Failed to load device tree"
    reset
fi

# Load initrd from bootfs (optional, but in your setup you have it)
ext4load mmc 0:8 0xcf000000 /st-image-resize-initrd
if test $? -ne 0; then
    echo "ERROR: Failed to load initrd"
    reset
fi

# ============================================================================
# Set kernel boot arguments with RAUC slot
# ============================================================================

# This replaces the APPEND line from extlinux.conf
setenv bootargs "root=${bootpart} rootwait rw console=ttySTM0,115200 rauc.slot=${raucslot}"

echo "=== Booting kernel ===?"
echo "Root: ${bootpart}"
echo "Slot: ${raucslot}"
echo "Bootargs: ${bootargs}"

# Boot with kernel, initrd, and device tree
bootm 0xc0000000 - 0xc2000000

echo "ERROR: Boot failed!"
reset