FROM golang:alpine

# Git is required for fetching the dependencies.
RUN apk update && \
    apk add --no-cache git

# Copy code into builder
RUN mkdir /app
ONBUILD COPY . /app

ONBUILD WORKDIR /app

# Fetch dependencies
ONBUILD RUN go mod download
ONBUILD RUN go mod verify

ONBUILD ARG target_arg=./cmd/main.go
ONBUILD ENV TARGET=${target_arg}

# Build statically linked app
ONBUILD RUN CGO_ENABLED=0 go build -ldflags="-extldflags=-static" -o app $TARGET
