#!/bin/bash

rm -rf dist
rm -rf packages

ln -s /dist dist
ln -s /packages packages

./build-wheel.py --python 3.11 --abi "${ABI}" "${PACKAGE}"
