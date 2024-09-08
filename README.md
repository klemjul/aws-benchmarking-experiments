# aws-benchmarking-experiments

A repository for benchmarking AWS-hosted services and managed service performance. Includes comparisons of Lambda runtimes and cold start optimisations, API Gateway latency, and other AWS-related experiments around performances.

## useful commands

- `terraform init -backend-config=backend.conf` or `make init` init terraform backend
- `terraform fmt` reformat your configuration in the standard style
- `terraform validate` check whether the configuration is valid
- `terraform plan` or `make plan` show changes required by the current configuration
- `terraform apply` or `make apply` create or update infrastructure
- `terraform destroy` destroy previously-created infrastructure
- `make build-lambdas` build lambdas code for deployments
- `make bench-lambdas` run go benchmarking arround lambdas

## getting started

1. Prepare an [terraform S3 backend](https://github.com/klemjul/cdk-terraform-backend-s3)
2. Init terraform backend `make init`
3. Build lambdas `make build-lambdas`
4. Deploy lambdas on AWS `make apply`
5. Run benchmarking `make bench-lambdas`

## some results

```txt
+-------------------+-------------+-----------+--------------+---------------+
|   FUNCTIONNAME    | SDKDURATION | DURATION  | INITDURATION | MAXMEMORUUSED |
+-------------------+-------------+-----------+--------------+---------------+
| go-lambda         | 211 ms      | 2.68 ms   | 68.66 ms     | 20 MB         |
| python-lambda     | 218 ms      | 1.82 ms   | 82.49 ms     | 32 MB         |
| ts-esbuild-lambda | 290 ms      | 19.16 ms  | 130.67 ms    | 62 MB         |
| java-lambda       | 696 ms      | 129.22 ms | 415.13 ms    | 98 MB         |
| kotlin-lambda     | 809 ms      | 208.08 ms | 448.78 ms    | 96 MB         |
| dotnet-lambda     | 1288 ms     | 511.46 ms | 478.63 ms    | 65 MB         |
+-------------------+-------------+-----------+--------------+---------------+

+-------------------+-------------+-----------+--------------+---------------+
|   FUNCTIONNAME    | SDKDURATION | DURATION  | INITDURATION | MAXMEMORUUSED |
+-------------------+-------------+-----------+--------------+---------------+
| go-lambda         | 207 ms      | 1.60 ms   | 68.29 ms     | 20 MB         |
| python-lambda     | 254 ms      | 2.10 ms   | 88.14 ms     | 32 MB         |
| ts-esbuild-lambda | 308 ms      | 13.86 ms  | 136.38 ms    | 62 MB         |
| java-lambda       | 648 ms      | 112.84 ms | 407.25 ms    | 96 MB         |
| kotlin-lambda     | 804 ms      | 230.82 ms | 415.06 ms    | 97 MB         |
| dotnet-lambda     | 1279 ms     | 513.07 ms | 493.10 ms    | 65 MB         |
+-------------------+-------------+-----------+--------------+---------------+

+-------------------+-------------+-----------+--------------+---------------+
|   FUNCTIONNAME    | SDKDURATION | DURATION  | INITDURATION | MAXMEMORUUSED |
+-------------------+-------------+-----------+--------------+---------------+
| go-lambda         | 203 ms      | 1.50 ms   | 70.51 ms     | 20 MB         |
| python-lambda     | 249 ms      | 1.80 ms   | 83.98 ms     | 32 MB         |
| ts-esbuild-lambda | 305 ms      | 19.69 ms  | 140.19 ms    | 62 MB         |
| java-lambda       | 688 ms      | 127.26 ms | 424.02 ms    | 97 MB         |
| kotlin-lambda     | 813 ms      | 215.46 ms | 416.12 ms    | 97 MB         |
| dotnet-lambda     | 1390 ms     | 530.21 ms | 503.63 ms    | 65 MB         |
+-------------------+-------------+-----------+--------------+---------------+
```
