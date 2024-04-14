# Snowflake on Terraform

A collection of guides and tools to assist with the migration and management of Snowflake resources using Terraform.

## Documentation and Guides

### General Documentation
- [Snowflake Terraform Provider](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)

### Migration Guides
- [Overall Migration Guide](https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/main/MIGRATION_GUIDE.md)
- [Resource Migration Guide](https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/main/docs/technical-documentation/resource_migration.md)

### Specific Block Type
- [snowflake_grant_privileges_to_role](snowflake_grant_privileges_to_role.md)


## Tooling for Migration
- [Snowflake Migration Tooling](https://github.com/maris-svirksts/ICP/tree/main/Snowflake_migration_tooling/helper_scripts/Copy_and_Comment)

## Migration Workflow

### Local Stage
1. Comment out the backend block from `providers.tf`.

### Prepare Environment
1. Initialize the working directory containing Terraform configuration files.
    ```bash
    terraform init
    ```

### Run Plan and Save Results
1. Export `TF_CLI_ARGS` to avoid colored output and run the plan with variable files, saving the output to `results.txt`.
    ```bash
    export TF_CLI_ARGS="-no-color"
    terraform plan -var-file env/dev.tfvars > ../results.txt 2>&1
    ```