# =============================================================
# SHEET III: Machine Learning Preprocessing
# Exo: 3
# Name: Mohammed Alaa Eddine Mekibes
# Grade: L3 SI G1
# =============================================================

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_iris
from sklearn.preprocessing import LabelEncoder, MinMaxScaler, StandardScaler

# ─── Helper: plot helper to keep code short ───────────────────
def show(title):
    plt.suptitle(title, fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.show()


# ── 3A: IRIS ─────────────────────────────────────────────────
# 'species' is already encoded as integers (0,1,2) from sklearn.
# Nothing to do, but let's confirm:
print("\n=== IRIS - Categorical columns ===")
print(iris_clean.dtypes)
# Output: all float64 + int64, no object columns -> already numeric

# ── 3B: TITANIC ───────────────────────────────────────────────
print("\n=== TITANIC - Categorical columns before encoding ===")
print(titanic_clean.select_dtypes(include='object').head())

titanic_enc = titanic_clean.copy()

# 'Sex': two values (male/female) -> Label Encoding is fine
le = LabelEncoder()
titanic_enc['Sex'] = le.fit_transform(titanic_enc['Sex'])
# male=1, female=0 (alphabetical order)

# 'Embarked': three ports (C, Q, S) and no order -> One-Hot Encoding
titanic_enc = pd.get_dummies(titanic_enc, columns=['Embarked'], drop_first=True)
# drop_first=True removes one column to avoid multicollinearity
# (if Embarked_Q=0 and Embarked_S=0 then it must be C)

print("\nTitanic after encoding:")
print(titanic_enc.head())
print(titanic_enc.dtypes)

# Visual: value counts of encoded Sex
titanic_enc['Sex'].value_counts().plot(kind='bar', color=['steelblue','salmon'])
plt.title("Sex after Label Encoding (0=female, 1=male)")
plt.tight_layout()
plt.show()

# ── 3C: MOVIELENS USERS ───────────────────────────────────────
print("\n=== USERS - Categorical columns before encoding ===")
print(users_clean.select_dtypes(include='object').head())

users_enc = users_clean.copy()

# 'Gender': M or F -> Label Encoding
users_enc['Gender'] = le.fit_transform(users_enc['Gender'])
# F=0, M=1

print("\nUsers after encoding:")
print(users_enc.head())

users_enc['Gender'].value_counts().plot(kind='bar', color=['steelblue','salmon'])
plt.title("Gender after Label Encoding (0=F, 1=M)")
plt.tight_layout()
plt.show()