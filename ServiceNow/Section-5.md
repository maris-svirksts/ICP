# ServiceNow README

This README provides examples and explanations for common ServiceNow functions and methods used in scripts and business rules.

## Introduction

ServiceNow provides a wide range of functions and methods to perform various tasks, such as logging messages, manipulating data, and interacting with users and sessions. This document aims to provide examples and explanations for some of these functions.

## Examples

### Printing Messages

```javascript
var helloText = 'Hello World';
gs.print(helloText);
```

### Logging Messages

```javascript
gs.log('This is a log message', 'marks_logs');
gs.error('This is an error.');
gs.warn('This is a warning.');
```

### Adding Messages

```javascript
gs.addInfoMessage("Info message for, for example, business rules.");
gs.addErrorMessage("Error message for, for example, business rules.");
```

### Date and GUID Generation

```javascript
gs.print(gs.beginningOfLastMonth());
gs.print(gs.generateGUID());
```

### Multilingual Support

```javascript
gs.print(gs.getMessage('ago')); // Change language, then test.
```

### Properties

```javascript
gs.setProperty('servicenow.201.hello.world', 'testing');
gs.print('Hello ' + gs.getProperty('servicenow.201.hello.world'));
```

### User Information

```javascript
gs.print(gs.getUser().getDisplayName());
gs.print(gs.getUser());
gs.print(gs.getUser().getFirstName());
gs.print(gs.getUser().getLocation());
gs.print(gs.getUser().getUserRoles());
gs.print(gs.getUserID());
```

### Role Checking

```javascript
if(gs.hasRole('itil') || gs.hasRole('admin')) {
    gs.print('The current user has ITIL or Admin role.')
}
```

### Session Management

```javascript
gs.getSession();
```

### Validation

```javascript
gs.nil(incidentGR.short_description);
gs.tableExists('incident');
```

### XML and Event Queue

```javascript
var xmlString = '';
gs.xmlToJSON(xmlString);
gs.eventQueue();
```
