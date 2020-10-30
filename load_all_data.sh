#! /bin/bash

if [ x$1 == xlocal ]
then
    ARG_DATA_SOURCE=local 
elif [ x$1 == xremote ]
then
    ARG_DATA_SOURCE=remote 
else
	echo "ERROR: Please provide the data source ('local' or 'remote'): ./load_data.sh <data-source> <track> <variant>"
	exit
fi

if [ $ARG_DATA_SOURCE == remote ]
then
    rm -rf ./temp/$AWS_S3_FOLDER
    aws s3 sync s3://nahtourband ./temp
fi

if [ ! -d ./temp/$AWS_S3_FOLDER ]
then
	echo "ERROR: Expcted to find picture folder '$AWS_S3_FOLDER' in ./temp/"
	exit
fi

if [ ! -z "${2//[0-9]}" ]
then
	echo "ERROR: Track number $2 is not a number"
	exit
fi

ARG_TRACK=$2

if [ x$3 == x ]
then
	echo "ERROR: Please provide the variant number (e.g. 0): ./load_data.sh <filename> <track> <variant>"
	exit
fi

if [ ! -z "${3//[0-9]}" ]
then
	echo "ERROR: Variant number $3 is not a number"
	exit
fi

ARG_VARIANT=$3

cd ./temp/$AWS_S3_FOLDER

find . -exec ../../load_data.sh {} $ARG_TRACK $ARG_VARIANT \;

cd ../..
