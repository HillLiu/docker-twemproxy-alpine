ARG VERSION=${VERSION:-[VERSION]}

FROM alpine:3.15 as builder

ARG VERSION

# apk
COPY ./install-packages.sh /usr/local/bin/install-packages
RUN apk update && apk add bash bc \
  && INSTALL_VERSION=$VERSION install-packages \
  && rm /usr/local/bin/install-packages;

FROM alpine:3.15
COPY --from=builder /usr/local/sbin/nutcracker /usr/local/bin/nutcracker
COPY entrypoint.sh /usr/local/bin/

EXPOSE 8888
ENTRYPOINT ["entrypoint.sh"]
CMD ["server"]
