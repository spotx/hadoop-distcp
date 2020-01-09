#!/bin/bash

set -x

usage() {
  echo "Usage: docker run spotx/hadoop-distcp -a AccessKey -s SecretKey -b S3BucketWithPath"
  exit 1
}

accessKey=""
secretKey=""
s3Bucket=""

# Call getopt to validate the provided input.
options=$(getopt -o ha:b:s: -- "$@")
[ $? -eq 0 ] || {
    echo "Incorrect options provided"
    exit 1
}

eval set -- "$options"

while true; do
    case "$1" in
    -a)
        shift;
        accessKey="$1"
        ;;
    -b)
        shift;
        s3Bucket="$1"
        ;;
    -h)
      usage
      ;;
    -s)
        shift;
        secretKey="$1"
        ;;
    --)
        shift
        break
        ;;
    esac
    shift
done

if [ "${accessKey}" = "" ] || [ "${secretKey}" = "" ] || [ "${s3Bucket}" = "" ]
then
    usage
fi

now="$(date -uIs)"

echo "Test date: "$now > testfile

# all -D params must be first, then pass the distcp specific params (like -overwrite)
hadoop distcp \
  -Dfs.s3a.acl.default=BucketOwnerFullControl \
  -Dfs.s3a.access.key="${accessKey}" -Dfs.s3a.secret.key="${secretKey}" \
  -overwrite \
  testfile s3a://${s3Bucket}

if [ $? -eq 0 ]
then
  echo "[SUCCESS] Test completed successfully."
else
  echo "[ERROR] Test failed."
fi
