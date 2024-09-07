# aws-benchmarking-experiments

A repository for benchmarking AWS-hosted services and managed service performance. Includes comparisons of Lambda runtimes and cold start optimisations, API Gateway latency, and other AWS-related experiments around performances.

## useful commands

- `terraform init -backend-config=backend.conf` init terraform backend
- `terraform fmt` reformat your configuration in the standard style
- `terraform validate` check whether the configuration is valid
- `terraform plan` show changes required by the current configuration
- `terraform apply` create or update infrastructure
- `terraform destroy` destroy previously-created infrastructure
