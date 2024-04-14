## Terraform Resource Update: snowflake_grant_privileges_to_role

### Original Configuration
```hcl
resource snowflake_grant_privileges_to_role <name> {
    ...
    role_name = var.pla_admin_role
    ...
}
```

### Suggested Changes
```hcl
resource snowflake_grant_privileges_to_account_role <name> {
    ...
    account_role_name = var.pla_admin_role
    ...
}
```

### Changes Summary

#### New Attributes
- `always_apply`: New attribute for applying changes.
- `always_apply_trigger`: New helper field, should not be set.

#### Renamed Attributes
- `role_name` changed to `account_role_name`.

#### Attribute Modifications
    - `on_account_object`
        - `object_type`:
            - **Additional Value Available**: `COMPUTE POOL`.

### Related Resources
- [snowflake_grant_privileges_to_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_role)
- [snowflake_grant_privileges_to_account_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_account_role)
- [snowflake_grant_privileges_to_database_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_database_role)
- [snowflake_grant_privileges_to_share](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_share)
