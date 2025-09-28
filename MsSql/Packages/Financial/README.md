# 💰 Financial Package

The `Financial` package provides a set of functions for common financial calculations.

## 🚀 Deployment

To deploy all scripts in the `Financial` package:
```sql
EXEC dbo.Zync 'i Financial'
```
Alternatively:
```sql
EXEC dbo.Zync 'i Financial/.sql'
```

## 📜 Included Utilities

- ZzCalculateInterest: Simple interest amount
	- Example: `SELECT [dbo].[ZzCalculateInterest](1000, 12, 2);`
- ZzCalculateLoanPayment: Monthly annuity payment (PMT)
	- Example: `SELECT [dbo].[ZzCalculateLoanPayment](100000, 18, 36);`
- ZzFormatCurrency: Localized currency string via FORMAT
	- Example: `SELECT [dbo].[ZzFormatCurrency](12345.67, 'fa-IR');`
- ZzFutureValueCompound: Future value with compound interest
	- Example: `SELECT [dbo].[ZzFutureValueCompound](1000, 12, 10);`
- ZzPresentValueCompound: Present value from future value (discounting)
	- Example: `SELECT [dbo].[ZzPresentValueCompound](2000, 12, 10);`
- ZzEffectiveAnnualRate: Effective Annual Rate (EAR) from nominal and compounding
	- Example: `SELECT [dbo].[ZzEffectiveAnnualRate](18, 12);`
- ZzNominalFromEffective: Nominal annual rate from EAR and compounding
	- Example: `SELECT [dbo].[ZzNominalFromEffective](19.56, 12);`
- ZzIPMT: Interest portion for a given payment period
	- Example: `SELECT [dbo].[ZzIPMT](18, 36, 1, 100000);`
- ZzPPMT: Principal portion for a given payment period
	- Example: `SELECT [dbo].[ZzPPMT](18, 36, 1, 100000);`

Notes:
- `ls Financial` shows each item with its short description taken from a `-- Description:` line at the top of the script.