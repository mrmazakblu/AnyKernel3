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

$BB mount -o rw,remount -t auto /system;
$BB mount -o rw,remount -t auto /system_root;
$BB mount -o rw,remount -t auto /vendor;

$BB cp -r /tmp/anykernel/add-these/* /system_root/

## AnyKernel file attributes
# set permissions/ownership for included ramdisk files
set_perm_recursive 0 2000 750 /system_root/bin/healthd;
set_perm_recursive 0 2000 755 644 /system_root/res/images/font_log.png;
set_perm_recursive 0 2000 755 644 /system_root/res/images/charger/battery_fail.png;
set_perm_recursive 0 2000 755 644 /system_root/res/images/charger/battery_scale.png;
set_perm_recursive 0 2000 755 644 /system_root/res/images/charger/cm_battery_scale.png;

## AnyKernel install

# begin INIT changes

# init.#HARDWARE#.rc
hardware=$(getprop ro.hardware)
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "on charger" "# start Mod for Offline charge";
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "# start Mod for Offline charge" "	write /sys/class/leds/lcd-backlight/trigger /"backlight/"";
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "	write /sys/class/leds/lcd-backlight/trigger /"backlight/"" "	service charger /sbin/healthd -c";
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "	service charger /sbin/healthd -c" "    class charger";
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "    class charger" "    critical";
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "    critical" "    seclabel u:r:healthd:s0";
insert_line /vendor/etc/init/hw/init.$hardware.rc "MTK" after "    seclabel u:r:healthd:s0" "# End Mod for Offline charge";


# init.#HARDWARE#.usb.rc
insert_line /vendor/etc/init/hw/init.$hardware.usb.rc "on charger" after "on charger" "    write /sys/class/android_usb/android0/enable 1";
 
# end INIT changes

## end install 

