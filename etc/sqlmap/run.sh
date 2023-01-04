#!/bin/bash
#This script runs sqlmap tool
#arguments <WORKSPACE> <URL>

usage() { echo "Usage: $0 -w <workspace> -u <url>" 1>&2; exit 0; }

while getopts ":w:u:" flags; do
        case "${flags}" in
                w)
                        workspace=${OPTARG}
                        ;;
                u)
                        url=${OPTARG}
                        ;;
                *)
                        usage
                        ;;
        esac
done
shift $((OPTIND-1))

sanitized_url=$(sed -e "s/[^A-Za-z0-9._-]/_/g" <<< "$url")

BLACKOPS_DATA_FOLDER="${BLACKOPS_HOMEDIR}/data"
OUTPUT_ORG_FOLDER="${BLACKOPS_DATA_FOLDER}/${workspace}"
OUTPUT_EXPLOITING_FOLDER="${OUTPUT_ORG_FOLDER}/exploiting"
OUTPUT_FILENAME="sqlmap.out.${sanitized_url::64}.$(date +'%Y_%m_%dT%H_%M_%S').txt"

if [ -z "${workspace}" ] || [ -z "${url}" ]; then
        usage
fi

if [ -z "${BLACKOPS_HOMEDIR}" ]; then
        echo "envvar \"BLACKOPS_HOMEDIR\" is not set. Did you setup the environment with makefile?"
        exit 1
fi

if ! [ -d "${BLACKOPS_DATA_FOLDER}" ]; then
        echo "\"${BLACKOPS_DATA_FOLDER}\" does not exist. Did you setup the environment with makefile?"
        exit 1
fi

if ! [ -d "${OUTPUT_ORG_FOLDER}" ]; then
        echo "\"${OUTPUT_ORG_FOLDER}\" does not exist. Creating."
        if ! [ -w "${BLACKOPS_DATA_FOLDER}" ]; then
                echo "Can't create \"${OUTPUT_ORG_FOLDER}\". Missing write permission.  Exiting."
                exit 1
        else
                mkdir "${OUTPUT_ORG_FOLDER}"
        fi
fi

if ! [ -d "${OUTPUT_EXPLOITING_FOLDER}" ]; then
        echo "\"${OUTPUT_EXPLOITING_FOLDER}\" does not exist. Creating."
        if ! [ -w "${OUTPUT_ORG_FOLDER}" ]; then
                echo "Can't create \"${OUTPUT_EXPLOITING_FOLDER}\". Missing write permission.  Exiting."
                exit 1
        else
                mkdir "${OUTPUT_EXPLOITING_FOLDER}"
        fi
fi

#run:
sqlmap -u "${url}" --random-agent --level 5 --risk 3 --current-user --current-db --skip-waf --time-sec 2 --batch > "${OUTPUT_EXPLOITING_FOLDER}/${OUTPUT_FILENAME}"
bzip2 -z "${OUTPUT_EXPLOITING_FOLDER}/${OUTPUT_FILENAME}"
rm -rf ~/.local/share/sqlmap
