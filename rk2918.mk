#
# Copyright (C) 2012 The CyanogenMod Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

$(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_us_supl.mk)

LOCAL_PATH := device/rockchip/rk2918

DEVICE_PACKAGE_OVERLAYS += $(LOCAL_PATH)/overlay


PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.lcd_density=120

# Ramdisk
PRODUCT_COPY_FILES += \
	$(LOCAL_PATH)/ramdisk/init:root/init \
	$(LOCAL_PATH)/ramdisk/init.rc:root/init.rc \
	$(LOCAL_PATH)/ramdisk/init.rk29board.rc:root/init.rk29board.rc \
	$(LOCAL_PATH)/ramdisk/init.rk29board.usb.rc:root/init.rk29board.usb.rc \
	$(LOCAL_PATH)/ramdisk/ueventd.rk29board.rc:root/ueventd.rk29board.rc \
	$(LOCAL_PATH)/ramdisk/rk29xxnand.ko:root/rk29xxnand.ko \


# Recovery-Ramdisk
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/recovery/postrecoveryboot.sh:recovery/root/sbin/postrecoveryboot.sh \
    $(LOCAL_PATH)/ramdisk/initlogo.rle:recovery/root/initlogo.rle \
    $(LOCAL_PATH)/ramdisk/rk29xxnand.ko:recovery/root/rk29xxnand.ko \
    $(LOCAL_PATH)/ramdisk/init.rk29board.rc:recovery/root/init.rk29board.rc \
    $(LOCAL_PATH)/ramdisk/init.rk29board.usb.rc:recovery/root/init.rk29board.usb.rc \
    $(LOCAL_PATH)/ramdisk/misc.img:recovery/root/misc.img \
    $(LOCAL_PATH)/ramdisk/ueventd.rk29board.rc:recovery/root/ueventd.rk29board.rc

#Unifique prebuilt 
PRODUCT_COPY_FILES += \
	$(call find-copy-subdir-files,*,device/rockchip/rk2918/prebuilt,system)	
	

PRODUCT_PROPERTY_OVERRIDES += \
    wifi.interface=wlan0 \
    wifi.supplicant_scan_interval=15

# other kernel modules not in ramdisk
PRODUCT_COPY_FILES += $(foreach module,\
	$(filter-out $(RAMDISK_MODULES),$(wildcard device/rockchip/rk2918/modules/*.ko)),\
	$(module):system/lib/modules/$(notdir $(module)))

PRODUCT_PACKAGES := \
	hwcomposer.rk29board \
	sensors.rk29board \
    	libtinyalsa \
    	libaudioutils \
	keystore.default \
	charger \
	charger_res_images \

	

PRODUCT_PACKAGES := \
	Stk \
	LegacyCamera

# Packages
PRODUCT_PACKAGES := \
    rktools \
    com.android.future.usb.accessory \

# Filesystem management tools
PRODUCT_PACKAGES += \
    static_busybox \
    make_ext4fs \
    setup_fs

# Live Wallpapers
PRODUCT_PACKAGES += \
    Galaxy4 \
    HoloSpiralWallpaper \
    LiveWallpapers \
    LiveWallpapersPicker \
    MagicSmokeWallpapers \
    NoiseField \
    PhaseBeam \
    VisualizationWallpapers \
    librs_jni

# Prebuilt kernel
ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := $(LOCAL_PATH)/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# These are the hardware-specific features
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/tablet_core_hardware.xml:system/etc/permissions/tablet_core_hardware.xml \
	frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.barometer.xml:system/etc/permissions/android.hardware.sensor.barometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:system/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:system/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

# Feature live wallpaper
PRODUCT_COPY_FILES += \
    packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:system/etc/permissions/android.software.live_wallpaper.xml

PRODUCT_PROPERTY_OVERRIDES += \
    ro.opengles.version=131072

PRODUCT_TAGS += dalvik.gc.type-precise

PRODUCT_CHARACTERISTICS := tablet
$(call inherit-product, frameworks/native/build/tablet-dalvik-heap.mk)


# Set default USB interface
PRODUCT_DEFAULT_PROPERTY_OVERRIDES += \
    persist.sys.usb.config=mass_storage

# Use the non-open-source parts, if they're present
$(call inherit-product-if-exists, vendor/rockchip/rk2918/rk2918-vendor.mk)
