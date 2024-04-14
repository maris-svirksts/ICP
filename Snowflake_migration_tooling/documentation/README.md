# Snowflake on Terraform

This resource serves as a comprehensive guide to assist with the migration and management of Snowflake resources using Terraform. It includes detailed documentation, migration guides, and helpful tooling resources.

## Documentation and Guides

### General Documentation
Access comprehensive resources for managing Snowflake with Terraform:
- [Snowflake Terraform Provider](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs)

### Migration Guides
Guides to help you transition your existing infrastructure smoothly:
- [Overall Migration Guide](https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/main/MIGRATION_GUIDE.md) - Overview of the migration process.
- [Resource Migration Guide](https://github.com/Snowflake-Labs/terraform-provider-snowflake/blob/main/docs/technical-documentation/resource_migration.md) - Specific steps for resource migration.

### Specific Block Type Changes
Explore updates and recommended actions for deprecated block types:
- [snowflake_grant_privileges_to_role](snowflake_grant_privileges_to_role.md)

## Tooling for Migration

Enhance your migration process with these specialized scripts:
- [Snowflake Migration Tooling](../helper_scripts/Copy_and_Comment/README.md) - Scripts designed to aid in the migration of Snowflake resources.

## Migration Workflow

### Local Stage
1. **Deactivate the Backend**: Comment out the backend block from `providers.tf` to prevent Terraform from loading any state during the migration.

### Prepare Environment
1. **Initialize Terraform**: Prepare your local environment for migration operations.
    ```bash
    terraform init
    ```

### Run Plan and Save Results
1. **Execute and Log Plan**: Ensure changes are planned correctly without any terminal color formatting, and log output to a designated file.
    ```bash
    export TF_CLI_ARGS="-no-color"
    terraform plan -var-file env/dev.tfvars > ../results.txt 2>&1
    ```
