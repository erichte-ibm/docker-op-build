FROM ubuntu:14.04

# Dependencies from README.md
RUN apt-get update \
	&& apt-get install -y \
	cscope ctags libz-dev libexpat-dev \
	python language-pack-en texinfo \
	build-essential g++ git bison flex unzip \
	libxml-simple-perl libxml-sax-perl libxml2-dev libxml2-utils xsltproc \
	wget bc

RUN mkdir /op-build && mkdir /images

ADD run-build.sh /run-build.sh

ENV REPO "http://github.com/open-power/op-build"
ENV BRANCH "master"
ENV MACHINE "habanero"

CMD ["/run-build.sh"]
