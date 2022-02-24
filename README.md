# bv-tech

### Requirements:
- Terraform 1.1.6
- AWS CLI Configured with a Default Profile
- Alternatively, you can use: [AWS Environment Variables](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

### Quick Utilization:


**Note:** *If running in your own AWS environment you will need to override the default Zone ID in* `variables.tf` 

[Documentation](https://www.terraform.io/language/values/variables#variables-on-the-command-line)


1) As configured this leverages a default AWS profile (not a named profile). Ensure you have the AWS CLI configured with a default profile.

2) Clone this repository

3) From the Root; run: `terraform init` then `terraform plan`; if this output is to your liking: `terraform apply` (note: the `-out` flag should be used and passed to `terraform apply` to ensure plan execution matches intention in more "important" deployment scenarios)

4) The ALB DNS Name will be published at the console; by default (on my AWS environment) the ALB will also be published at http://bvco.seta.sh/
---

Some notes:
- Currently all parts of the infrastructure are deployed as one configuration; generally I'd advise finding a logical truncation point to segment your terraform configurations (in this case, I'd generally move the base VPC configuration into a new configuration and reference outputs from that, exposed explicitly); and similarly, any external services we'd add (RDS, etc) into other configurations - think _blast radius_ in terms of incorrect deployment and logical segmentation of scope.

- This is not configured for production use; namely: the backend is not configured, and we're not heavily using inferred information (variables and/or runtime information/introspection). In short: this particular environment is not suitably dynamic nor safe for production use.

- The VPC is built leveraging the AWS release of the AWS VPC Module: https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/latest; in a more rigorous environment I'd recommend pinning resources such as this:

e.g. 
```
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"
}
```

- Obviously this service is published on port 80 at current; I'd strongly advise integration with ACM or similar Certificate Authority; this would be contextualized by need and deployment requirements of a given system.