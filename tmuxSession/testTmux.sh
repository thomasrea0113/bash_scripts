#!/bin/bash

echo $1
echo $2
echo $3


Y=""
while [ "$Y" != "abc" ]; do
	echo "doing..."
	read -t 2 Y
	echo "Read: $Y"
	echo "ERRORS" 1>&2
done
