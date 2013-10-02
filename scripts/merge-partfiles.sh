#!/bin/sh
cd output/$1

for d in `ls part*`; do ( cat $d >> ../$1.csv ); done
