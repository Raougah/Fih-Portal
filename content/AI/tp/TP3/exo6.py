# =============================================================
# SHEET III: Machine Learning Preprocessing
# Exo: 6
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


def remove_outliers_iqr(df, columns):
    """
    Removes rows where any value in 'columns' falls outside
    the IQR fences. Returns the cleaned DataFrame.
    """
    df_out = df.copy()
    for col in columns:
        Q1 = df_out[col].quantile(0.25)
        Q3 = df_out[col].quantile(0.75)
        IQR = Q3 - Q1
        lower = Q1 - 1.5 * IQR
        upper = Q3 + 1.5 * IQR
        df_out = df_out[(df_out[col] >= lower) & (df_out[col] <= upper)]
    return df_out

# ── 6A: IRIS ─────────────────────────────────────────────────
fig, axes = plt.subplots(1, 2, figsize=(14, 5))
iris_scaled[numeric_cols_iris].boxplot(ax=axes[0])
axes[0].set_title("Before Outlier Removal")

iris_no_out = remove_outliers_iqr(iris_scaled, numeric_cols_iris)

iris_no_out[numeric_cols_iris].boxplot(ax=axes[1])
axes[1].set_title("After Outlier Removal")
show("Iris - Outliers")

print(f"\nIris rows removed: {len(iris_scaled) - len(iris_no_out)}")

# ── 6B: TITANIC ───────────────────────────────────────────────
fig, axes = plt.subplots(1, 2, figsize=(14, 5))
titanic_scaled[['Age','Fare']].boxplot(ax=axes[0])
axes[0].set_title("Before Outlier Removal")

titanic_no_out = remove_outliers_iqr(titanic_scaled, ['Age', 'Fare'])

titanic_no_out[['Age','Fare']].boxplot(ax=axes[1])
axes[1].set_title("After Outlier Removal")
show("Titanic - Outliers (Age, Fare)")

print(f"Titanic rows removed: {len(titanic_scaled) - len(titanic_no_out)}")

# ── 6C: MOVIELENS USERS ───────────────────────────────────────
fig, axes = plt.subplots(1, 2, figsize=(12, 5))
users_scaled[numeric_cols_users].boxplot(ax=axes[0])
axes[0].set_title("Before Outlier Removal")

users_no_out = remove_outliers_iqr(users_scaled, numeric_cols_users)

users_no_out[numeric_cols_users].boxplot(ax=axes[1])
axes[1].set_title("After Outlier Removal")
show("Users - Outliers")

print(f"Users rows removed: {len(users_scaled) - len(users_no_out)}")

print("\n=== ALL EXERCISES COMPLETE ===")