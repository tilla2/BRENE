#!/bin/bash
# shellcheck disable=SC2154
# shellcheck disable=SC2154
MODDIR=${0%/*}
KSU_BIN=/data/adb/ksud
KSU_MODULES_DIR=/data/adb/modules
SUSFS_BIN=/data/adb/ksu/bin/susfs
PERSISTENT_DIR=/data/adb/brene
DEST_BIN_DIR=/data/adb/ksu/bin
mkdir -p "${PERSISTENT_DIR}" "${PERSISTENT_DIR}/fake_files"

if [ ! -x "${DEST_BIN_DIR}/susfs" ]; then
  if [ -x "${MODDIR}/tools/susfs" ]; then
    cp -pf "${MODDIR}/tools/susfs" "${DEST_BIN_DIR}/susfs" 2>/dev/null || true
  elif [ -f "${PERSISTENT_DIR}/susfs" ]; then
    cp -pf "${PERSISTENT_DIR}/susfs" "${DEST_BIN_DIR}/susfs" 2>/dev/null || true
  fi
fi
if [ -f "${DEST_BIN_DIR}/susfs" ]; then
  chmod 755 "${DEST_BIN_DIR}/susfs" 2>/dev/null || true
  [ -e "${DEST_BIN_DIR}/sus" ] || ln -sf "${DEST_BIN_DIR}/susfs" "${DEST_BIN_DIR}/sus" 2>/dev/null || true
  [ -e "${DEST_BIN_DIR}/ksu_susfs" ] || ln -sf "${DEST_BIN_DIR}/susfs" "${DEST_BIN_DIR}/ksu_susfs" 2>/dev/null || true
fi

[[ -x "${SUSFS_BIN}" ]] || { echo "[!] susfs missing, hiding DISABLED" >> "${PERSISTENT_DIR}/log.txt" 2>/dev/null || true; }
SUSFS_VARIANT=$(${SUSFS_BIN} show variant 2>/dev/null)
CUSTOM_ROM_NAMES="lineage|infinity|evolution|crdroid|mistos|axion|pixelos|rising|lunaris|halcyon|havoc|alphadroid|bliss|calyx|derpfest|graphene|lmodroid|lumine|matrixx|clover|yaap|aospa"

# Load utils
# Load utils
[[ -e "${MODDIR}/utils.sh" ]] && source "${MODDIR}/utils.sh"
if [ -e "${PERSISTENT_DIR}/config.sh" ]; then
  while IFS='=' read -r k v || [ -n "$k" ]; do
    k=$(printf '%s' "$k" | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    v=$(printf '%s' "$v" | tr -d '\r' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    case "$v" in
      \'*\'|\"*\")
        v=${v#?}
        v=${v%?}
        ;;
    esac
    case "$k" in
      config_*) ;;
      *) continue ;;
    esac
    case "$k" in
      *[!A-Za-z0-9_]* ) continue ;;
    esac
    case "$k" in
      config_brene_logs) config_brene_logs="$v" ;;
      config_custom_uname_kernel_release) config_custom_uname_kernel_release="$v" ;;
      config_custom_uname_kernel_version) config_custom_uname_kernel_version="$v" ;;
      config_custom_spoof_uname) config_custom_spoof_uname="$v" ;;
      config_developer_options) config_developer_options="$v" ;;
      config_disable_child_process_restrictions) config_disable_child_process_restrictions="$v" ;;
      config_enable_avc_log_spoofing) config_enable_avc_log_spoofing="$v" ;;
      config_enable_log) config_enable_log="$v" ;;
      config_fix_data_local_tmp_inconsistencies) config_fix_data_local_tmp_inconsistencies="$v" ;;
      config_hide_addon_d) config_hide_addon_d="$v" ;;
      config_hide_custom_recovery) config_hide_custom_recovery="$v" ;;
      config_hide_custom_rom_paths) config_hide_custom_rom_paths="$v" ;;
      config_hide_custom_rom_paths_2) config_hide_custom_rom_paths_2="$v" ;;
      config_hide_framework_res_apk) config_hide_framework_res_apk="$v" ;;
      config_hide_injections) config_hide_injections="$v" ;;
      config_hide_ksu_directories) config_hide_ksu_directories="$v" ;;
      config_hide_third_party_apps) config_hide_third_party_apps="$v" ;;
      config_hide_lineage_strings) config_hide_lineage_strings="$v" ;;
      config_hide_sus_mnts_for_non_su_procs) config_hide_sus_mnts_for_non_su_procs="$v" ;;
      config_hide_suspicious_pty) config_hide_suspicious_pty="$v" ;;
      config_kernel_umount) config_kernel_umount="$v" ;;
      config_paths_hiding__data_local_tmp) config_paths_hiding__data_local_tmp="$v" ;;
      config_paths_hiding__non_standard_sdcard) config_paths_hiding__non_standard_sdcard="$v" ;;
      config_paths_hiding__non_standard_sdcard_android) config_paths_hiding__non_standard_sdcard_android="$v" ;;
      config_paths_hiding__sdcard_android_data_media_obb) config_paths_hiding__sdcard_android_data_media_obb="$v" ;;
      config_paths_hiding__user_ca_certs) config_paths_hiding__user_ca_certs="$v" ;;
      config_pif_props) config_pif_props="$v" ;;
      config_rom_props) config_rom_props="$v" ;;
      config_saturation) config_saturation="$v" ;;
      config_selinux_hide) config_selinux_hide="$v" ;;
      config_show_refresh_rate) config_show_refresh_rate="$v" ;;
      config_spoof_cmdline_or_bootconfig) config_spoof_cmdline_or_bootconfig="$v" ;;
      config_spoof_brand) config_spoof_brand="$v" ;;
      config_spoof_date_properties) config_spoof_date_properties="$v" ;;
      config_spoof_device) config_spoof_device="$v" ;;
      config_spoof_device_name) config_spoof_device_name="$v" ;;
      config_spoof_fingerprint_properties) config_spoof_fingerprint_properties="$v" ;;
      config_spoof_hosts) config_spoof_hosts="$v" ;;
      config_spoof_libstagefright) config_spoof_libstagefright="$v" ;;
      config_spoof_manufacturer) config_spoof_manufacturer="$v" ;;
      config_spoof_model) config_spoof_model="$v" ;;
      config_spoof_os_patch_level_property) config_spoof_os_patch_level_property="$v" ;;
      config_spoof_os_security_patch_level_property) config_spoof_os_security_patch_level_property="$v" ;;
      config_spoof_system_properties) config_spoof_system_properties="$v" ;;
      config_spoof_utc_properties) config_spoof_utc_properties="$v" ;;
      config_spoof_vendor_security_patch_level_property) config_spoof_vendor_security_patch_level_property="$v" ;;
      config_su_compat) config_su_compat="$v" ;;
      config_sync_device_props) config_sync_device_props="$v" ;;
      config_umount_suspicious_mounts) config_umount_suspicious_mounts="$v" ;;
      config_spoof_uname) config_spoof_uname="$v" ;;
      config_usb_debugging) config_usb_debugging="$v" ;;
      config_spoof_verified_boot_hash) config_spoof_verified_boot_hash="$v" ;;
      config_wireless_debugging) config_wireless_debugging="$v" ;;
      *) continue ;; # unknown config_ key: ignore
    esac
  done < "${PERSISTENT_DIR}/config.sh"
fi
if [ "${config_sync_device_props}" = "1" ]; then
  config_spoof_system_properties=1
fi

mkdir -p "${PERSISTENT_DIR}"
# Clear logs
# Clear logs
true > "${PERSISTENT_DIR}/log.txt"
true > "${PERSISTENT_DIR}/logs.txt"
_brene_boot_ts="$(date '+%Y-%m-%d %H:%M:%S' 2>/dev/null || echo unknown)"
_brene_boot_bid="$(cut -c1-8 /proc/sys/kernel/random/boot_id 2>/dev/null)"
case "${_brene_boot_ts}" in
  19[0-9][0-9]-*|200[0-9]-*|201[0-9]-*|202[0-3]-*|unknown)
    [ -n "${_brene_boot_bid}" ] && _brene_boot_ts="${_brene_boot_ts} [${_brene_boot_bid}]" ;;
esac
echo "=== BRENE boot ${_brene_boot_ts} ===" >> "${PERSISTENT_DIR}/log.txt" 2>/dev/null || true
if command -v brene_log >/dev/null 2>&1; then
  brene_log "=== BRENE boot ${_brene_boot_ts} ==="
else
  echo "=== BRENE boot ${_brene_boot_ts} ===" >> "${PERSISTENT_DIR}/logs.txt" 2>/dev/null || true
fi
[[ -x "${SUSFS_BIN}" ]] || echo "[!] susfs missing, hiding DISABLED" >> "${PERSISTENT_DIR}/log.txt" 2>/dev/null || true

## Important Notes:
## Important Notes:
## - The following command can be run at other stages like service.sh, boot-completed.sh etc..,
## - The following command can be run at other stages like service.sh, boot-completed.sh etc..,
## - This module is just an demo showing how to use ksu_susfs tool to commuicate with kernel
## - This module is just an demo showing how to use ksu_susfs tool to commuicate with kernel
##
##

#### Spoof the stat of file/directory dynamically, effective only for processes that are marked umounted with uid >= 10000 ####
#### Spoof the stat of file/directory dynamically, effective only for processes that are marked umounted with uid >= 10000 ####
## Important Note:
## Important Note:
##  - It is stronly suggested to use dynamically if the target path will be mounted
##  - It is stronly suggested to use dynamically if the target path will be mounted
# cat <<EOF >/dev/null
# cat <<EOF >/dev/null
# # First, clone the permission before adding to sus_kstat
# # First, clone the permission before adding to sus_kstat
# brene_clone_perm "$MODDIR/hosts" /system/etc/hosts
# brene_clone_perm "$MODDIR/hosts" /system/etc/hosts

# # Second, before bind mount your file/directory, use 'add_sus_kstat' to add the path #
# # Second, before bind mount your file/directory, use 'add_sus_kstat' to add the path #
# ${SUSFS_BIN} add_sus_kstat '/system/etc/hosts'
# ${SUSFS_BIN} add_sus_kstat '/system/etc/hosts'

# # Now bind mount or overlay your path #
# # Now bind mount or overlay your path #
# mount -o bind "$MODDIR/hosts" /system/etc/hosts
# mount -o bind "$MODDIR/hosts" /system/etc/hosts

# # Finally use 'update_sus_kstat' to update the path again for the changed ino and device number #
# # Finally use 'update_sus_kstat' to update the path again for the changed ino and device number #
# # update_sus_kstat updates ino, but blocks and size are remained the same as current stat #
# # update_sus_kstat updates ino, but blocks and size are remained the same as current stat #
# ${SUSFS_BIN} update_sus_kstat '/system/etc/hosts'
# ${SUSFS_BIN} update_sus_kstat '/system/etc/hosts'

# # Or if you want to fully clone the stat value from the original stat, use update_sus_kstat_full_clone instead #
# # Or if you want to fully clone the stat value from the original stat, use update_sus_kstat_full_clone instead #
# #${SUSFS_BIN} update_sus_kstat_full_clone '/system/etc/hosts'
# #${SUSFS_BIN} update_sus_kstat_full_clone '/system/etc/hosts'
# EOF
# EOF

#### Spoof the stat of file/directory statically, effective only for processes that are marked umounted with uid >= 10000 ####
#### Spoof the stat of file/directory statically, effective only for processes that are marked umounted with uid >= 10000 ####
## Important Note:
## Important Note:
##  - It is suggested to use statically if you don't need to mount anything but simply change the stat of a target path
##  - It is suggested to use statically if you don't need to mount anything but simply change the stat of a target path
# cat <<EOF >/dev/null
# cat <<EOF >/dev/null
# Usage: ksu_susfs add_sus_kstat_statically </path/of/file_or_directory> \
# Usage: ksu_susfs add_sus_kstat_statically </path/of/file_or_directory> \
#                         <ino> <dev> <nlink> <size> <atime> <atime_nsec> <mtime> <mtime_nsec> <ctime> <ctime_nsec> \
#                         <ino> <dev> <nlink> <size> <atime> <atime_nsec> <mtime> <mtime_nsec> <ctime> <ctime_nsec> \
#                         <blocks> <blksize>
#                         <blocks> <blksize>
# ${SUSFS_BIN} add_sus_kstat_statically '/system/framework/services.jar' 'default' 'default' 'default' 'default' '1230768000' '0' '1230768000' '0' '1230768000' '0' 'default' 'default'
# ${SUSFS_BIN} add_sus_kstat_statically '/system/framework/services.jar' 'default' 'default' 'default' 'default' '1230768000' '0' '1230768000' '0' '1230768000' '0' 'default' 'default'
# EOF
# EOF

#### Redirect opened target path to user-defined path ####
#### Redirect opened target path to user-defined path ####
# Please be reminded the following #
# Please be reminded the following #
# 1. Both target_pathname and redirected_pathname must be existed before they can be added to kernel.
# 1. Both target_pathname and redirected_pathname must be existed before they can be added to kernel.
# 2. Users have to take care of the selinux permission for both target_pathname and redirected_pathname by themselves first.
# 2. Users have to take care of the selinux permission for both target_pathname and redirected_pathname by themselves first.
## Set the permission of the redirected path first ##
## Set the permission of the redirected path first ##
# brene_clone_perm '/data/local/tmp/my_hosts' '/system/etc/hosts'
# brene_clone_perm '/data/local/tmp/my_hosts' '/system/etc/hosts'
## Now add the target path and redirected path with pre-defined uid scheme to kernel ##
## Now add the target path and redirected path with pre-defined uid scheme to kernel ##
## *Run 'ksu_susfs add_open_redirect' for more details of <uid_scheme> ##
## *Run 'ksu_susfs add_open_redirect' for more details of <uid_scheme> ##
# ${SUSFS_BIN} add_open_redirect '/system/etc/hosts' '/data/local/tmp/my_hosts' '0'
# ${SUSFS_BIN} add_open_redirect '/system/etc/hosts' '/data/local/tmp/my_hosts' '0'


#### Spoof /proc/cmdline or /proc/bootconfig, effective for all processes ####
#### Spoof /proc/cmdline or /proc/bootconfig, effective for all processes ####
# No root process detects it for now, and this spoofing won't help much actually #
# No root process detects it for now, and this spoofing won't help much actually #
# /proc/bootconfig #
# /proc/bootconfig #
# cat <<EOF >/dev/null
# cat <<EOF >/dev/null
# FAKE_BOOTCONFIG=${MODDIR}/fake_bootconfig.txt
# FAKE_BOOTCONFIG=${MODDIR}/fake_bootconfig.txt
# cat /proc/bootconfig > ./fake_bootconfig.txt
# cat /proc/bootconfig > ./fake_bootconfig.txt
# sed -i 's/^androidboot.bootreason.*$/androidboot.bootreason = "reboot"/g' ${FAKE_BOOTCONFIG}
# sed -i 's/^androidboot.bootreason.*$/androidboot.bootreason = "reboot"/g' ${FAKE_BOOTCONFIG}
# sed -i 's/^androidboot.vbmeta.device_state.*$/androidboot.vbmeta.device_state = "locked"/g' ${FAKE_BOOTCONFIG}
# sed -i 's/^androidboot.vbmeta.device_state.*$/androidboot.vbmeta.device_state = "locked"/g' ${FAKE_BOOTCONFIG}
# sed -i 's/^androidboot.verifiedbootstate.*$/androidboot.verifiedbootstate = "green"/g' ${FAKE_BOOTCONFIG}
# sed -i 's/^androidboot.verifiedbootstate.*$/androidboot.verifiedbootstate = "green"/g' ${FAKE_BOOTCONFIG}
# sed -i '/androidboot.verifiedbooterror/d' ${FAKE_BOOTCONFIG}
# sed -i '/androidboot.verifiedbooterror/d' ${FAKE_BOOTCONFIG}
# sed -i '/androidboot.verifyerrorpart/d' ${FAKE_BOOTCONFIG}
# sed -i '/androidboot.verifyerrorpart/d' ${FAKE_BOOTCONFIG}
# ${SUSFS_BIN} set_cmdline_or_bootconfig ${FAKE_BOOTCONFIG}
# ${SUSFS_BIN} set_cmdline_or_bootconfig ${FAKE_BOOTCONFIG}
# EOF
# EOF

# /proc/cmdline #
# /proc/cmdline #
# cat <<EOF >/dev/null
# cat <<EOF >/dev/null
# FAKE_PROC_CMDLINE_FILE=${MODDIR}/fake_proc_cmdline.txt
# FAKE_PROC_CMDLINE_FILE=${MODDIR}/fake_proc_cmdline.txt
# cat /proc/cmdline > ${FAKE_PROC_CMDLINE_FILE}
# cat /proc/cmdline > ${FAKE_PROC_CMDLINE_FILE}
# sed -i 's/androidboot.verifiedbootstate=orange/androidboot.verifiedbootstate=green/g' ${FAKE_PROC_CMDLINE_FILE}
# sed -i 's/androidboot.verifiedbootstate=orange/androidboot.verifiedbootstate=green/g' ${FAKE_PROC_CMDLINE_FILE}
# sed -i 's/androidboot.vbmeta.device_state=unlocked/androidboot.vbmeta.device_state=locked/g' ${FAKE_PROC_CMDLINE_FILE}
# sed -i 's/androidboot.vbmeta.device_state=unlocked/androidboot.vbmeta.device_state=locked/g' ${FAKE_PROC_CMDLINE_FILE}
# ${SUSFS_BIN} set_cmdline_or_bootconfig ${FAKE_PROC_CMDLINE_FILE}
# ${SUSFS_BIN} set_cmdline_or_bootconfig ${FAKE_PROC_CMDLINE_FILE}
# EOF
# EOF

if [[ "${config_spoof_cmdline_or_bootconfig}" == "1" ]]; then

	if [[ "${SUSFS_VARIANT}" == "GKI" ]]; then
		FAKE_BOOTCONFIG="${PERSISTENT_DIR}/fake_bootconfig"
		[ -L "${FAKE_BOOTCONFIG}" ] && rm -f -- "${FAKE_BOOTCONFIG}"

		cat /proc/bootconfig > "${FAKE_BOOTCONFIG}"
		sed -i 's/androidboot.warranty_bit = "1"/androidboot.warranty_bit = "0"/' "${FAKE_BOOTCONFIG}"
		sed -i 's/androidboot.verifiedbootstate = "orange"/androidboot.verifiedbootstate = "green"/' "${FAKE_BOOTCONFIG}"
		if [[ -s "${FAKE_BOOTCONFIG}" ]]; then
			${SUSFS_BIN} set_cmdline_or_bootconfig "${FAKE_BOOTCONFIG}" 2>/dev/null || true
		elif [[ "${config_brene_logs}" == "1" ]]; then
			brene_log "[cmdline_or_bootconfig] SKIPPED (empty FAKE_BOOTCONFIG)"
		fi
	else
		FAKE_CMDLINE="${PERSISTENT_DIR}/fake_cmdline"
		[ -L "${FAKE_CMDLINE}" ] && rm -f -- "${FAKE_CMDLINE}"

		cat /proc/cmdline > "${FAKE_CMDLINE}"
		sed -i 's/androidboot.warranty_bit=1/androidboot.warranty_bit=0/' "${FAKE_CMDLINE}"
		sed -i 's/androidboot.verifiedbootstate=orange/androidboot.verifiedbootstate=green/' "${FAKE_CMDLINE}"
		if [[ -s "${FAKE_CMDLINE}" ]]; then
			${SUSFS_BIN} set_cmdline_or_bootconfig "${FAKE_CMDLINE}" 2>/dev/null || true
		elif [[ "${config_brene_logs}" == "1" ]]; then
			brene_log "[cmdline_or_bootconfig] SKIPPED (empty FAKE_CMDLINE)"
		fi
	fi
fi

#### Enable avc log spoofing to bypass 'su' domain detection via /proc/<pid> enumeration, effective for all processes ####
#### Enable avc log spoofing to bypass 'su' domain detection via /proc/<pid> enumeration, effective for all processes ####
## disable it when users want to do some debugging with the permission issue or selinux issue ##
## disable it when users want to do some debugging with the permission issue or selinux issue ##
#ksu_susfs enable_avc_log_spoofing 0
#ksu_susfs enable_avc_log_spoofing 0
if [[ "${config_enable_avc_log_spoofing}" == "1" ]]; then
	${SUSFS_BIN} enable_avc_log_spoofing 1 2>/dev/null || true
fi

#### Hide all sus mounts for NON-SU processes in this stage just to prevent zygote from caching them in memory ####
#### Hide all sus mounts for NON-SU processes in this stage just to prevent zygote from caching them in memory ####
## This should be mainly applied if you have ReZygisk enabled but without TreatWheel module ##
## This should be mainly applied if you have ReZygisk enabled but without TreatWheel module ##
## Or it is up to you to keep it enabled since su process can still see the mounts ##
## Or it is up to you to keep it enabled since su process can still see the mounts ##
if [[ "${config_hide_sus_mnts_for_non_su_procs}" == "1" ]]; then
	${SUSFS_BIN} hide_sus_mnts_for_non_su_procs 1 2>/dev/null || true
fi

#### Spoof the uname, effective for all processes ####
#### Spoof the uname, effective for all processes ####
# ${SUSFS_BIN} set_uname 'default' 'default'
# ${SUSFS_BIN} set_uname 'default' 'default'

if [[ "${config_custom_spoof_uname}" == "1" ]]; then

if [[ "${config_brene_logs}" == "1" ]]; then
                        brene_log ""
                        brene_log "#####################"
                        brene_log "Custom Uname Spoofing"
                        brene_log "#####################"
        fi

        final_uname_release="${config_custom_uname_kernel_release}"
        final_uname_version="${config_custom_uname_kernel_version}"

        case "${final_uname_release}" in
                default) ;;
                *[!A-Za-z0-9._+~-]*|"") final_uname_release="default" ;;
        esac
        case "${final_uname_version}" in
                default) ;;
                *[!A-Za-z0-9\ \#\(\),.:+_~@-]*|"") final_uname_version="default" ;;
        esac

        if [[ "${final_uname_release}" == "default" || "${final_uname_version}" == "default" ]]; then
                auto_kernel_version=$(cat /proc/version | awk '{print $3}' | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')
                auto_uname_version="#1 SMP PREEMPT $(resetprop ro.build.date | tr -s ' ')"

                if [[ -n "${auto_kernel_version}" ]]; then
                        if [[ "${SUSFS_VARIANT}" == "GKI" ]]; then
                                auto_kmi=$(${KSU_BIN} boot-info current-kmi | cut -d'-' -f1)
                                if [[ -n "${auto_kmi}" ]]; then
                                        auto_uname_release="${auto_kernel_version}-${auto_kmi}-$(shuf -i 1-9 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%d", rand()*9+1}')-g$(shuf -i 10000000-99999999 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%08d", rand()*90000000+10000000}')-ab$(shuf -i 10000000-99999999 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%08d", rand()*90000000+10000000}')"
                                fi
                        else
                                auto_uname_release="${auto_kernel_version}-g$(shuf -i 10000000-99999999 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%08d", rand()*90000000+10000000}')"
                        fi

                        [[ -n "${auto_uname_release:-}" && "${final_uname_release}" == "default" ]] && final_uname_release="${auto_uname_release}"
                        [[ "${final_uname_version}" == "default" ]] && final_uname_version="${auto_uname_version}"
                fi
        fi

        brene_set_uname "${final_uname_release}" "${final_uname_version}" || true

elif [[ "${config_spoof_uname}" == "1" ]]; then
        if [[ "${config_brene_logs}" == "1" ]]; then
                        brene_log ""
                        brene_log "##############"
                        brene_log "Uname Spoofing"
                        brene_log "##############"
        fi

        kernel_version=$(cat /proc/version | awk '{print $3}' | grep -oE '^[0-9]+\.[0-9]+\.[0-9]+')
        uname_kernel_version="#1 SMP PREEMPT $(resetprop ro.build.date | tr -s ' ')"

        if [[ -n "${kernel_version}" ]]; then
                if [[ "${SUSFS_VARIANT}" == "GKI" ]]; then
                        kmi=$(${KSU_BIN} boot-info current-kmi | cut -d'-' -f1)
                        if [[ -n "${kmi}" ]]; then
                                uname_kernel_release="${kernel_version}-${kmi}-$(shuf -i 1-9 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%d", rand()*9+1}')-g$(shuf -i 10000000-99999999 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%08d", rand()*90000000+10000000}')-ab$(shuf -i 10000000-99999999 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%08d", rand()*90000000+10000000}')"
                        fi
                else
                        uname_kernel_release="${kernel_version}-g$(shuf -i 10000000-99999999 -n 1 2>/dev/null || awk 'BEGIN{srand();printf "%08d", rand()*90000000+10000000}')"
                fi

                [[ -n "${uname_kernel_release:-}" ]] && brene_set_uname "${uname_kernel_release}" "${uname_kernel_version}" || true
        fi
fi

## Disable susfs kernel log ##
## Disable susfs kernel log ##
if [[ "${config_enable_log}" == "1" ]]; then
	${SUSFS_BIN} enable_log 1 2>/dev/null || true
elif [[ "${config_enable_log}" == "0" ]]; then
	${SUSFS_BIN} enable_log 0 2>/dev/null || true
fi

# Hide /system/addon.d Path
# Hide /system/addon.d Path
if [[ "${config_hide_addon_d}" == "1" ]]; then
	brene_sus_map "/system/addon.d" || true
    brene_sus_path_loop "/system/addon.d" || true
fi

# Hide Custom ROM Paths
# Hide Custom ROM Paths
if [[ "${config_hide_custom_rom_paths}" == "1" ]]; then
	for i in ${CUSTOM_ROM_NAMES//|/ }; do
		brene_find /system /system_ext /vendor /product -iname "*${i}*" -print0 | while IFS= read -r -d '' path; do
			brene_sus_map "${path}" || true
			brene_sus_path_loop "${path}" || true
		done


		brene_find /data -maxdepth 1 -iname "*${i}*" -print0 | while IFS= read -r -d '' path; do
			brene_sus_path_loop "${path}" || true
		done
	done
fi

# Hide Custom ROM Paths (Extreme)
# Hide Custom ROM Paths (Extreme)
if [[ "${config_hide_custom_rom_paths_2}" == "1" ]]; then
        for i in ${CUSTOM_ROM_NAMES//|/ }; do
                brene_find /data/misc /data/dalvik-cache /data/resource-cache -iname "*${i}*" -print0 | while IFS= read -r -d '' path; do
                        brene_sus_map "${path}" || true
                        brene_sus_path_loop "${path}" || true
                done
        done
fi

BRENE_UPTIME_SEC=$(awk '{print int($1)}' /proc/uptime 2>/dev/null || echo 0)
case "$BRENE_UPTIME_SEC" in ''|*[!0-9]*) BRENE_UPTIME_SEC=999;; esac
if [[ "${config_spoof_system_properties}" == "1" && "${BRENE_UPTIME_SEC}" -lt 120 ]]; then
    RESETPROP=""
    for candidate in /data/adb/ksu/bin/resetprop /data/adb/magisk/resetprop /data/adb/ap/bin/resetprop; do
        [[ -x "${candidate}" ]] && RESETPROP="${candidate}" && break
    done

    if [[ -n "${RESETPROP}" ]]; then
        MAIN_FP=$(getprop ro.build.fingerprint)
        MAIN_FP="${MAIN_FP//userdebug/user}"
        MAIN_FP="${MAIN_FP//evolution/}"
        MAIN_FP="${MAIN_FP//crdroid/}"
        MAIN_FP="${MAIN_FP//lineage/}"
        MAIN_ID=$(getprop ro.build.id)
        MAIN_RELEASE=$(getprop ro.build.version.release)
        MAIN_SDK=$(getprop ro.build.version.sdk)
        MAIN_SDK_FULL=$(getprop ro.build.version.sdk_full)
        MAIN_INCREMENTAL=$(getprop ro.build.version.incremental)
        MAIN_RELEASE_CODENAME=$(getprop ro.build.version.release_or_codename)
        MAIN_DATE=$(getprop ro.build.date)
        MAIN_DATE_UTC=$(getprop ro.build.date.utc)
        MAIN_SECURITY_PATCH=$(getprop ro.build.version.security_patch)
        MAIN_TAGS=$(getprop ro.build.tags)
        MAIN_TYPE=$(getprop ro.build.type)
        MAIN_BRAND=$(getprop ro.product.brand)
        MAIN_DEVICE=$(getprop ro.product.device)
        MAIN_MANUFACTURER=$(getprop ro.product.manufacturer)
        MAIN_MODEL=$(getprop ro.product.model)
        MAIN_NAME=$(getprop ro.product.name)
        _brene_brand_src="auto"
        _brene_device_src="auto"
        _brene_manufacturer_src="auto"
        _brene_model_src="auto"
        _brene_name_src="auto"
        case "${config_spoof_brand:-}" in
        ""|-*|*[!A-Za-z0-9_.-]*) ;;
        *)
        MAIN_BRAND="${config_spoof_brand}"
        if_prop_exits_resetprop_n "ro.product.brand" "${MAIN_BRAND}"
        _brene_brand_src="override"
        ;;
        esac
        case "${config_spoof_device:-}" in
        ""|-*|*[!A-Za-z0-9_.-]*) ;;
        *)
        MAIN_DEVICE="${config_spoof_device}"
        if_prop_exits_resetprop_n "ro.product.device" "${MAIN_DEVICE}"
        _brene_device_src="override"
        ;;
        esac
        case "${config_spoof_manufacturer:-}" in
        ""|-*|*[!A-Za-z0-9_.-]*) ;;
        *)
        MAIN_MANUFACTURER="${config_spoof_manufacturer}"
        if_prop_exits_resetprop_n "ro.product.manufacturer" "${MAIN_MANUFACTURER}"
        _brene_manufacturer_src="override"
        ;;
        esac
        case "${config_spoof_model:-}" in
        ""|-*|*[!A-Za-z0-9_.-]*) ;;
        *)
        MAIN_MODEL="${config_spoof_model}"
        if_prop_exits_resetprop_n "ro.product.model" "${MAIN_MODEL}"
        _brene_model_src="override"
        ;;
        esac
        case "${config_spoof_device_name:-}" in
        ""|-*|*[!A-Za-z0-9_.-]*) ;;
        *)
        MAIN_NAME="${config_spoof_device_name}"
        if_prop_exits_resetprop_n "ro.product.name" "${MAIN_NAME}"
        _brene_name_src="override"
        ;;
        esac

        FIELDS="id version.release version.sdk version.incremental version.release_or_codename version.sdk_full tags type"
        if [[ "${config_spoof_fingerprint_properties}" == "1" ]]; then FIELDS="fingerprint ${FIELDS}"; fi
        if [[ "${config_spoof_date_properties}" == "1" ]]; then FIELDS="${FIELDS} date"; fi
        if [[ "${config_spoof_utc_properties}" == "1" ]]; then FIELDS="${FIELDS} date.utc"; fi
        if [[ "${config_spoof_os_security_patch_level_property}" != "1" ]]; then FIELDS="${FIELDS} version.security_patch"; fi
        PRODUCT_FIELDS="brand device manufacturer model name"

        if [[ "${config_brene_logs}" == "1" ]]; then
                brene_log ""
                brene_log "########################"
                brene_log "Build Props Spoofing"
                brene_log "########################"
                brene_log "[sync_prop]: brand ${_brene_brand_src} -> ${MAIN_BRAND}"
                brene_log "[sync_prop]: device ${_brene_device_src} -> ${MAIN_DEVICE}"
                brene_log "[sync_prop]: manufacturer ${_brene_manufacturer_src} -> ${MAIN_MANUFACTURER}"
                brene_log "[sync_prop]: model ${_brene_model_src} -> ${MAIN_MODEL}"
                brene_log "[sync_prop]: device-name ${_brene_name_src} -> ${MAIN_NAME}"
        fi

        if [[ -n "${MAIN_FP}" ]]; then
            DISCOVERED_PARTS=$(getprop | grep -oE '^\[ro\.[a-z0-9_]+\.build\.fingerprint\]' | sed -E 's/^\[ro\.([a-z0-9_]+)\.build\.fingerprint\]$/\1/')
            _brene_sync_matched=0

            for part in ${DISCOVERED_PARTS}; do
                [[ "${part}" == "build" ]] && continue
                [[ "${part}" == "bootimage" ]] && continue
                _brene_sync_matched=1

                for field in ${FIELDS}; do
                    prop_name="ro.${part}.build.${field}"
                    current_value=$(getprop "${prop_name}")

                    if [[ -n "${current_value}" ]]; then
                        new_value=""
                        case "${field}" in
                            fingerprint) new_value="${MAIN_FP}" ;;
                            id) new_value="${MAIN_ID}" ;;
                            version.release) new_value="${MAIN_RELEASE}" ;;
                            version.sdk) new_value="${MAIN_SDK}" ;;
                            version.incremental) new_value="${MAIN_INCREMENTAL}" ;;
                            version.release_or_codename) new_value="${MAIN_RELEASE_CODENAME}" ;;
                            version.sdk_full) new_value="${MAIN_SDK_FULL}" ;;
                            date) new_value="${MAIN_DATE}" ;;
                            date.utc) new_value="${MAIN_DATE_UTC}" ;;
                            version.security_patch) new_value="${MAIN_SECURITY_PATCH}" ;;
                            tags) new_value="${MAIN_TAGS}" ;;
                            type) new_value="${MAIN_TYPE}" ;;
                            *) continue ;;
                        esac

                        if [[ -n "${new_value}" && "${current_value}" != "${new_value}" ]]; then
                            if timeout 3 "${RESETPROP}" "${prop_name}" "${new_value}" 2>/dev/null; then
                                if [[ "${config_brene_logs}" == "1" ]]; then
                                    brene_log "[sync_prop]: ${prop_name}: ${current_value} -> ${new_value}"
                                fi
                            fi
                        fi
                    fi
                done

                for pfield in ${PRODUCT_FIELDS}; do
                    prop_name="ro.product.${part}.${pfield}"
                    current_value=$(getprop "${prop_name}")

                    if [[ -n "${current_value}" ]]; then
                        new_value=""
                        case "${pfield}" in
                            brand) new_value="${MAIN_BRAND}" ;;
                            device) new_value="${MAIN_DEVICE}" ;;
                            manufacturer) new_value="${MAIN_MANUFACTURER}" ;;
                            model) new_value="${MAIN_MODEL}" ;;
                            name) new_value="${MAIN_NAME}" ;;
                            *) continue ;;
                        esac

                        if [[ -n "${new_value}" && "${current_value}" != "${new_value}" ]]; then
                            if timeout 3 "${RESETPROP}" "${prop_name}" "${new_value}" 2>/dev/null; then
                                if [[ "${config_brene_logs}" == "1" ]]; then
                                    brene_log "[sync_prop]: ${prop_name}: ${current_value} -> ${new_value}"
                                fi
                            fi
                        fi
                    fi
                done
            done
            if [[ "${_brene_sync_matched}" == "0" && "${config_spoof_fingerprint_properties}" == "1" ]]; then
                brene_spoof_fingerprint_props
            fi
        fi
    fi
fi

if [[ -e "${PERSISTENT_DIR}/custom_sus_kstat.txt" ]]; then
        if [[ "${config_brene_logs}" == "1" ]]; then
                        brene_log ""
                        brene_log "########################"
                        brene_log "Custom KSTAT"
                        brene_log "########################"
        fi
        while IFS= read -r i || [[ -n "${i}" ]]; do
                brene_kstat_add_line "${i}" || true
        done < "${PERSISTENT_DIR}/custom_sus_kstat.txt"
fi

if [[ -e "${PERSISTENT_DIR}/custom_open_redirect.txt" ]]; then
        if [[ "${config_brene_logs}" == "1" ]]; then
                        brene_log ""
                        brene_log "########################"
                        brene_log "Custom OPEN REDIRECT"
                        brene_log "########################"
        fi
        set -f
        while IFS= read -r i || [[ -n "${i}" ]]; do
                i=${i%$'\r'}
                trimmed="$(printf '%s' "${i}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
                [[ -z "${trimmed}" || "${trimmed}" == "#"* ]] && continue

                OLDIFS="${IFS}"
                IFS=$'\t'
                set -- ${i}
                IFS="${OLDIFS}"

                if [[ "$#" -eq 3 ]]; then
                        if brene_open_redirect "$1" "$2" "$3"; then
                                [[ "${config_brene_logs}" == "1" ]] && brene_log "[custom_open_redirect]: ${i}"
                        fi
                else
                        [[ "${config_brene_logs}" == "1" ]] && brene_log "[custom_open_redirect] SKIPPED (expected 3 TAB-separated fields, got $#): ${i}"
                fi
        done < "${PERSISTENT_DIR}/custom_open_redirect.txt"
        set +f

fi

# Spoof /system/etc/hosts
# Spoof /system/etc/hosts
if [[ "${config_spoof_hosts}" == "1" ]]; then
    path=/system/etc/hosts
    safe="$(printf '%s' "${path}" | tr '/' '_')"
    fake_file_path="${PERSISTENT_DIR}/fake_files/${safe}"

    busybox chcon --reference="${path}" "${PERSISTENT_DIR}/fake_files" 2>/dev/null || true
    [ -L "${fake_file_path}" ] && rm -f -- "${fake_file_path}"
    if [[ ! -f "${fake_file_path}" ]]; then
        printf '127.0.0.1       localhost\n::1             ip6-localhost\n' > "${fake_file_path}"
    fi

    brene_clone_perm "${fake_file_path}" "${path}" || true
    brene_open_redirect "${path}" "${fake_file_path}" '3' || true

    ${SUSFS_BIN} add_sus_kstat_statically "${path}" '100' 'default' 'default' '56' 'default' 'default' 'default' 'default' 'default' 'default' '1' '4096' 2>/dev/null || true
fi

if [[ "${config_spoof_system_properties}" == "1" ]]; then
   brene_spoof_system_properties || true
fi
# Spoof Fingerprint Properties
# Spoof Fingerprint Properties
if [[ "${config_spoof_fingerprint_properties}" == "1" ]]; then
   brene_spoof_fingerprint_props || true
fi
# Spoof UTC Properties
# Spoof UTC Properties
if [[ "${config_spoof_utc_properties}" == "1" ]]; then
   brene_spoof_utc_props || true
fi
# Spoof Date Properties
# Spoof Date Properties
if [[ "${config_spoof_date_properties}" == "1" ]]; then
   brene_spoof_date_props || true
fi
# Spoof OS Security Patch Level Property
# Spoof OS Security Patch Level Property
if [[ "${config_spoof_os_security_patch_level_property}" == "1" ]]; then
   brene_spoof_os_security_patch_props || true
fi
# Spoof Vendor Security Patch Level Property
# Spoof Vendor Security Patch Level Property
if [[ "${config_spoof_vendor_security_patch_level_property}" == "1" ]]; then
   brene_spoof_vendor_security_patch_props || true
fi

# Hide Suspicious PTYs
# Hide Suspicious PTYs
if [[ "${config_hide_suspicious_pty}" == "1" ]]; then
	if [[ "${config_brene_logs}" == "1" ]]; then
			brene_log ""
			brene_log "####################"
			brene_log "Hide Suspicious PTYs"
			brene_log "####################"
	fi

	for i in $(seq 0 9); do
		brene_sus_path_loop "/dev/pts/${i}" || true
	done
fi

if [[ "${config_brene_logs}" == "1" ]]; then
	echo "post-fs-data.sh ✅" >> "${PERSISTENT_DIR}/log.txt"
fi
