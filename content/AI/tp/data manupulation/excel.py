"""
Name: Mohammed Alaa Eddine Mekibes
Date: 19 / 02 / 2026
Code: Sheet Nr 2 Exercise connect with excel

"""
# pip install pandas (for data manipulation) openpyxl (for .xlsx files)
# Packages

import pandas as pd

# ========== connect with excel file [DEFAULT read first sheet]
file = pd.read_excel("Book.xlsx")

# ========== Manipulation

print("\n=============== Read 10 rows:\n", file.head(10)) # read rows [DEFAULT 5 rows]
print("\n================ Read all columns\n", file.columns)
print("\n================ file info\n", file.info())

# ========== Read specific sheet
file = pd.read_excel("Book.xlsx", sheet_name="school") # Or sheet_name=1

# ========== Read All sheets
file = pd.read_excel("Book.xlsx", sheet_name=None)

print("\n================ Get all sheets name\n", file.keys())
print("\n================ access a specific sheet\n", file["school"])

# ========== Read Specific cols
file = pd.read_excel("Book.xlsx", usecols=[0,2]) # Or usecols=["id","age"]
print("\n================ Read specific columns\n", file)

# ========== skip rows
file = pd.read_excel("Book.xlsx", skiprows=2)
print("\n================ Read all rows except skipped row \n", file)
