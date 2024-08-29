#!/usr/bin/env bash

###################################################
HELP() {

  echo -e "
ubuntu-gdm-set-background-23.04-transparent script (for making Ubuntu 23.04 login-background color transparent so that the background set
via gsettings set com.ubuntu.login-screen background-picture-uri is visible) HELP

Example Commands:
1. ./ubuntu-gdm-set-background-23.04-transparent --help
2. sudo ./ubuntu-gdm-set-background-23.04-transparent --set --using-yaru-theme
3. sudo ./ubuntu-gdm-set-background-23.04-transparent --set --using-vanilla-theme
4. sudo ./ubuntu-gdm-set-background-23.04-transparent --reset --using-vanilla-theme
5. sudo ./ubuntu-gdm-set-background-23.04-transparent --reset --using-yaru-theme"
}
###################################################

###################################################
ROUTINE_CHECK() {
  if [ "$UID" != "0" ]; then
    echo -e "This script must be run with sudo"
    exit 1
  fi

  if ! [ -d "$dest" ]; then
    install -d "$dest"
  fi

}
###################################################

###################################################
EXTRACT() {
  for r in $(gresource list $source); do
    t="${r/#\/org\/gnome\/shell\//}"
    mkdir -p -- "$(dirname -- "$tmp_dir/$t")"
    # *should* only be $tmp_dir/theme, but should make a tempdir for this
    gresource extract "$source" "$r" >"$tmp_dir/$t"
  done
}
###################################################

###################################################
CREATE_XML() {
  extractedFiles="$(find "$tmp_dir/theme" -type f -printf "    <file>%P</file>\n")"
  cat <<EOF >"$tmp_dir/theme/custom-gdm-background.gresource.xml"
<?xml version="1.0" encoding="UTF-8"?>
<gresources>
  <gresource prefix="/org/gnome/shell/theme">
$extractedFiles
  </gresource>
</gresources>
EOF
}
###################################################

###################################################
SET_GRESOURCE() {
  update-alternatives --quiet --install /usr/share/gnome-shell/gdm-theme.gresource gdm-theme.gresource $dest/custom-gdm-background.gresource 0
  update-alternatives --quiet --set gdm-theme.gresource $dest/custom-gdm-background.gresource

  if update-alternatives --query gdm-theme.gresource | grep -q "Value: $dest/custom-gdm-background.gresource"; then
    echo -e "
\xf0\x9f\x98\x80\x00 'login-dialog background is made transparent succesfully'
Changes will be effective after a Reboot (CTRL+ALT+F1 may show the changes immediately)
If something went wrong, log on to tty and run the below command
sudo update-alternatives --quiet --set gdm-theme.gresource $source
"
  else
    echo Failure
    exit 1
  fi
}
###################################################

codename="$(grep UBUNTU_CODENAME /etc/os-release | cut -d = -f 2)"
osname="$(grep -E '="?Ubuntu"?$' /etc/os-release | cut -d = -f 2)"

dest="/usr/local/share/gnome-shell/custom-gdm"

if [ "$codename" != "mantic" ]; then
if [ "$codename" != "lunar" ] || [ "$osname" != '"Ubuntu"' ]; then
  echo -e "
--------------------------------------------------------------
Sorry, Script is only for Ubuntu 23.04
Exiting...
--------------------------------------------------------------"
  exit 1
fi
fi

if ! dpkg -l | grep -q libglib2.0-dev-bin; then
  echo -e "
-----------------------------------------------------------------------------------------------------
Installing dependency 'libglib2.0-dev-bin'...
-----------------------------------------------------------------------------------------------------"
  #exit 1
  sudo apt-get install libglib2.0-dev-bin
fi

############################################################################################
case "$1" in

--help)
  HELP
  exit 0
  ;;

--reset)
  ROUTINE_CHECK
  if ! [ -f $dest/custom-gdm-background.gresource ]; then
    echo -e "
-----------------------------------------------------------------------------
No need, Already Reset. (or unlikely background is not set using this Script.)
-----------------------------------------------------------------------------"
    exit 0
  elif [ "$UID" != "0" ]; then
    echo -e "This Script must be run with sudo$"
    exit 1
  else
    if [ "$2" == "--using-vanilla-theme" ]; then
      source="/usr/share/gnome-shell/gnome-shell-theme.gresource"
    elif [ "$2" == "--using-yaru-theme" ]; then
      source="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
    else
      echo "Please provide either '--using-vanilla-theme' or '--using-yaru-theme' as second parameter to this script'"
      exit 0
    fi
    rm $dest/custom-gdm-background.gresource
    update-alternatives --quiet --set gdm-theme.gresource $source
    (cd /usr/local/share/ && rmdir --ignore-fail-on-non-empty -p gnome-shell/custom-gdm)
    echo -e "
      				---------------
		  		|Reset Success|
		  		---------------
		  		Changes will be effective after a Reboot"
    exit 0
  fi
  ;;

--set)
  ROUTINE_CHECK
  if [ "$2" == "--using-vanilla-theme" ]; then
    source="/usr/share/gnome-shell/gnome-shell-theme.gresource"
  elif [ "$2" == "--using-yaru-theme" ]; then
    source="/usr/share/gnome-shell/theme/Yaru/gnome-shell-theme.gresource"
  else
    echo "Please provide either '--using-vanilla-theme' or '--using-yaru-theme' as second parameter to this script'"
    exit 0
  fi
  tmp_dir="$(mktemp -d)"
  trap 'rm -rf "$tmp_dir"' EXIT
  EXTRACT
  mv "$tmp_dir/theme/gdm.css" "$tmp_dir/theme/original.css"
  echo '
@import url("resource:///org/gnome/shell/theme/original.css");
.login-dialog {
background-color: transparent;
}
' >"$tmp_dir/theme/gdm.css"

  CREATE_XML

  glib-compile-resources --sourcedir "$tmp_dir/theme" "$tmp_dir/theme/custom-gdm-background.gresource.xml"

  mv "$tmp_dir/theme/custom-gdm-background.gresource" $dest

  SET_GRESOURCE

  exit 0
  ;;

*)

  echo -e "Use the options --help | --set | --reset"
  exit 1
  ;;
esac

