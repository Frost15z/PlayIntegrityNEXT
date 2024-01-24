#su -c "cd /storage/emulated/0 && /system/bin/curl -L "https://raw.githubusercontent.com/daboynb/PlayIntegrityNEXT/main/Fp_Downloader.apk%20to%20use%20with%20play%20integrity%20by%20chiteroman/fp.sh" -o fp.sh && /system/bin/sh fp.sh"

## ANSI Colors thanks to termux-style
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
DEFAULT_FG="$(printf '\033[39m')"  DEFAULT_BG="$(printf '\033[49m')"

## Banner
banner () {
    clear
    echo -e "
    ${GREEN}#########################################################
    ${GREEN}# PIF NEXT https://github.com/daboynb/PlayIntegrityNEXT #
    ${GREEN}#########################################################"

}
banner

echo -e "${GREEN}[+] Looking for installed PIF module"
Author=$(cat /data/adb/modules/playintegrityfix/module.prop | grep "author=" | sed -r 's/author=([^ ]+) ?.*/\1/gi')
echo
if [ -z "$Author" ]; then
    Target="/data/adb/pif.json"
    echo "    Can't detect an installed PIF module! Will use $Targetn"
elif [ "$Author" == "chiteroman" ]; then
    Target="/data/adb/pif.json"
    echo "    Detected chiteroman module. Will use $Target"
elif [ "$Author" == "osm0sis" ]; then
    Target="/data/adb/modules/playintegrityfix/custom.pif.json"
    echo "    Detected osm0sis module. Will use $Target"
else
    Target="/data/adb/pif.json"
    echo "    PIF module found but not recognized! Will use $Target"
fi
echo

echo -e "${GREEN}[+] Deleting old pif"
rm -f $Target > /dev/null 
echo

echo -e "${GREEN}[+] Check if the miui eu inject module is present"
pm disable eu.xiaomi.module.inject > /dev/null 2>&1 && echo -e "${RED}The miui eu inject module is disabled now. YOU NEED TO REBOOT OR YOU WON'T BE ABLE TO PASS DEVICE INTEGRITY!." || true
echo

echo -e "${GREEN}[+] Downloading the new pif"
/system/bin/curl -L http://tinyurl.com/autojson -o $Target > /dev/null 2>&1 || /system/bin/curl -L http://tinyurl.com/autojson -o $Target
if [ "$Author" == "osm0sis" ]; then
    sh /data/adb/modules/playintegrityfix/migrate.sh > /dev/null 2>&1
fi
echo

echo -e "${GREEN}[+] Killing com.google.android.gms"
pkill -f com.google.android.gms > /dev/null 
echo

echo -e "${GREEN}[+] Killing com.google.android.gms.unstable"
pkill -f com.google.android.gms.unstable > /dev/null 
echo

if [ -e $Target ]; then 
    echo -e "${GREEN}[+] Pif installed succesfully"
    echo
    echo -e '${GREEN}[+] File creation Time: 'stat -t -c "%z" $Target' lol '
    echo
    cat  $Target
else 
    echo -e "${GREEN}   +] Pif not present, something went wrong."
fi
echo

rm "$0"
