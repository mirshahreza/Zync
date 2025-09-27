# Stop Juggling SQL Scripts: Introducing Zync, the Database Package Manager

If you’ve ever worked on a large database project, you know the pain. You have folders filled with SQL scripts for stored procedures, functions, and views. Script `A` depends on `B`, which depends on `C`. Deploying to a new environment means running them in the correct order, and heaven forbid you miss one. Sharing reusable utilities across projects is a copy-paste nightmare.

We’ve built powerful package managers for our application code—npm for Node.js, NuGet for .NET, Pip for Python. They handle dependencies, versioning, and distribution flawlessly. So why are we still managing database scripts like it’s 1999?

It’s time for a change. Introducing **Zync**, a simple but powerful package manager for SQL Server, designed to bring the convenience of modern package management directly into your database.

### The Chaos of Manual Script Management

Before we dive into the solution, let’s appreciate the problem. Traditionally, managing a collection of database objects involves:

*   **Manual Dependency Tracking:** You have to remember that `CreateUserView.sql` must run after `CreateUserTable.sql`. This knowledge is often stored in a developer's head or a fragile `README` file.
*   **Scattered Scripts:** Utility functions and procedures are often scattered across different project folders, leading to code duplication and maintenance headaches.
*   **Inconsistent Deployment:** Deploying to a new database is often a manual, error-prone process that can easily lead to inconsistencies between development, staging, and production environments.
*   **Difficult Collaboration:** Sharing a set of useful database tools with your team or the community is far from straightforward.

Zync was born out of this frustration. It treats your database objects as what they are: **packages**—modular, reusable, and dependency-aware units of code.

### How Zync Simplifies Your Workflow

Zync is built around a single stored procedure, `dbo.Zync`, that acts as your command-line interface inside SQL Server Management Studio (SSMS). Once installed, it gives you access to a world of functionality through simple commands.

The core philosophy is simple: host your SQL packages in a GitHub repository, and let Zync handle the rest.

#### Key Concepts:

*   **📦 Package Management:** Group related SQL objects (procedures, functions, etc.) into a "package," which is simply a folder in a repository.
*   **🔄 Automatic Dependency Resolution:** Define dependencies for a package, and Zync will automatically fetch and install them first.
*   **🎯 Simple Commands:** A clean, intuitive command structure for listing and installing packages.
*   **🏗️ Standardized Repositories:** Use the official Zync repository or point it to your own for private packages.

### Getting Started with Zync

Ready to give it a try? It only takes a few minutes to get up and running.

#### Step 1: Install the Zync Stored Procedure

First, you need to install the core `Zync` procedure in your target database. Just download and run the [`Zync.sql`](https://github.com/mirshahreza/Zync/blob/main/MsSql/Zync.sql) script from the official repository. This one-time setup is all you need.

#### Step 2: List Available Packages

Once installed, you can see which packages are available in the default repository with the `ls` (list) command.

```sql
EXEC [dbo].[Zync] 'ls'
```

This command queries the GitHub API and returns a list of available packages (directories) you can install.

**Expected Output:**

```
Fetching available packages from repository...
Available packages:
-------------------
AppEnd
DbMan
DbMon
DbSel
Math
String
-------------------
```

#### Step 3: Install Your First Package

Let's say you need a set of string manipulation utilities. You can install the `String` package with the `i` (install) command.

```sql
EXEC [dbo].[Zync] 'i String'
```

Here’s what happens behind the scenes:
1.  Zync constructs the URL to the package's main SQL file in the repository.
2.  It fetches the content of the script.
3.  It checks for any dependencies listed at the top of the file and installs them first.
4.  Finally, it executes the script, creating all the objects from the `String` package in your database.

**Output:**

```
Installing package: 'String'...
 -> Fetched 'String' successfully.
 -> Package 'String' installed successfully.
```

Just like that, you now have access to useful functions like `ZzSplitString` and `ZzCountWord` without ever leaving your query editor.

You can also install a single script from a package if you don't need the entire collection:

```sql
-- Installs only the ZzSplitString function
EXEC [dbo].[Zync] 'i String/ZzSplitString.sql'
```

### A Glimpse into the Zync Ecosystem

The default repository already includes several useful packages to get you started:

*   **DbMan, DbMon, DbSel:** A powerful suite of tools for database administration, including procedures to create/drop tables, manage columns, and analyze object dependencies.
*   **String:** A collection of functions for common string operations like splitting, trimming, and counting.
*   **Math:** Helper functions for doing functions with numbers.
*   **AppEnd:** A set of building blocks for applications, including user and role management.

### The Future is Bright

Zync is just getting started. The vision is to create a rich ecosystem of reusable database components. The roadmap includes:

*   **Support for other databases** like PostgreSQL, MySQL, and Oracle.
*   **Package versioning** to manage different versions of a package.
*   **An `uninstall` command** to safely remove packages.

### Join the Movement

Managing database code shouldn't be a chore. Zync offers a streamlined, modern approach that saves time and reduces errors. It empowers developers to build, share, and reuse database utilities with ease.

Check out the project on GitHub, give it a star, and try it out in your own projects. Contributions, feedback, and ideas are always welcome.

**Find the project here: [https://github.com/mirshahreza/Zync](https://github.com/mirshahreza/Zync)**

---

**Mohsen Mirshahreza**
