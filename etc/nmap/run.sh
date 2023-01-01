#!/bin/bash
#This script runs nmap tool
#arguments <WORKSPACE> <TARGET>

usage() { echo "Usage: $0 -w <workspace> -t <target>" 1>&2; exit 0; }

while getopts ":w:t:" flags; do
        case "${flags}" in
                w)
                        workspace=${OPTARG}
                        ;;
                t)
                        target=${OPTARG}
                        ;;
                *)
                        usage
                        ;;
        esac
done
shift $((OPTIND-1))

BLACKOPS_DATA_FOLDER="${BLACKOPS_HOMEDIR}/data"
OUTPUT_ORG_FOLDER="${BLACKOPS_DATA_FOLDER}/${workspace}"
OUTPUT_SCANNING_FOLDER="${OUTPUT_ORG_FOLDER}/scanning"
TMP_OUTPUT_FILENAME="/tmp/nmap.out.${target}.$(date +'%Y_%m_%dT%H_%M_%S').xml"
OUTPUT_FILENAME="nmap.out.${target}.$(date +'%Y_%m_%dT%H_%M_%S').json"

if [ -z "${workspace}" ] || [ -z "${target}" ]; then
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

if ! [ -d "${OUTPUT_SCANNING_FOLDER}" ]; then
        echo "\"${OUTPUT_SCANNING_FOLDER}\" does not exist. Creating."
        if ! [ -w "${OUTPUT_ORG_FOLDER}" ]; then
                echo "Can't create \"${OUTPUT_SCANNING_FOLDER}\". Missing write permission.  Exiting."
                exit 1
        else
                mkdir "${OUTPUT_SCANNING_FOLDER}"
        fi
fi

#run:
sudo nmap -Pn -F --script default,vuln,exploit ${target} -oX "${TMP_OUTPUT_FILENAME}"
nmap2json convert "${TMP_OUTPUT_FILENAME}" > "${OUTPUT_SCANNING_FOLDER}/${OUTPUT_FILENAME}"
#compress output (saving space ftw!)
bzip2 -z "${OUTPUT_SCANNING_FOLDER}/${OUTPUT_FILENAME}"
sudo rm -f "${TMP_OUTPUT_FILENAME}"
