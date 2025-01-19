#!/usr/bin/env bash

# - iNFO --------------------------------------
#
#   Author: wuseman <wuseman@nr1.nu>
# FileName: stealer-cookies.to.json.sh
#  Created: 2023-08-16 (10:47:08)
# Modified: 2023-08-16 (10:47:57)
#  Version: 1.0
#  License: MIT
#
#      iRC: wuseman (Libera/EFnet/LinkNet)
#   GitHub: https://github.com/wuseman/
#
# ---------------------------------------------

input_file=""
output_file=""

usage() {
        echo "Usage: $0 -i <input_file> -o <output_file>"
        echo "Options:"
        echo "  -i <input_file>: Specify the input file containing cookie data."
        echo "  -o <output_file>: Specify the output JSON file to write the organized cookie data."
        echo "  -h: Display this help message."
        echo "  -v: Display the script version."
        exit 1
}

if [[ -z $1 ]]; then
        usage
        exit 1
fi

while getopts "i:o:vh" opt; do
        case $opt in
        i) input_file="$OPTARG" ;;
        o) output_file="$OPTARG" ;;
        v)
                echo "Version 1.0"
                exit 0
                ;;
        h) usage ;;
        \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
        esac
done

if [ -z "$input_file" ]; then
        echo "Input field must be set using the -i option."
        exit 1
fi

if [ -z "$output_file" ]; then
        echo "Output field must be set using the -o option."
        exit 1
fi

declare -A cookies

while IFS=$'\t' read -r line; do
        IFS=$'\t' read -ra fields <<<"$line"
        domain=${fields[0]}
        path=${fields[2]}
        name=${fields[5]}
        value=${fields[6]}

        value=$(echo -n "$value" | tr -d '\r')

        key="$domain$path"
        if [ -z "${cookies[$key]}" ]; then
                cookies[$key]=""
        else
                cookies[$key]="${cookies[$key]},"
        fi
        cookies[$key]="${cookies[$key]}\n    {\n      \"name\": \"$name\",\n      \"value\": \"$value\"\n    }"

done <"$input_file"

echo "{" >"$output_file"

first_domain=true
for domain_path in "${!cookies[@]}"; do
        if [ "$first_domain" = true ]; then
                first_domain=false
        else
                echo "," >>"$output_file"
        fi
        echo "  \"$domain_path\": [" >>"$output_file"
        echo -e "${cookies[$domain_path]}" >>"$output_file"
        echo "  ]" >>"$output_file"
done

echo "}" >>"$output_file"
