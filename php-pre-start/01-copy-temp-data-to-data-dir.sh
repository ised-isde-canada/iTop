#!/bin/bash

echo "Copy initial files into data dir if they don't exist."

if [  -f $APP_DATA/data/index.php ]
then
    echo "Data exists, skip copying default data."
else
    echo "Data dir empty.  Copy default data."
    cp -r /tmp/data $APP_DATA
fi
