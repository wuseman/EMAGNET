#!/usr/bin/env bash

# - iNFO --------------------------------------
#
#   Author: wuseman <wuseman@nr1.nu>
# FileName: emagnet2.sh
# Modified: 2023-07-16 (18:16:13)
# Modified: 2023-08-15 (04:33:23)
#  Version: 3.4.4
#  License: MIT
#
#      iRC: wuseman (Libera/EFnet/LinkNet)
#   GitHub: https://github.com/wuseman/
#
# ----------------------------------------------

### Emagnet dir

emagnetHome="$HOME/emagnet"
emagnetIncoming="$emagnetHome/incoming/"
emagnetIncomingDaily="$emagnetHome/incoming/$(date +%Y-%m-%d)"
emagnetIncomingTemp="$emagnetHome/incoming/$(date +%Y-%m-%d)/.temp"
emagnetIncomingLog="$emagnetHome/logs/logins-$(date +%Y-%m-%d).log"
emagnetLoginDaily="$emagnetHome/logs/$(date +%Y-%m-%d)"
emagnetWebPath="$emagnetHome/websites/"
stealerHome="$HOME/emagnet/stealer"
sourcePath="/mnt/usb/telegram"

### Stealer path

stealerPasswords="/tmp/emagnet"
stealerAutofills="$stealerHome/autofill-files"
stealerCookies="$stealerHome/cookie-files"
stealerArhciveAll="$stealerHome/archive-all"
stealerWallets="$stealerHome/wallets-all"

emagnet_create_dirs() {
        declare -A directories=(
                [emagnetHome]="$HOME/emagnet"
                [emagnetIncoming]="${emagnetHome}/incoming/"
                [emagnetIncomingDaily]="${emagnetHome}/incoming/$(date +%Y-%m-%d)"
                [emagnetIncomingTemp]="${emagnetHome}/incoming/$(date +%Y-%m-%d)/.temp"
                [passwordDir]="${emagnetHome}/stealer/password-files"
                [screenshotDir]="${emagnetHome}/stealer/screenshot-files"
                [cookiesDir]="${emagnetHome}/stealer/cookie-files"
                [emagnetLoginDaily]="${emagnetHome}/logs/$(date +%Y-%m-%d)"
                [stealerSource]="/mnt/usb/telegram"
                [crackedAccounts]="$emagnetHome/cracked-accounts"
        )

        create_directory() {
                if [ ! -d "$1" ]; then
                        mkdir -p "$1"
                fi
        }

        for dir in "${!directories[@]}"; do
                create_directory "${directories[$dir]}"
        done

}

emagnetRequirements() {
        command_list=("wget2" "rg" "curl" "rga" "elinks" "grep" "unzip" "unrar" "parallel")

        for command in "${command_list[@]}"; do
                if ! command -v "$command" >/dev/null 2>&1; then
                        echo "$command is not installed. Please install $command to continue."
                        exit 1
                fi
        done
}

