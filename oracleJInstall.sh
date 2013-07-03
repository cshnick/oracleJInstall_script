#!/bin/bash
#
#|=============================================
#| A simple script which downloads Oracle Java
#| (you have to specify URL) and installs it
#| directly to x64 system openSuse according
#| to the manual
#| https://sites.google.com/site/easylinuxtipsproject/java-for-opensuse
#|=============================================


EXIT_OK=0
EXIT_FALIURE=663
ORIGIN_USER=`whoami`

wrapMessage() {
  top=${#1}
  let top+=4
  top=`printf %${top}s |tr " " "-"`
  
  echo $top
  echo "| $1 |"
  echo $top 
}

DOWNLOAD_URL="$1"
DESTINATION_DIR=/opt/java/64
DIR_EXTRACTED=jre1.7.0_25
MOZILLA_PLUGIN_DIR=$HOME/.mozilla/plugins

if [ -z $DOWNLOAD_URL ] ; then
  wrapMessage "specify the download link"
  exit $EXIT_FALIURE
fi

#echo Root passowrd...
#su -p

wrapMessage "removing folders..."
echo "Attempt to remove $DESTINATION_DIR. Maybe root priveleges required..."
sudo rm -rv $DESTINATION_DIR
rm -v ~/.mozilla/plugins/libnpjp2.so

TAR_NAME=tmp_jdk.tar.gz
wrapMessage "downloading java..."
wget -r -O "$TAR_NAME" "$DOWNLOAD_URL"
if [ -z $? ] ; then
  echo "error while downloading $DOWNLOAD_URL"
  exit $EXIT_FALIURE
fi
echo "Download finished..."

wrapMessage "extracting java..."
tar -xvzf $TAR_NAME
rm -rf $TAR_NAME
echo "extracting finished..."

wrapMessage "Copying contents..."
echo -e "Attempt to create directory $DESTINATION_DIR \n"\
"maybe root is required..." 
sudo -E mkdir -p -v $DESTINATION_DIR
sudo -E mv -vf $DIR_EXTRACTED $DESTINATION_DIR

wrapMessage "Updating alternatives..."
sudo -E /usr/sbin/update-alternatives --install "/usr/bin/java" "java" "${DESTINATION_DIR}/${DIR_EXTRACTED}/bin/java" 1
sudo -E /usr/sbin/update-alternatives --set java "${DESTINATION_DIR}/${DIR_EXTRACTED}/bin/java"

wrapMessage "Installing mozilla plugin..."
rm -v "$MOZILLA_PLUGIN_DIR/libnpjp2.so"
mkdir -p -v $MOZILLA_PLUGIN_DIR
echo "Creating plugin symlink..."
ln -vs "${DESTINATION_DIR}/${DIR_EXTRACTED}/lib/amd64/libnpjp2.so" "$MOZILLA_PLUGIN_DIR"

exit $EXIT_OK