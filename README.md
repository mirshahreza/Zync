# 🗄️ Zync - Database Package Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE.txt)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-Supported-blue.svg)](https://www.microsoft.com/en-us/sql-server/)

**Zync** is a database package manager similar to npm for Node.js or NuGet for .NET. It helps you easily install, manage, and deploy database objects (stored procedures, functions, views, tables) from standardized repositories with automatic dependency resolution.

## ✨ Core Concepts

Zync simplifies database development by applying modern package management principles to SQL:

- 📦 **Package Management**: Manage database objects (procedures, functions, etc.) as modular packages.
- 🔄 **Dependency Resolution**: Automatically install dependencies in the correct order.
- 🎯 **Simple Commands**: Use single commands to deploy entire packages or individual scripts.
- 🛡️ **Safe Deployment**: Handle object creation and updates safely without manual intervention.
- 🏗️ **Standard Repositories**: Use a built-in library of utilities or create your own.

## 🚀 Getting Started

Zync currently supports **SQL Server**, with plans to expand to other database systems.

### 📊 SQL Server
> **Note**: Under development but usable. Some features, like package uninstallation, are not yet implemented.

**[📖 Get Started with SQL Server →](MsSql/README.md)**

## 🏗️ Project Structure

```
Zync/
├── LICENSE.txt
├── README.md                # Project overview (you are here)
└── MsSql/                   # SQL Server implementation
    ├── README.md            # SQL Server specific documentation
    ├── Zync.sql             # Core package manager setup
    └── Packages/            # Available packages
        ├── DbMon/           # Database utilities  
        ├── DbMan/           # Database utilities  
        ├── DbSel/           # Database utilities  
        ├── Math/            # Numeric functions
        └── String/          # String functions
```

## 🎯 Naming Conventions

We recommend prefixing utility objects with `Zz` to keep them organized and separate from your project's business logic. They will appear at the end of database object lists, ensuring your primary objects are always visible first.

Example:
```
Customer_Orders        (your business objects)
Product_Inventory      
...
ZzSplitString         (Zync utilities)
ZzCreateTable        
```

## 🛣️ Roadmap

- [ ] **Oracle** support
- [ ] **MySQL** support  
- [ ] **PostgreSQL** support
- [ ] **Package versioning** system
- [ ] **Package dependency** visualization
- [ ] **Web-based package** browser

## 🤝 Support, Donations & Contributing

If you encounter any issues, have questions, or would like to contribute, here’s how you can help:

### 🆘 Getting Support
- **📝 Create an issue**: The best way to report bugs or request features.
- **📧 Contact the maintainers**: For direct inquiries.
- **📚 Check the documentation**: Each package has its own `README` file.

### ❤️ Financial Support
If you find this project helpful, your contribution would be greatly appreciated. Donations help us dedicate more time to maintenance and new features.

- **[💖 Sponsor on GitHub](https://github.com/sponsors/mirshahreza)**

Thank you for your support!

### 💻 Contributing to Code
Code contributions are welcome! For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a Pull Request.

- Persian guide: See `CONTRIBUTING_FA.md` for a complete, step-by-step guide to adding objects/packages and publishing to the main or a personal repo.
- English guide: See `CONTRIBUTING_EN.md` for the English version of the development & contribution guide.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE.txt](LICENSE.txt) file for details.

---

**Made with ❤️ for the database community**