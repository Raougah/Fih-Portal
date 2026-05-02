"""
Name: Mohammed Alaa Eddine Mekibes
Date: 19 / 02 / 2026
Code: Sheet Nr 2 Exercise connect with sqlite

"""
# packages
import sqlite3
import pandas as pd

conn = sqlite3.connect("./database.db")
cursor = conn.cursor()

# Create Table
cursor.execute("""
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER               
)
""")

conn.commit()  # Always after CREATE - UPDATE - DELETE

# Inert data
cursor.execute("INSERT INTO users (name, age) VALUES (?,?)", ("Alaa", 21))
conn.commit()

# Read data from table
cursor.execute("SELECT * FROM users")
users = cursor.fetchall()

print("users table:\n")
for u in users:
    print(u)


# connect with excel
df = pd.read_sql_query("SELECT * FROM users", conn)

print("Sqlite with excel:", df)


conn.close()
