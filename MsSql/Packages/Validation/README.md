# ✅ Validation Package

The `Validation` package provides a collection of functions for validating various data formats including email addresses, phone numbers, national IDs, bank account numbers, and more.

## 🚀 Deployment

To deploy all scripts in the `Validation` package:
```sql
EXEC dbo.Zync 'i Validation'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Validation/.sql'
```

## 📜 Included Utilities

- ZzValidateEmail: Validate email address format
	- Example: `SELECT [dbo].[ZzValidateEmail]('user@example.com');`
- ZzValidatePhone: Validate phone number format
	- Example: `SELECT [dbo].[ZzValidatePhone]('+989123456789', 'IRAN');`
- ZzValidateIranianNationalId: Validate Iranian national ID
	- Example: `SELECT [dbo].[ZzValidateIranianNationalId]('1234567890');`
- ZzValidateIBAN: Validate International Bank Account Number
	- Example: `SELECT [dbo].[ZzValidateIBAN]('IR123456789012345678901234');`
- ZzValidateCreditCard: Validate credit card number using Luhn algorithm
	- Example: `SELECT [dbo].[ZzValidateCreditCard]('4111111111111111');`
- ZzValidateIP: Validate IP address (IPv4 and IPv6)
	- Example: `SELECT [dbo].[ZzValidateIP]('192.168.1.1', 'IPv4');`
- ZzValidateURL: Validate URL format
	- Example: `SELECT [dbo].[ZzValidateURL]('https://www.example.com');`
- ZzValidateRegex: Validate text against regex pattern
	- Example: `SELECT [dbo].[ZzValidateRegex]('ABC123', '^[A-Z]{3}[0-9]{3}$');`

Notes:
- `ls Validation` shows each item with its short description taken from a `-- Description:` line at the top of the script.
- Functions return 1 for valid data and 0 for invalid data
- Some functions support different country/format standards