#!/bin/sh

###
# Environment ${INSTALL_VERSION} pass from Dockerfile
###

INSTALL=""

BUILD_DEPS="curl autoconf automake libtool alpine-sdk"

echo "###"
echo "# Will install"
echo "###"
echo ""
echo $INSTALL
echo ""
echo "###"
echo "# Will build package"
echo "###"
echo ""
echo $BUILD_DEPS
echo ""

apk add --virtual .build-deps $BUILD_DEPS && apk add $INSTALL

#/* put your install code here */#

mkdir -p /tmp/twemproxy-src
curl -Lk "https://github.com/twitter/twemproxy/archive/${INSTALL_VERSION}.tar.gz" \
  | tar -xz -C /tmp/twemproxy-src --strip-components=1
cd /tmp/twemproxy-src \
  && autoreconf -fvi && CFLAGS="-ggdb3 -O0" ./configure --enable-debug=full \
  && make \
  && make install

# apk del -f .build-deps && rm -rf /var/cache/apk/* || exit 1

exit 0
