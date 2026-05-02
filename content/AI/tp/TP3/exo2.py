# =============================================================
# SHEET III: Machine Learning Preprocessing
# Exo: 2
# Name: Mohammed Alaa Eddine Mekibes
# Grade: L3 SI G1
# =============================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_iris
from sklearn.preprocessing import LabelEncoder, MinMaxScaler, StandardScaler

iris_raw = load_iris()
iris = pd.DataFrame(iris_raw.data, columns=iris_raw.feature_names)

# ─── Helper: plot helper to keep code short ───────────────────
def show(title):
    plt.suptitle(title, fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.show()

    
# ── 2A: IRIS ─────────────────────────────────────────────────
print("\n=== IRIS - Missing values before ===")
print(iris.isnull().sum())          # Iris is clean; should all be 0

iris_clean = iris.copy()
iris_clean.drop_duplicates(inplace=True)
# No non-relevant columns in Iris

print("Missing after:", iris_clean.isnull().sum().sum())
print("Shape after dedup:", iris_clean.shape)

# Visual confirmation: heatmap of nulls (should be blank)
plt.figure(figsize=(6, 2))
sns.heatmap(iris_clean.isnull(), cbar=False, yticklabels=False, cmap='viridis')
show("Iris - Null Heatmap (should be empty)")

# ── 2B: TITANIC ───────────────────────────────────────────────
print("\n=== TITANIC - Missing values before ===")
print(titanic.isnull().sum())

titanic_clean = titanic.copy()

# 'Age' has ~177 missing values -> fill with median (robust to outliers)
titanic_clean['Age'].fillna(titanic_clean['Age'].median(), inplace=True)

# 'Embarked' has 2 missing values -> fill with mode (most frequent port)
titanic_clean['Embarked'].fillna(titanic_clean['Embarked'].mode()[0], inplace=True)

# 'Cabin' has 687 missing (77%) -> too many to fill, drop the column
titanic_clean.drop(columns=['Cabin'], inplace=True)

# Non-relevant columns for ML prediction: PassengerId, Name, Ticket
titanic_clean.drop(columns=['PassengerId', 'Name', 'Ticket'], inplace=True)

# Drop duplicates
titanic_clean.drop_duplicates(inplace=True)

print("\nMissing values after:")
print(titanic_clean.isnull().sum())

# Visual: before vs after null count per column
fig, axes = plt.subplots(1, 2, figsize=(14, 4))
titanic.isnull().sum().plot(kind='bar', ax=axes[0], color='salmon', title='Before - Nulls per Column')
titanic_clean.isnull().sum().plot(kind='bar', ax=axes[1], color='steelblue', title='After - Nulls per Column')
show("Titanic - Missing Values Before vs After")

# ── 2C: MOVIELENS USERS ───────────────────────────────────────
print("\n=== USERS - Missing values before ===")
print(users.isnull().sum())

users_clean = users.copy()

# 'Zip-code' is a location identifier, not useful for most ML tasks -> drop
users_clean.drop(columns=['Zip-code'], inplace=True)

users_clean.drop_duplicates(inplace=True)

print("Missing after:", users_clean.isnull().sum().sum())
print("Shape after:", users_clean.shape)

plt.figure(figsize=(6, 2))
sns.heatmap(users_clean.isnull(), cbar=False, yticklabels=False, cmap='viridis')
show("Users - Null Heatmap (should be empty)")