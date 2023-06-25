#!/bin/bash
inputbox(){
    INPUTTL=''
    while [ -z $INPUTTL ]
    do
       INPUTTL=$(whiptail --title "${1:-KunTower}" --inputbox "${2:-}" 10 60 "${3:-}" 3>&1 1>&2 2>&3)
    done
    echo $INPUTTL
}

inputpass() {
    PSDTL=$(whiptail --title "${1:KunTower}" --passwordbox "${2:-}" 3>&1 1>&2 2>&3 10 60)
    echo $PSDTL
}

inputcos() {
    COS=$(whiptail --title "${1:-KunTower}" --yes-button "${3:-yes}" --no-button "${4:-no}" --yesno "${2:-}" 10 60 3>&1 1>&2 2>&3) 
}
