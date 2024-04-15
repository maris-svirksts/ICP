# Snowflake on Terraform

This resource serves as a guide to assist with the migration and management of Snowflake resources using Terraform. It includes documentation, migration guides, and tooling resources.

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
1. **Deactivate the Backend**: Prevent Terraform from loading state from AWS S3 bucket during migration by commenting out the backend block in `provider.tf`.
    ```hcl
    # backend "s3" {    
    #   encrypt = true
    # }
    ```

2. **If Required, Update Snowflake Provider Version**: Ensure compatibility with the latest features and fixes by specifying the version of the Snowflake provider.
    ```hcl
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = "=0.88.0"
    }
    ```

### Prepare Environment
1. **Initialize Terraform**: Update the modules and plugins to their latest versions as needed by initializing the environment with the `--upgrade` option.
    ```bash
    terraform init --upgrade
    ```

### Run Plan and Save Results
1. **Execute and Log Plan**: Run the plan to ensure correct changes without terminal color formatting. Save the output to a designated file for review.
    ```bash
    export TF_CLI_ARGS="-no-color"
    terraform plan -var-file env/dev.tfvars > ../results.txt 2>&1
    ```

### Branch Naming Convention
1. **Create Branches Strategically**: Name branches according to the specific block or change being worked on to maintain clarity and organization.
    ```plaintext
    git checkout -b DB_Creations
    ```

### Managing Pull Requests
1. **Initiate Pull Requests**: Once you complete changes on a specific task, initiate a pull request for review.
2. **Merge Restrictions**: Merge commits should only be performed by designated team members, to maintain the integrity and stability of the main branch.
