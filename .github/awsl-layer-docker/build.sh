#!/bin/sh

rm -Rf ./libs
docker build -t interscript-lambda .
id=$(docker create interscript-lambda)
docker cp "${id}":/lambda/opt/ ./libs
docker rm -v "${id}"
