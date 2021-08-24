#!/bin/sh

## require env "GEM_VERSION"

rm -Rf ./src
mkdir -p ./src

cp ../../Gemfile ./src
cp -Rf ../../lib ./src

docker build  \
  --build-arg INTERSCRIPT_GEM_VERSION=${GEM_VERSION} \
  -t interscript-lambda .

#id=$(docker create interscript-lambda)
#docker cp "${id}":/lambda/opt/ ./libs
#docker rm -v "${id}"
