##############################################
# OpenWrt Makefile for Webcam streamer package
##############################################
include $(TOPDIR)/rules.mk

PKG_NAME := webcamstreamer
PKG_VERSION := 0.1.0
PKG_RELEASE := 1

PKG_BUILD_DIR := $(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/webcamstreamer
	SECTION:=mods
	CATEGORY:=Doodle3D
	TITLE:=Webcam streamer
	DEPENDS:=+kmod-video-core +kmod-video-uvc +mjpg-streamer +libv4l +@BUSYBOX_CUSTOM +@BUSYBOX_CONFIG_INOTIFYD
endef
define Package/webcamstreamer/description
	Webcam streamer experiment
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)/
endef

define Package/webcamstreamer/install
	$(INSTALL_DIR) $(1)/usr/libexec/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/webcamstreamer $(1)/usr/libexec/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/webcamstreamer_init $(1)/etc/init.d/webcamstreamer  # copy directly to init dir (required for post-inst enabling)
endef

define Package/webcamstreamer/postinst
	$${IPKG_INSTROOT}/etc/init.d/webcamstreamer enable
	$${IPKG_INSTROOT}/etc/init.d/webcamstreamer start
endef

define Package/webcamstreamer/prerm
	$${IPKG_INSTROOT}/etc/init.d/webcamstreamer stop
	$${IPKG_INSTROOT}/etc/init.d/webcamstreamer disable
endef

$(eval $(call BuildPackage,webcamstreamer))
