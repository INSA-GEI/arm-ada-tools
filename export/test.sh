#!/bin/sh
set -e

version=`cat version.txt`

if [ -n "$version" ]
   then if [ "$version" != "" ]
   then echo $version
   else echo version.txt vide
   fi
else echo version.txt vide
fi
