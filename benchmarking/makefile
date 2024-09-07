GO = go
BUILD_DIR = bin

build: 
	${GO} build -o $(BUILD_DIR)/bench-lambda-runtimes cmd/lambda-runtimes/*.go

bench-lambda-runtimes:
	${GO} run cmd/lambda-runtimes/*.go --config cmd/lambda-runtimes/config.sample.json
