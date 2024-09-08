
init:
	terraform init -backend-config=backend.conf

plan: 
	terraform plan

apply: 
	terraform apply

build-lambda:
	cd lambdas/go-apigw && make build
	
bench-lambdas: 
	cd benchmarking && make bench-lambda-runtimes