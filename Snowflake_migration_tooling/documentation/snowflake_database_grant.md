## Terraform Resource Update: snowflake_grant_privileges_to_role

### Original Configuration
```hcl
resource snowflake_database_grant <name> {
    ...
    roles = [var.pla_admin_role]
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

```hcl
resource snowflake_grant_privileges_to_share <name> {
    ...
}
```

### Changes Summary

#### New Attributes
- `always_apply`: New attribute for applying changes.
- `always_apply_trigger`: New helper field, should not be set.

#### Removed Attributes
- `enable_multiple_grants`: Multiple grants of the same type.
- `revert_ownership_to_role_name`: The name of the role to revert ownership to on destroy.

#### Renamed Attributes
- `roles` changed to `account_role_name`.
- `privilege` changed to `privileges`.
- `database_name` changed to `on_account_object`.

### Related Resources
- [snowflake_database_grant](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/database_grant)
- [snowflake_grant_privileges_to_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_role)
- [snowflake_grant_privileges_to_account_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_account_role)
- [snowflake_grant_privileges_to_database_role](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_database_role)
- [snowflake_grant_privileges_to_share](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs/resources/grant_privileges_to_share)
