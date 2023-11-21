APP=kbot
REGISTRY=pomidorstvo
VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TRGETOS=linux
TARGETARCH=amd64 ##arm64

format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v
get:
	go get
build: format get
	CGO_ENABLED=0 DOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X 'git@github.com:pomidorstvo/kbot/cmd.appVersion=${VERSION}'"
image:
	docker build . -t ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
push:
	docker push ${REGISTRY}/${APP}:${VERSION}-${TARGETARCH}
clean:
	rm -rf kbot
