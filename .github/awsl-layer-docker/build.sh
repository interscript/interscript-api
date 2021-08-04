#!/bin/sh

rm -Rf ./libs
cp ../../Gemfile Gemfile

docker build  --no-cache \
  --build-arg INTERSCRIPT_GEM_VERSION=${GEM_VERSION} \
  -t interscript-lambda .

id=$(docker create interscript-lambda)
docker cp "${id}":/lambda/opt/ ./libs
docker rm -v "${id}"
cd ./libs
zip -r ../libs.zip .
cd -

#rm -Rf ./libs
#cp ../../Gemfile Gemfile
#
#docker build --no-cache -t lambda .
#id=$(docker create lambda)
#docker cp "${id}":/lambda/opt/ ./libs
#docker rm -v "${id}"
#cd ./libs
#zip -r ../libs.zip "ruby"
#cd -
