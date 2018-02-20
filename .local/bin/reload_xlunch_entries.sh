#!/bin/bash

REP_CUSTOM_DESKTOPFILES=$HOME/.local/share/applications
REP_SNAPD_DESKTOPFILES=/var/lib/snapd/desktop/applications
REP_USUALS_DESKTOPFILES=/usr/share/applications
ENTRIES_SOURCE=/etc/xlunch/entries.dsv
ENTRIES_DEST=$HOME/.config/xlunch/entries.dsv

function get_value(){
	grep $1 "$2/$3" | cut -d= -f2-
}

if [ ! -d $HOME/.config/xlunch ]; then
    mkdir -p $HOME/.config/xlunch
fi

/usr/bin/genentries 

cat $ENTRIES_SOURCE > ${ENTRIES_DEST}.tmp

for REP in ${REP_SNAPD_DESKTOPFILES}; do 
    for FILE in $(ls ${REP}); do
        echo $(get_value "Name=" ${REP} $FILE)";"$(get_value "Icon=" ${REP} $FILE)";"$(get_value Exec ${REP} $FILE) >> ${ENTRIES_DEST}.tmp
    done
done


cat ${ENTRIES_DEST}.tmp | sort -n | uniq > $ENTRIES_DEST
