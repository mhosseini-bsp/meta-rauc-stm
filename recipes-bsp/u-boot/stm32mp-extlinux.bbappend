FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

# Replace boot.scr.cmd with your RAUC version
SRC_URI = "file://boot.scr.cmd"

# That's it! The recipe will use your boot.scr.cmd instead of ST's 