# Terraform 

## Terraform repository structure

The standard module structure is a file and directory layout we recommend for reusable modules distributed in separate repositories.  
The standard structure expects at least a `main.tf`, `outputs.tf`, `variables.tf` and `versions.tf` file.

A complete standard structure is shown below:

```bash
$ tree tf-module-template/
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── versions.tf
├── ...
├── modules/
│   ├── nestedA/
│   │   ├── README.md
│   │   ├── variables.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   ├── nestedB/
│   ├── .../
├── examples/
│   ├── exampleA/
│   │   ├── main.tf
│   ├── exampleB/
│   ├── .../
```

## Write module usage Examples. 

Examples of using the module must exist under the `examples/` subdirectory at the root of the repository.  
Each example have to have a README to explain the goal and usage of the example.  
Because examples will often be copied into other repositories for customization, any module blocks should have their source set to the address an external caller would use, not to a relative path.

## About nested modules

Nested modules allow you to divide complexity to provide more flexible configuration options.  
Those must be placed under `modules/` subdirectory to have a consistent folder structure. This is optional and only used if nested modules are included.  
You must use nested modules only for specific purposes (e.g: create a AWS EC2 node cluster). For common purposes (e.g: create a AWS VPC), it is highly recommendable to use common modules repositories in order to avoid code duplication and keep a centralized module repositories that also benefits from module updates.  
If a repository contains multiple nested modules, they should ideally be composable by the caller, rather than calling directly to each other and creating a deeply-nested tree of modules.  
It is not recommendable to writing modules that are just thin wrappers around single other resource types, just use the resource type directly in the calling module instead.

## Provider versions

Providers are plugins released on a separate rhythm from Terraform itself, and so they have their own version numbers.  
For production use, you MUST constrain the acceptable provider versions via configuration, to ensure that new versions with breaking changes will not be automatically installed by `terraform init` in future.  
To constrain the provider version as suggested, add a required_providers block inside a terraform block:  
```
terraform {
  required_providers {
    aws = "2.7.0"
  }
}
```
Provider version constraints can also be specified using a version argument within a provider block, but that simultaneously declares a new provider configuration that may cause problems particularly when writing shared modules.
