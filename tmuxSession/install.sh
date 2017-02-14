#!/bin/bash

if [ "$#" -ne 2 ]; then
	echo "usage: ./install.sh <script> <install location>"
	exit 1
fi

bin=$(readlink -fn $1)
iloc=$(readlink -fn $2)"/"
ibin="$iloc"$(echo $bin | sed 's/.*\///g')

diff -q $bin $ibin &>/dev/null
if [ "$?" -eq 0 ]; then
	echo "already installed."
	exit 1
fi

sudo cp -i $bin $iloc
sudo chown root:root $ibin
sudo chmod 755 $ibin
