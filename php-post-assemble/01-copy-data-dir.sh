#!/bin/bash

# Since the data directory will be overwritten by the data dir persistent volume, move to a temp dir for now.

mkdir -p /tmp
mv $APP_DATA/data /tmp
