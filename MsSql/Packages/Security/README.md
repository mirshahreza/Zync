# 🔐 Security Package

The `Security` package provides a collection of functions for security operations including password hashing, encryption, token generation, and data protection.

## 🚀 Deployment

To deploy all scripts in the `Security` package:
```sql
EXEC dbo.Zync 'i Security'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Security/.sql'
```

## 📜 Included Utilities

- ZzHashPassword: Hash passwords using SHA2_512 with salt
	- Example: `SELECT [dbo].[ZzHashPassword]('mypassword', 'mysalt');`
- ZzGenerateSalt: Generate cryptographically secure salt
	- Example: `SELECT [dbo].[ZzGenerateSalt](32);`
- ZzEncryptData: Encrypt sensitive data using AES encryption
	- Example: `SELECT [dbo].[ZzEncryptData]('sensitive data', 'encryption_key');`
- ZzDecryptData: Decrypt encrypted data
	- Example: `SELECT [dbo].[ZzDecryptData](@encrypted_data, 'encryption_key');`
- ZzGenerateToken: Generate secure random tokens
	- Example: `SELECT [dbo].[ZzGenerateToken](64);`
- ZzValidateToken: Validate token format and expiry
	- Example: `SELECT [dbo].[ZzValidateToken](@token, @created_date, 3600);`
- ZzMaskSensitiveData: Mask sensitive data for display
	- Example: `SELECT [dbo].[ZzMaskSensitiveData]('1234567890123456', 'CARD');`

Notes:
- `ls Security` shows each item with its short description taken from a `-- Description:` line at the top of the script.
- All encryption functions use SQL Server's built-in cryptographic functions
- Passwords are hashed using industry-standard algorithms with salt