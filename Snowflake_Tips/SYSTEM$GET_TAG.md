# Snowflake Tip: Viewing Tag Values

If you need to see a value of a tag in Snowflake and you've been having trouble retrieving it using standard commands, consider using the `SYSTEM$GET_TAG` function. Below is an example to demonstrate this:

## Setup the Environment

First, let's create the necessary database and schema:

```sql
CREATE DATABASE "Test";
CREATE SCHEMA "Test".SCHEMA_1;
```

Next, create a tag on the schema:

```sql
CREATE TAG "Test".SCHEMA_1.TEST COMMENT = 'Indicates sensitive data classification level';
```

## Set Tag Value

We want to see this tag value later, so let's set it:

```sql
ALTER SCHEMA "Test".SCHEMA_1 SET TAG TEST = 'High';
```

## Failed Attempts

The following command might seem like a good fit, but it will not show the tag values as expected:

```sql
SHOW TAGS IN DATABASE "Test";
```

## Successful Solution

To accurately retrieve the value of a specific tag, use the `SYSTEM$GET_TAG` function:

```sql
SELECT SYSTEM$GET_TAG('TEST', 'SCHEMA_1', 'SCHEMA');
```

This function call directly returns the value of the tag applied to the schema.

## Cleanup

Finally, clean up the environment once you're done:

```sql
DROP DATABASE "Test";
```
