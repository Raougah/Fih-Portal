# =============================================================
# SHEET III: Machine Learning Preprocessing
# Exo: 5
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


# ── 5A: IRIS ─────────────────────────────────────────────────
corr_iris = iris_scaled.corr()
print("\n=== IRIS - Correlation Matrix ===")
print(corr_iris)

plt.figure(figsize=(8, 6))
sns.heatmap(corr_iris, annot=True, fmt='.2f', cmap='coolwarm', square=True)
show("Iris - Correlation Heatmap")
# petal length and petal width are highly correlated (~0.96)
# You could drop one of them without losing much information.

# ── 5B: TITANIC ───────────────────────────────────────────────
corr_titanic = titanic_scaled.corr()
print("\n=== TITANIC - Correlation Matrix ===")
print(corr_titanic)

plt.figure(figsize=(10, 8))
sns.heatmap(corr_titanic, annot=True, fmt='.2f', cmap='coolwarm', square=True)
show("Titanic - Correlation Heatmap")

# ── 5C: MOVIELENS USERS ───────────────────────────────────────
corr_users = users_scaled.corr()
print("\n=== USERS - Correlation Matrix ===")
print(corr_users)

plt.figure(figsize=(6, 5))
sns.heatmap(corr_users, annot=True, fmt='.2f', cmap='coolwarm', square=True)
show("Users - Correlation Heatmap")
