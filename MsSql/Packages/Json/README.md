# 📄 Json Package

The `Json` package provides a collection of functions for JSON manipulation including extraction, validation, transformation, and conversion operations.

## 🚀 Deployment

To deploy all scripts in the `Json` package:
```sql
EXEC dbo.Zync 'i Json'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Json/.sql'
```

## 📜 Included Utilities

- ZzJsonExtract: Extract values from JSON using path
	- Example: `SELECT [dbo].[ZzJsonExtract]('{"name":"John","age":30}', '$.name');`
- ZzJsonValidate: Validate JSON format
	- Example: `SELECT [dbo].[ZzJsonValidate]('{"valid": true}');`
- ZzJsonMerge: Merge two JSON objects
	- Example: `SELECT [dbo].[ZzJsonMerge]('{"a":1}', '{"b":2}');`
- ZzJsonToTable: Convert JSON array to table format
	- Example: `SELECT * FROM [dbo].[ZzJsonToTable]('[{"id":1,"name":"John"}]');`
- ZzTableToJson: Convert table/query results to JSON
	- Example: `SELECT [dbo].[ZzTableToJson]('SELECT id, name FROM users');`
- ZzJsonTransform: Transform JSON structure using mapping
	- Example: `SELECT [dbo].[ZzJsonTransform](@json, @mapping);`
- ZzJsonFlatten: Flatten nested JSON to key-value pairs
	- Example: `SELECT * FROM [dbo].[ZzJsonFlatten]('{"user":{"name":"John","age":30}}');`
- ZzJsonArrayLength: Get length of JSON array
	- Example: `SELECT [dbo].[ZzJsonArrayLength]('[1,2,3,4,5]');`

Notes:
- `ls Json` shows each item with its short description taken from a `-- Description:` line at the top of the script.
- Functions use SQL Server's built-in JSON functions (2016+)
- Compatible with standard JSON format specifications