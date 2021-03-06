# Copyright (c) 2020 , Veepee
#
# Permission  to use,  copy, modify,  and/or distribute  this software  for any
# purpose  with or  without  fee is  hereby granted,  provided  that the  above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS  SOFTWARE INCLUDING ALL IMPLIED  WARRANTIES OF MERCHANTABILITY
# AND FITNESS.  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL  DAMAGES OR ANY DAMAGES  WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER  TORTIOUS ACTION,  ARISING OUT  OF  OR IN  CONNECTION WITH  THE USE  OR
# PERFORMANCE OF THIS SOFTWARE.

FROM golang:1.16.5-alpine AS build

ARG JFROG_CLI_VERSION="1.39.0"

RUN apk add --no-cache --quiet \
      ca-certificates \
      git

RUN mkdir -p /go/src/github.com/jfrog && \
    cd /go/src/github.com/jfrog && \
    git clone https://github.com/jfrog/jfrog-cli && \
    cd /go/src/github.com/jfrog/jfrog-cli && \
    git checkout v${JFROG_CLI_VERSION} && \
    sh build/build.sh jfrog-cli

FROM alpine:3.14.0

COPY --from=build /go/src/github.com/jfrog/jfrog-cli/jfrog-cli \
                  /usr/bin/jfrog-cli

RUN ln -s /usr/bin/jfrog-cli /usr/bin/jfrog

CMD [ "jfrog-cli", "--version" ]

HEALTHCHECK NONE
# EOF
