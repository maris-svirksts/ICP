# ServiceNow README

This README provides examples and explanations for working with GlideRecord in ServiceNow, along with some commonly used functions and best practices.

## Introduction

GlideRecord is a powerful ServiceNow API for database operations. It allows you to interact with records in ServiceNow tables, such as creating, reading, updating, and deleting records.

## Examples

### Example 1: Querying Incidents by Priority

```javascript
var incidentGR = new GlideRecord('incident');
incidentGR.addQuery('priority', 1);
incidentGR.query();
while(incidentGR.next()) {
    gs.print('Priority 1 incident: ' + incidentGR.number + ' : ' + incidentGR.priority.getDisplayValue());
}
```

### Example 2: Querying Incidents with Encoded Query

```javascript
var queryString = 'category=inquiry^active=true^caller_id.name=David Miller';
var incidentGR = new GlideRecord('incident');
incidentGR.addEncodedQuery(queryString);
incidentGR.query();
while(incidentGR.next()) {
    gs.print('Incident: ' + incidentGR.number + ' : ' + incidentGR.priority.getDisplayValue());
}
```

### Example 3: Creating a New Incident

```javascript
var newIncident = new GlideRecord('incident');
newIncident.newRecord();
newIncident.short_description = 'This incident was created from a background script.'
var newIncidentSysId = newIncident.insert();
gs.print(newIncidentSysId);
```

## Access Control Lists (ACL)

```javascript
// Check CRUD Operations Access
var problemGR = new GlideRecord('problem');
problemGR.query();
if(problemGR.canCreate() && problemGR.canRead() && problemGR.canWrite() && problemGR.canDelete()) {
    gs.print("I have access to CRUD operations.");
}
```

## Other Functions and Best Practices

### Getting Record Count

```javascript
var incidentGR = new GlideRecord('incident');
incidentGR.query();
gs.print(incidentGR.getRowCount());
```

### Updating Records

```javascript
// Update Incident Urgency
var incidentGR = new GlideRecord('incident');
incidentGR.get('number', 'INC0010001');
incidentGR.urgency = 2;
incidentGR.update();
```

### Deleting Multiple Records

```javascript
var incidentGR = new GlideRecord('incident');
incidentGR.addEncodedQuery('short_descriptionLIKEIncident #');
incidentGR.deleteMultiple();
```

### Null Query and Not Null Query

```javascript
var incidentGR = new GlideRecord('incident');
incidentGR.addNullQuery('short_description'); // Filter where short_description is null
// incidentGR.addNotNullQuery('short_description'); // Filter where short_description is not null
incidentGR.query();
while(incidentGR.next()) {
    gs.print(incidentGR.number + ' : ' + incidentGR.short_description);
}
```

### Using GlideAggregate

```javascript
// Example with GlideAggregate (on number fields, with counts)
var incidentGR = new GlideRecord('incident');
incidentGR.addQuery('priority', 1);
incidentGR.query();

var aggregate = new GlideAggregate('incident');
aggregate.addQuery('priority', 1);
aggregate.addAggregate('COUNT');
aggregate.query();

while (aggregate.next()) {
    var count = aggregate.getAggregate('COUNT');
    gs.print('Total Priority 1 incidents: ' + count);
}
```

## GlideRecord vs GlideRecordSecure

GlideRecordSecure provides additional security by checking user permissions before allowing access to records. It is recommended to use GlideRecordSecure in scenarios where data security is critical.
