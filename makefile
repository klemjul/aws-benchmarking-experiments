
init:
	terraform init -backend-config=backend.conf

plan: 
	terraform plan

apply: 
	terraform apply

build-lambda-java:
	cd lambdas/java && mvn package
build-lambda-ts-esbuild:
	cd lambdas/ts-esbuild && npm run build
build-lambda-go:
	cd lambdas/go && make build
build-lambda-python:
	cd lambdas/python && make build
build-lambda-dotnet:
	cd lambdas/dotnet && make build
build-lambda-kotlin:
	cd lambdas/kotlin && make build-app


build: build-lambda-java build-lambda-ts-esbuild build-lambda-go build-lambda-python build-lambda-dotnet build-lambda-kotlin
	
bench: 
	cd benchmarking && make bench-lambda-runtimes