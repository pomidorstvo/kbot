APP=kbot
REGISTRY=hub.docker.com/repository/docker/pomidorstvo/kbot
VERSION := $(shell git describe --tags --abbrev=0)-$(shell git rev-parse --short HEAD)
TARGETOS=linux
TARGETARCH=amd64


arm:    armrun armbuild armpush armclean
armrun:
	CGO_ENABLED=0 GOOS=linux GOARCH=arm go build -v -o kbot -ldflags "-X 'git@github.com:pomidorstvo/kbot/cmd.appVersion=${VERSION}'" 
armbuild:
	docker build . -t ${REGISTRY}${APP}:${VERSION}-arm
armpush:
	docker push ${REGISTRY}${APP}:${VERSION}-arm
armclean:
	docker rmi ${REGISTRY}${APP}:${VERSION}-arm


linux:  linuxrun linuxbuild linuxpush
linuxrun:
	CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -o kbot -ldflags "-X 'git@github.com:pomidorstvo/kbot/cmd.appVersion=${VERSION}'"
linuxbuild:
	docker build . -t ${REGISTRY}${APP}:${VERSION}-nix
linuxpush:
	docker push ${REGISTRY}${APP}:${VERSION}-nix
linuxclean:
	docker rmi ${REGISTRY}${APP}:${VERSION}-nix


windows: winrun winbuild winpush winclean
winrun:
	CGO_ENABLED=0 GOOS=windows GOARCH=amd64 go build -v -o kbot -ldflags "-X 'git@github.com:pomidorstvo/kbot/cmd.appVersion=${VERSION}'"
winbuild:
	docker build . -t ${REGISTRY}${APP}:${VERSION}-win
winpush:
	docker push ${REGISTRY}${APP}:${VERSION}-win
winclean:
	docker rmi ${REGISTRY}${APP}:${VERSION}-win


macos:  macosrun macosbuild macospush macclean
macosrun:
	CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -v -o kbot -ldflags "-X 'git@github.com:pomidorstvo/kbot/cmd.appVersion=${VERSION}'"
macosbuild:
	docker build . -t ${REGISTRY}${APP}:${VERSION}-mac
macospush:
	docker push ${REGISTRY}${APP}:${VERSION}-mac
macclean:
	docker rmi ${REGISTRY}${APP}:${VERSION}-mac


format:
	gofmt -s -w ./
lint:
	golint
test:
	go test -v
get:
	go get
build: format get
	CGO_ENABLED=0 GOOS=${TARGETOS} GOARCH=${TARGETARCH} go build -v -o kbot -ldflags "-X 'git@github.com:pomidorstvo/kbot/cmd.appVersion=${VERSION}'"
image:
	docker build . -t ${REGISTRY}${APP}:${VERSION}-${GOARCH}
push:
	docker push ${REGISTRY}${APP}:${VERSION}-${GOARCH}
clean:
	rm -f kbot
