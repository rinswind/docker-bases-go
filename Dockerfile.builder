FROM golang:1.20-alpine

# Git is required for fetching the dependencies.
RUN apk update && \
    apk add --no-cache git

# Copy code into builder
RUN mkdir /app

ONBUILD WORKDIR /app

# Fetch dependencies
ONBUILD COPY go.mod .
ONBUILD COPY go.sum .
ONBUILD RUN go mod download
ONBUILD RUN go mod verify

ONBUILD ARG target_arg=./cmd/main.go
ONBUILD ENV TARGET=${target_arg}

# Build statically linked app
ONBUILD COPY . .
ONBUILD RUN GOWORK=off CGO_ENABLED=0 go build -ldflags="-extldflags=-static" -o app $TARGET
