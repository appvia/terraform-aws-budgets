## Find the current caller identity, partition, and region to use in the provider configuration
data "aws_caller_identity" "current" {}
## Find the current partition to use in the provider configuration
data "aws_partition" "current" {}
## Find the current region to use in the provider configuration
data "aws_region" "current" {}
