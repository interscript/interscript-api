FROM lambci/lambda:20200812-build-ruby2.7 as builder

ARG INTERSCRIPT_GEM_VERSION
RUN echo "using INTERSCRIPT_GEM_VERSION=$INTERSCRIPT_GEM_VERSION"

ADD Gemfile .
RUN bundle config set path "/ruby"
RUN bundle install --without=development --jobs 4 --retry 3

RUN echo "install python libs"

RUN PYTHONUSERBASE=/lambda/lib/python3.7 pip3 install --user install \
  setuptools \
  numpy \
  git+https://github.com/sequitur-g2p/sequitur-g2p@9b7c505

# ruby/gems/2.7.0/gems
FROM lambci/yumda:2 as yumda

RUN yum install -y \
  python3 \
  pip3 \
  swig \
  python3-setuptools

COPY --from=builder /lambda /lambda
COPY --from=builder /ruby /lambda/opt/ruby/gems
# COPY --from=builder "/lambda/ruby" "/lambda/opt/ruby/gems"
#RUN cd /lambda/opt
#RUN zip -r ../libs.zip .



#COPY --from=builder "/lambda/ruby" "/lambda/opt/ruby/gems"

#RUN pip3 install setuptools numpy \
#    pip3 install git+https://github.com/sequitur-g2p/sequitur-g2p@9b7c505

#FROM lambci/lambda:20200812-build-ruby2.7 as builder
#
#ADD Gemfile .
#RUN bundle config set path "/lambda"
#RUN bundle install --without=development --jobs 4 --retry 3
#
#FROM lambci/yumda:2 as yumda
#
#COPY --from=builder "/lambda/ruby" "/lambda/opt/ruby/gems"
#
