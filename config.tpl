#!/bin/bash
blink_config --config-string "hostname=${gwname}&ftw_sic_key=${sickey}&timezone='America/New_York'&install_security_managment=false&install_mgmt_primary=false&install_security_gw=true&gateway_daip=false&install_ppak=true&gateway_cluster_member=false&download_info=true&upload_info=false&reboot_if_required=true" >> ftw.output &
