
init:
	terraform init -backend-config=backend.config

plan: 
	terraform plan

apply: 
	terraform apply

build:
	cd lambdas/java && mvn package
	cd lambdas/ts-esbuild && npm run build

bench: 
	cd benchmarking && make bench-lambda-runtimes