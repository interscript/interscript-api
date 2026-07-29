FROM public.ecr.aws/sam/build-ruby:3.4 AS builder

ARG INTERSCRIPT_GEM_VERSION
RUN echo "using INTERSCRIPT_GEM_VERSION=$INTERSCRIPT_GEM_VERSION"

ADD Gemfile .
RUN bundle config set path "/vendor"
RUN bundle install --without=development --jobs 4 --retry 3

FROM public.ecr.aws/sam/build-ruby:3.4 AS yumda

COPY --from=builder /vendor/ruby /lambda/opt/ruby/gems/
