#!/bin/sh

version="v1.0"

pip install -r requirements.txt --target ./packages

cd packages
zip -r9 ../../file-converter-${version}.zip .

cd ../
zip -gr ../file-converter-${version}.zip app/

rm -rf packages