# Bash Shell Script Database Management System (DBMS)

## 📌 Project Overview
This project is a simple **Database Management System (DBMS)** built using **Bash shell scripting**. It allows users to create, manage, and manipulate databases and tables in a structured format using XML files.

## 🚀 Features
- 📁 **Database Management**: Create and delete databases.
- 📄 **Table Operations**: Create, insert, update, delete, and modify tables.
- 🔑 **Primary Key Support**: Ensure uniqueness and data integrity.
- 📜 **Column Constraints**: Define column data types, uniqueness, and nullability.
- 📊 **Data Manipulation**: Insert, update, delete rows based on conditions.
- 🔍 **Data Querying**: Select and display data with filtering options.

## 🛠️ Installation & Setup
### Prerequisites
- Linux-based OS (Ubuntu, CentOS, etc.)
- Bash Shell (default in Linux)




### Clone the Repository
```bash
git clone https://github.com/yourusername/your-repo.git
cd your-repo
chmod +x project_improvment.sh  # Ensure the script is executable
```

### Run the Project
```bash
./project_improvment.sh
```

## 📂 Project Structure
```
.
├── project_improvment.sh                 # Main script to start the DBMS
├── functions                             # Folder containing script functions
│   ├── CreateTable.sh                    # Create Table logic
│   ├── InsertIntoTable.sh                # Insert into table logic
│   ├── DeleteFromTable.sh                # Delete operations
│   ├── UpdateTable.sh                    # Update data logic
│   ├── SelectFromTable.sh                # Select and display data
├── databases                             # Folder containing created databases
│   ├── dbname                            # Example database folder
│   │   ├── table.xml                     # Table data in XML format
│   │   ├── table_meta.xml                # Table metadata in XML
└── README.md                             # Project documentation
```

## 📌 Usage Guide
### Create a Database
```bash
./project_improvment.sh
# Choose option to create a new database
```

### Create a Table
1. Select the **database** where you want to create the table.
2. Define **column names**, **data types**, and **constraints** (PK, Unique, Nullable).

### Insert Data
1. Choose a table.
2. Enter values matching column data types.

### Select Data
- Display all records or filter by conditions.

### Update or Delete Data
- Modify existing records using conditions.
- Delete records by **Primary Key** or conditions.

## 🛠️ Troubleshooting
**Issue: `xmlstarlet: command not found`**
- Ensure `xmlstarlet` is installed (`sudo apt install xmlstarlet`).

**Issue: Script not executable**
- Run `chmod +x functions/*.sh` and try again.

## 🤝 Contributing
Pull requests are welcome! If you find any bugs or want to improve the system, feel free to fork the repo and submit a PR.



