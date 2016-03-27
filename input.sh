#!/bin/bash

while [ 1 ];do
echo $(((RANDOM%6) + 1)) > stream
sleep 1
done;


