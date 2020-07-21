rm -Rf "$(pwd)/vendor"
bundle config set path "$(pwd)/vendor/bundle"

bundle install --without=test --gemfile="$(pwd)/Gemfile"

#echo 123
#echo "$(pwd)"
