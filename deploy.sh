
bundle config set path 'vendor/bundle'
bundle install

#bundle install --path vendor/bundle
#[DEPRECATED] The `--path` flag is deprecated because it relies on being remembered across bundler invocations,
# which bundler will no longer do in future versions.
# Instead please use `bundle config set path 'vendor/bundle'`, and stop using this flag