emagnet_banner() {
        MIN_WIDTH=64
        TERMINAL_WIDTH=$(tput cols)
        if [ "$TERMINAL_WIDTH" -ge "$MIN_WIDTH" ]; then

                cat <<"EOF"

     _                      _______                      _
  _dMMMb._              .adOOOOOOOOOba.              _,dMMMb_
 dP'  ~YMMb            dOOOOOOOOOOOOOOOb            aMMP~  `Yb
 V      ~"Mb          dOOOOOOOOOOOOOOOOOb          dM"~      V
          `Mb.       dOOOOOOOOOOOOOOOOOOOb       ,dM'
           `YMb._   |OOOOOOOOOOOOOOOOOOOOO|   _,dMP'
      __     `YMMM| OP'~"YOOOOOOOOOOOP"~`YO |MMMP'     __
    ,dMMMb.     ~~' OO     `YOOOOOP'     OO `~~     ,dMMMb.
 _,dP~  `YMba_      OOb  (x) `OOO' (x)  dOO      _aMMP'  ~Yb._
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
        fi
}

nothingFound() {

        noNewFiles=(
                "Empty vault. You're the hacker now!"
                "Zero files discovered. Hack your own destiny!"
                "No footprints. Hack the world on your terms!"
                "Nothing to infiltrate. Rewrite the digital game!"
                "No targets. Become the ultimate hacker!"
                "Zero files. Embrace the challenge, be the hacker!"
                "Nothing to download. Create your own hacking path!"
                "Zero traces. Rewrite your destiny, be the hacker!"
                "Zero files found... Hackers take a day off too!"
                "Nothing to download, hackers working for you!"
                "No digital footprints. Hackers need a break too!"
                "No targets detected. Hackers await new challenges!"
                "Nothing to download. Today, hackers rest their minds."
                "Hackers at work. Nothing to download!"
                "The hackers' tools are rendered useless, nothing found"
                "Nothing to infiltrate. The hackers' empire crumbles."
                "Zero files discovered. Hackers in standby mode, try again soon"
        )

        index=$((RANDOM % ${#noNewFiles[@]}))
        message=${noNewFiles[$index]}

        echo -ne "$message\033[0K\r"
        sleep 2
        echo -ne "\033[2K\r"
}

startMesssage() {
        progressMessage=(
                "Hold on, we're about to reveal something!"
                "Analyzing data, seeking the truth..."
                "Just a moment, the magic is about to happen..."
                "Searching the depths for valuable information..."
                "Stay patient, we're unlocking secrets for you!"
                "Unleashing the power of EMAGNET, stand by..."
                "Hold your breath, the results are coming soon!"
                "Uncovering digital gems, stay tuned..."
                "Please wait, analyzing recent leaks..."
                "Analyzing in progress..."
                "Hold on, we're on the hunt!"
                "Emagnet: Locked and loaded."
                "Gear up: The ultimate hacking quest starts now!"
                "Emagnet activated. Re-loaded... Get ready!"
        )

        index=$((RANDOM % ${#progressMessage[@]}))
        message=${progressMessage[$index]}

        echo -ne "$message\033[0K\r"
        sleep 2
}

continueMessage() {
        goForIt=(
                "Hacking made easier than stealing candy from a kid!"
                "So simple, even your grandmother could run me!"
                "Hold tight, the answer you seek is just around the corner."
                "You may not be the master, but I am the auto-master!"
                "Bringing hacking prowess that operates on autopilot."
                "You don't have to wait, run me in cron and lay back!"
                "Stealing for you, taking care of business."
                "You may not be the master, but I am the auto-master!"
                "Take a walk, put me in your pocket!"
                "Searching for what you desire."
                "Uncovering recent leaks to fulfill your request."
                "Seeking to discover the secrets you're after."
                "Analyzing recent leaks to deliver what you want."
                "Scanning through the digital maze to locate your desired information."
                "Determined to find exactly what you want."
                "Unleashing the power of EMAGNET to reveal the truth."
        )

        index=$((RANDOM % ${#progressMessage[@]}))
        message=${progressMessage[$index]}

        echo -ne "$message\033[0K\r"
        sleep 2
}

emagnetGet() {
        emagnetFetch1() {
                wget2 -qO- https://datacloud.space/forums/-/index.rss | awk 'match($0, /https.*upload.ee\/files.*txt.html/) {
            url = substr($0, RSTART, RLENGTH); gsub(/["<]/, "", url); urls[url]}
            END {for (url in urls) print url}' |
                        xargs -P5 curl -sL |
                        grep -o 'd_l.*href="[^"]*"' |
                        grep -o 'https://[^[:space:]]*' |
                        cut -d'"' -f1
        }
        emagnetFetch1
}

emagnetMain() {
        startMesssage
        emagnet_create_dirs
        mkdir -p $emagnetIncomingTemp

        tempFile1=$(mktemp)
        tempFile2=$(mktemp)

        start=$(date +%s.%3N)
        emagnetGet >"$tempFile1"

        mapfile -t diff1 < <(awk -F/ '{print $NF}' $tempFile1)
        mapfile -t diff2 < <(find $emagnetIncomingDaily -type f -not -path "*$emagnetIncomingTemp*" -exec basename {} \;)

        IFS=$'\n' sorted_diff1=($(sort <<<"${diff1[*]}"))
        IFS=$'\n' sorted_diff2=($(sort <<<"${diff2[*]}"))

        mapfile -t diff3 < <(comm -23 <(printf '%s\n' "${sorted_diff1[@]}") <(printf '%s\n' "${sorted_diff2[@]}"))

        for i in "${diff3[@]}"; do
                grep -F "$i" $tempFile1
        done >"$tempFile2"

        if [[ ! -s $tempFile2 ]]; then
                nothingFound
        else
                continueMessage
                #   | parallel -j 10 --progress wget --no-check-certificate -nc -P "$emagnetIncomingTemp" {}
                cat $tempFile2 | xargs -P "$(xargs --show-limits -s 1 2>&1 | grep -i "parallelism" | awk '{print $8}')" -n 1 \
                        wget -q -I{} --no-check-certificate -nc -P "$emagnetIncomingTemp" {} >/dev/null

                totalFiles=$(ls $emagnetIncomingTemp | wc -l)
                logins=$(rg -N "\b[a-zA-Z0-9.#?$*_-]+@[a-zA-Z0-9.#?$*_-]+.[a-zA-Z0-9.-]+\b" $emagnetIncomingTemp | wc -l)
                end=$(date +%s.%3N)
                duration=$(awk "BEGIN {printf \"%.2f\", ${end} - ${start}}")

                loginsFormatted=$(printf "%'d" "$logins")

                variations=(
                        "Emagnet: Legends never die! ${totalFiles} files captured, ${loginsFormatted} logins secured in ${duration}s.\033[0K\r"
                        "Legends may sleep, but Emagnet never dies! ${totalFiles} files reclaimed, ${loginsFormatted} logins unleashed in ${duration}s.\033[0K\r"
                        "Emagnet is unstoppable, ${totalFiles} files and ${loginsFormatted} logins victorious in ${duration}s.\033[0K\r"
                        "Emagnet pwns the hackers: ${totalFiles} files seized, ${loginsFormatted} logins under our control, in just ${duration}s.\033[0K\r"
                        "Stealing from the hackers: ${totalFiles} files reclaimed, ${loginsFormatted} logins captured, in ${duration}s.\033[0K\r"
                        "Retribution: ${totalFiles} files reclaimed, ${loginsFormatted} logins captured, in ${duration}s.\033[0K\r"
                        "Digital justice served: ${totalFiles} files recovered, ${loginsFormatted} logins reclaimed, in ${duration}s.\033[0K\r"
                        "Hackers meet their match: ${totalFiles} files intercepted, ${loginsFormatted} logins compromised, in ${duration}s.\033[0K\r"
                        "Stealing from stealers: ${totalFiles} files reclaimed, ${loginsFormatted} logins captured in ${duration}s.\033[0K\r"
                        "Masters of the hack: ${totalFiles} files controlled, ${loginsFormatted} logins and domination in ${duration}s.\033[0K\r"
                        "Hacking hackers: ${totalFiles} files infiltrated, ${loginsFormatted} logins compromised in ${duration}s.\033[0K\r"
                        "Emagnet's reign: ${totalFiles} files seized, ${loginsFormatted} logins captured in ${duration}s.\033[0K\r"
                        "Defying hackers: ${totalFiles} files reclaimed, ${loginsFormatted} logins in ${duration}s.\033[0K\r"
                )

                for ((i = ${#variations[@]} - 1; i > 0; i--)); do
                        j=$((RANDOM % (i + 1)))
                        temp=${variations[i]}
                        variations[i]=${variations[j]}
                        variations[j]=$temp
                done

                echo -ne "$variations"
                sleep 4
                echo -ne "\033[2K\r"

                mv $emagnetIncomingTemp/* $emagnetIncomingDaily
        fi
}

whatismyip() {
        local ip_address=""

        if [ -n "$proxy_type" ] && [ -n "$proxy_address" ] && [ -n "$proxy_port" ]; then
                echo -e "IP: ip_address=$(curl --socks5 "$proxy_address:$proxy_port" -s ifconfig.co)"
        else
                echo -e "IP: ip_address=$(curl -s ifconfig.co)"
        fi
        echo "$ip_address"
}

scriptName=$(basename "$0")

displayUsage() {
        echo "Usage: $scriptName [options]"

        echo "Options:"

        echo "  -h, --help                 Display this help message"
        echo "  -i, --ip                   Display your IP address"
        echo "  -e, --emagnet              Run EMAGNET once and stop"
        echo "  -q, --quiet                Run EMAGNET without banner"
        echo "  -t <seconds>               Run EMAGNET continuously until stopped, retrying every <second>"
        echo "  -m, --mirror               Prompt for login, convert to wget2, and start mirroring"
        echo "  -v, --version              Print current version"
        echo " "
        echo "  -x, --extract              Extract RAR and ZIP files to folders"
        echo "                             - Options: all, passwords, cookies, autofills, screenshots, wallets"
        echo "  -l, --list <category>      List files from archive or extract by category:"
        echo "                             - Options: all, passwords, cookies, autofills, screenshots, wallets"

}

scriptName=$(basename "$0")

while [[ $# -gt 0 ]]; do
        case $1 in
        -i | --ip)
                whatismyip
                exit 0
                ;;
        -e | --e)
                if [[ "$*" == *"-q"* ]]; then
                        emagnetMain
                else
                        emagnet_banner
                        emagnetMain
                fi
                shift
                ;;
        -t)
                while true; do
                        if [[ $2 =~ ^[0-9]+$ ]]; then
                                countdown=$(($2))
                                emagnet_banner
                                emagnetMain
                                while [[ $countdown -gt 0 ]]; do
                                        echo -ne "Countdown: $countdown seconds\033[0K\r"
                                        sleep 1
                                        ((countdown--))
                                        clear
                                done
                        fi
                done
                ;;
        -m | --mirror)
                clear
                emagnet_banner
                if [[ -d "$HOME\/emagnet\/websites/g" ]]; then
                        mkdir -p $HOME\/emagnet\/websites/g
                fi
                echo "This is fun for us, not for them!"
                read -p "Enter your curl command: " curl_command
                wget_command=$(echo "$curl_command" | sed -e 's/curl/wget2 --progress=bar --mirror --recursive --max-threads 250 --no-clobber --robots off -P $HOME\/emagnet\/websites/g' \
                        -e 's/-H/--header/g' \
                        -e 's/--data-raw/--post-data/g' \
                        -e 's/--compressed//g')
                echo "$wget_command" | bash -
                ;;
        -h | --help)
                displayUsage
                exit 0
                ;;
        *)
                echo "Invalid option:"
                exit 1
                ;;
        esac
        shift
done

if [[ -z $1 ]]; then displayUsage; fi
