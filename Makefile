all:
	docker build . -t silverstripe/platform-build-yarn:latest

push:
	docker push silverstripe/platform-build-yarn
