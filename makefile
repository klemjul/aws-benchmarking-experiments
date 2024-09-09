
init-lambda-runtimes:
	cd infrastructure/lambda-runtimes && terraform init -backend-config=backend.conf

plan-lambda-runtimes: 
	cd infrastructure/lambda-runtimes && terraform plan

apply-lambda-runtimes: 
	cd infrastructure/lambda-runtimes && terraform apply

build-lambda-runtimes:
	cd infrastructure/lambda-runtimes && make build-lambdas

bench-lambda-runtimes: 
	cd benchmarking && make bench-lambda-runtimes



init-apigw-latency:
	cd infrastructure/apigw-latency && terraform init -backend-config=backend.conf

plan-apigw-latency: 
	cd infrastructure/apigw-latency && terraform plan

apply-apigw-latency: 
	cd infrastructure/apigw-latency && terraform apply

build-apigw-latency:
	cd infrastructure/apigw-latency && make build-lambda