#!/usr/bin/env bash
set -x
version=$1
architecture=`uname -m`

case $architecture in
aarch64)
  archive="monero-linux-armv8-$version"
  ;;
armv7l)
  archive="monero-linux-armv7-$version"
  ;;
x86_64)
  archive="monero-linux-x64-$version"
esac

dir="https://downloads.getmonero.org/cli/"

gpg --import binaryfate.asc 

curl -sko hashes.txt https://www.getmonero.org/downloads/hashes.txt
curl -sko "$archive.tar.bz2" "$dir/$archive.tar.bz2"

gpg --verify hashes.txt

sha256sum --ignore-missing --check hashes.txt

tar xvfj "$archive.tar.bz2"
cp monero*/monerod /usr/local/bin/monerod
