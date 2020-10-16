#! /bin/bash

if [ x$1 == x ]
then
	echo "ERROR: Please provide the filename (e.g. IMG_6763.jpg): ./load_data.sh <filename> <track> <variant>"
	exit
fi

ARG_FILENAME=`basename $1`


if [ x$2 == x ]
then
	echo "ERROR: Please provide the track number (e.g. 1): ./load_data.sh <filename> <track> <variant>"
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

# Download to extract exif data

curl -X GET ${AWS_S3_BASE_URL}${ARG_FILENAME} --output temp.jpeg
read -r VAR_LAT VAR_LON <<<$(exiftool -gpslatitude -gpslongitude -n -T temp.jpeg)
rm temp.jpeg

# Upload data to 

curl -v -X POST https://api.airtable.com/v0/${AIRTABLE_BASE_NAME}/${AIRTABLE_TABLE_NAME} \
  -H "Authorization: Bearer ${AIRTABLE_API_KEY}" \
  -H "Content-Type: application/json" \
  --data '{
  "records": [
    {
      "fields": {
        "Work-order": "TODO",
        "Photo": [
          {
            "url": "'$AWS_S3_BASE_URL''$ARG_FILENAME'"
          }
        ],
        "Status": "New",
        "Sign-addon": 0,
        "Sign-ntb-add": 0,
        "Sign-ntb-remove": 0,
        "Sign-lat": '${VAR_LAT}',
        "Sign-lon": '${VAR_LON}',
        "ntb-track": '${ARG_TRACK}',
        "ntb-variant": '${ARG_VARIANT}'
      }
    }
  ]
}'

echo $AIRTABLE_API_KEY

