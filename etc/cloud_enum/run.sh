#!/bin/bash
#This script runs cloud_enum tool
#arguments <WORKSPACE> <DOMAIN>

usage() { echo "Usage: $0 -w <workspace> -d <domain>" 1>&2; exit 0; }

while getopts ":w:d:" flags; do
	case "${flags}" in
		w)
			workspace=${OPTARG}
			;;
		d)
			domain=${OPTARG}
			;;
		*)
			usage
			;;
	esac
done
shift $((OPTIND-1))

BLACKOPS_DATA_FOLDER="${BLACKOPS_HOMEDIR}/data"
OUTPUT_ORG_FOLDER="${BLACKOPS_DATA_FOLDER}/${workspace}"
OUTPUT_RECON_FOLDER="${OUTPUT_ORG_FOLDER}/reconnaissance"
OUTPUT_FILENAME="cloud_enum.out.${domain}.$(date +'%Y_%m_%dT%H_%M_%S').json"

if [ -z "${workspace}" ] || [ -z "${domain}" ]; then
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

if ! [ -d "${OUTPUT_RECON_FOLDER}" ]; then
        echo "\"${OUTPUT_RECON_FOLDER}\" does not exist. Creating."
        if ! [ -w "${OUTPUT_ORG_FOLDER}" ]; then
                echo "Can't create \"${OUTPUT_RECON_FOLDER}\". Missing write permission.  Exiting."
                exit 1
        else
                mkdir "${OUTPUT_RECON_FOLDER}"
        fi
fi


#run:
python3 bin/cloud_enum.py -k ${domain} -t 10 -f json -l "${OUTPUT_RECON_FOLDER}/${OUTPUT_FILENAME}"
#compress output (saving space ftw!)
bzip2 -z "${OUTPUT_RECON_FOLDER}/${OUTPUT_FILENAME}"
