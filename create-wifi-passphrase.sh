#!/bin/bash
# This script creates a passphrase for use in WiFi WPA2
# encryption, saves it to a file, and generates a QR
# code from it.
# By Daniel Kraus 2015 -- placed in the public domain.
echo "This utility script will create a random WPA2 passphrase for a Wifi network"
echo "along with a QR code that you can scan with a mobile device to automatically"
echo "connect to the network."

die() {
        echo $*
        exit 1
}

checkcmd() {
        which $1 >/dev/null || die "Missing dependency: Please enter 'sudo apt-get install $1'!"
}

DIR=~/tmp
[ -e $DIR ] || DIR=/tmp
[ -e $DIR ] || DIR=~

checkcmd pwgen 
checkcmd qrencode

read -p "Enter SSID (empty SSID to quit): " SSID
[ -z "$SSID" ] && exit 1
FILEBASE="$DIR/wifi-$SSID"
TXTFILE="${FILEBASE}.txt"
SVGFILE="${FILEBASE}.svg"

pwgen -sy 63 > "$TXTFILE"
sed -i "s/;/$(pwgen 1)/g" "$TXTFILE"
qrencode -t svg -o "$SVGFILE" "WIFI:T:WPA;S:$SSID;P:$(cat "$TXTFILE");;"
which gedit >/dev/null && gedit "$TXTFILE" &
which eog >/dev/null && eog "$SVGFILE" &
disown

chmod 600 "$TXTFILE" "$SVGFILE"
echo "The new passphrase for '$SSID' has been written to '$TXTFILE'"
echo "and the QR code has been written to '$SVGFILE'."
echo "*** Please keep these files in a safe place! ***"
