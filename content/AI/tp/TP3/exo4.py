# =============================================================
# SHEET III: Machine Learning Preprocessing
# Exo: 4
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


# ── 4A: IRIS ─────────────────────────────────────────────────
iris_scaled = iris_clean.copy()
numeric_cols_iris = ['sepal length (cm)', 'sepal width (cm)',
                     'petal length (cm)', 'petal width (cm)']

scaler = MinMaxScaler()
iris_scaled[numeric_cols_iris] = scaler.fit_transform(iris_scaled[numeric_cols_iris])

print("\n=== IRIS after MinMax Scaling ===")
print(iris_scaled.describe())
# All values should now be between 0 and 1

fig, axes = plt.subplots(1, 2, figsize=(14, 4))
iris_clean[numeric_cols_iris].boxplot(ax=axes[0])
axes[0].set_title("Before Scaling")
iris_scaled[numeric_cols_iris].boxplot(ax=axes[1])
axes[1].set_title("After MinMax Scaling (0 to 1)")
show("Iris - Feature Scaling")

# ── 4B: TITANIC ───────────────────────────────────────────────
titanic_scaled = titanic_enc.copy()
# Age and Fare have very different ranges -> scale them
numeric_cols_titanic = ['Age', 'Fare', 'SibSp', 'Parch', 'Pclass']

std_scaler = StandardScaler()
titanic_scaled[numeric_cols_titanic] = std_scaler.fit_transform(
    titanic_scaled[numeric_cols_titanic]
)

print("\n=== TITANIC after Standard Scaling ===")
print(titanic_scaled[numeric_cols_titanic].describe())
# Mean should be ~0, std should be ~1

fig, axes = plt.subplots(1, 2, figsize=(14, 4))
titanic_enc[numeric_cols_titanic].boxplot(ax=axes[0])
axes[0].set_title("Before Scaling")
titanic_scaled[numeric_cols_titanic].boxplot(ax=axes[1])
axes[1].set_title("After Standard Scaling (mean=0)")
show("Titanic - Feature Scaling")

# ── 4C: MOVIELENS USERS ───────────────────────────────────────
users_scaled = users_enc.copy()
numeric_cols_users = ['Age', 'Occupation']

scaler2 = MinMaxScaler()
users_scaled[numeric_cols_users] = scaler2.fit_transform(users_scaled[numeric_cols_users])

print("\n=== USERS after MinMax Scaling ===")
print(users_scaled.describe())

fig, axes = plt.subplots(1, 2, figsize=(12, 4))
users_enc[numeric_cols_users].boxplot(ax=axes[0])
axes[0].set_title("Before Scaling")
users_scaled[numeric_cols_users].boxplot(ax=axes[1])
axes[1].set_title("After MinMax Scaling")
show("Users - Feature Scaling")
