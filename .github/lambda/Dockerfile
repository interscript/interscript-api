FROM lambci/lambda:20200812-build-ruby2.7 as builder
ARG INTERSCRIPT_GEM_VERSION
RUN echo "using INTERSCRIPT_GEM_VERSION=$INTERSCRIPT_GEM_VERSION"

COPY src .
ENV INTERSCRIPT_GEM_VERSION=${INTERSCRIPT_GEM_VERSION}
ENV GEM_HOME=${LAMBDA_TASK_ROOT}
#RUN echo $LAMBDA_TASK_ROOT
#RUN bundle config set path "/vendor"
RUN bundle install --without=development --jobs 4 --retry 3


FROM public.ecr.aws/lambda/ruby:2.7

ARG INTERSCRIPT_GEM_VERSION
RUN echo "using INTERSCRIPT_GEM_VERSION=$INTERSCRIPT_GEM_VERSION"

ENV DEFAULT_ORIGIN="*"
ENV CORS_ORIGIN_REGEX=""

ENV GEM_HOME=${LAMBDA_TASK_ROOT}
ENV INTERSCRIPT_GEM_VERSION=${INTERSCRIPT_GEM_VERSION}

COPY --from=builder ${LAMBDA_TASK_ROOT} ${LAMBDA_TASK_ROOT}
COPY src ${LAMBDA_TASK_ROOT}
#COPY --from=builder /vendor/ruby/2.7.0/gems ${LAMBDA_TASK_ROOT}/gems
#COPY --from=builder /vendor/ruby/2.7.0/gems /var/lang/lib/ruby/gems/2.7.0/gems
# /var/lang/lib/ruby/gems/2.7.0/gems
# COPY --from=builder /vendor/ruby /var/task/opt/ruby/gems/
CMD [ "lib/interscript-api/lambda_function.handler" ]
