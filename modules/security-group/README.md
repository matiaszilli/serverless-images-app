# AWS EC2-VPC Security Group Terraform module

## Usage

```hcl
module "create_sg" {
  source = "./modules/security-group"

  create_sg = true
  # omitted...
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.9 |
| aws | >= 2.55.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.55.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| create\_sg | Toggle controlling whether to create the security group | `bool` | `true` | no |
| description | Description of the Security Group | `string` | `"Managed by Terraform"` | no |
| egress\_rules | A schema list of egress rules for the Security Group, see <https://www.terraform.io/docs/providers/aws/r/security_group.html#egress> | `list` | `[]` | no |
| ingress\_rules | A schema list of ingress rules for the Security Group, see <https://www.terraform.io/docs/providers/aws/r/security_group.html#ingress> | `list` | `[]` | no |
| name | Name of the Security Group | `string` | n/a | yes |
| revoke\_rules\_on\_delete | Determines whether to forcibly remove rules when destroying the security group | `string` | `false` | no |
| tags | A map of tags for the Security Group | `map(string)` | `{}` | no |
| vpc\_id | VPC ID in which to create the Security Group | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| arn | The ARN of the Security Group |
| id | The ID of the Security Group |
| name | The name of the Security Group |
| owner\_id | The owner ID of the Security Group |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
