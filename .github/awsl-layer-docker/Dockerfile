FROM lambci/lambda:20200812-build-ruby2.7 as builder

RUN PYTHONUSERBASE=/lambda/lib/python3.7 pip3 install --user install \
  setuptools \
  numpy \
  git+https://github.com/sequitur-g2p/sequitur-g2p@9b7c505


FROM lambci/yumda:2 as yumda

RUN yum install -y \
  python3 \
  pip3 \
  swig \
  python3-setuptools

COPY --from=builder /lambda/ /lambda/opt

#RUN pip3 install setuptools numpy \
#    pip3 install git+https://github.com/sequitur-g2p/sequitur-g2p@9b7c505
