# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=ExampleKernel by osm0sis @ xda-developers
do.devicecheck=0
do.modules=
do.systemless=0
do.cleanup=0
do.cleanuponabort=0
device.name1=
device.name2=
device.name3=
device.name4=
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/platform/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=auto;


## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

# Copy New Files

systemdir=system_root
$BB mount -a
$BB mount -o rw,remount -t auto /$systemdir;
$BB mount -o rw,remount -t auto /vendor;

$BB cp -r /tmp/anykernel/add-these/* /$systemdir/

## AnyKernel file attributes
# set permissions/ownership for added files
set_perm_recursive 0 2000 750 /$systemdir/bin/healthd;
set_perm_recursive 0 2000 755 644 /$systemdir/res/images/font_log.png;
set_perm_recursive 0 2000 755 644 /$systemdir/res/images/charger/battery_fail.png;
set_perm_recursive 0 2000 755 644 /$systemdir/res/images/charger/battery_scale.png;
set_perm_recursive 0 2000 755 644 /$systemdir/res/images/charger/cm_battery_scale.png;

## AnyKernel install

# begin INIT changes

# init.#HARDWARE#.rc
hardware=$(getprop ro.hardware)
append_file /vendor/etc/init/hw/init.$hardware.rc "MTK" /tmp/anykernel/hardware.rc;

# init.#HARDWARE#.usb.rc
append_file /vendor/etc/init/hw/init.$hardware.usb.rc "on charger" /tmp/anykernel/hardware.usb.rc;
 
# end INIT changes

## end install 

