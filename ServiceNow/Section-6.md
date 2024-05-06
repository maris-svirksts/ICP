# ServiceNow README

This README provides examples and explanations for common ServiceNow client-side scripting methods and properties available through the GlideForm and GlideUser objects.

## Introduction

ServiceNow client-side scripting allows you to interact with forms and user information on the client-side, providing dynamic behavior and user interface enhancements.

## GlideForm Examples

### Getting and Setting Field Values

```javascript
var fieldValue = g_form.getValue('category');
g_form.setValue('category', 'Software');
```

### Clearing Field Values and Saving Forms

```javascript
g_form.clearValue('category');
g_form.save();
```

### Disabling and Hiding Fields

```javascript
g_form.setDisabled('category', true);
g_form.hideRelatedLists();
```

### Setting Field Mandatory

```javascript
g_form.setMandatory('category', true);
g_form.isMandatory('category');
```

### Checking if Record is New

```javascript
var isNewRecord = g_form.isNewRecord();
```

### Adding and Clearing Messages

```javascript
g_form.addInfoMessage('Hello: Info');
g_form.addErrorMessage('Hello: Error');
g_form.clearMessages();
```

### Getting Field Label and Table Name

```javascript
g_form.getLabelOf('category');
var tableName = g_form.getTableName();
```

## GlideUser Examples

### Accessing User Information

```javascript
g_user.firstName
g_user.lastName
g_user.userID
g_user.getFullName()
g_user.username
```

### Checking User Roles

```javascript
g_user.hasRoles()
g_user.hasRole('itil')
```
