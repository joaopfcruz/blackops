#!/bin/bash
#This script runs gospider tool
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
OUTPUT_SCANNING_FOLDER="${OUTPUT_ORG_FOLDER}/scanning"
OUTPUT_FILENAME="gospider_urlessd.out.${sanitized_url}.$(date +'%Y_%m_%dT%H_%M_%S').json"

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
gospider -s ${url} -u web -t 16 --subs --include-other-source --include-subs --sitemap --robots -q | python3 urless/urless.py | egrep -v "^\[url\].*" > "${OUTPUT_SCANNING_FOLDER}/${OUTPUT_FILENAME}"
#compress output (saving space ftw!)
bzip2 -z "${OUTPUT_SCANNING_FOLDER}/${OUTPUT_FILENAME}"
