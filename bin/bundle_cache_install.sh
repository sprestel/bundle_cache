#!/bin/sh

ARCHITECTURE=`uname -m`
FILE_NAME="$BUNDLE_ARCHIVE-$ARCHITECTURE.tgz"

cd ~
wget -O "remote_$FILE_NAME" "https://s3.amazonaws.com/$AWS_S3_BUCKET/$FILE_NAME" && tar -xf "remote_$FILE_NAME"
wget -O "remote_$FILE_NAME.sha2" "https://s3.amazonaws.com/$AWS_S3_BUCKET/$FILE_NAME.sha2"

exit 0
