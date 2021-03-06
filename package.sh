#!/bin/sh
BRANCH=`git branch | egrep "\\* (.*)" | cut -c 3-`
DATE=`date +%Y%m%d%H%M`
TARGET_FILENAME="$DATE-$BRANCH.xpi"
GNUFILE=/Users/protz/bin/switchtognuutils

if [ -f "$GNUFILE" ]; then
  . "$GNUFILE";
fi;

template() {
  sed s/__REPLACEME__/$1/ install.rdf.template > install.rdf
}

upload() {
  echo "cd jonathan/files\nput conversations.xpi gcv-nightlies/$TARGET_FILENAME" | ftp xulforum@ftp.xulforum.org
}

if [ -f "content/pdfjs/build/pdf.js" ]; then
  true;
else
  echo "Please run make from content/pdfjs";
  exit 0
fi

if [ "$1" = "official" ]; then
  template "";
  ./build.sh
  upload;
else
  template ."$DATE"pre;
  ./build.sh
  if [ "$1" != "build" ]; then
    upload;
    rm -f conversations.xpi;
  fi;
fi
