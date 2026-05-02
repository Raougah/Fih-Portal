# =============================================================
# SHEET III: Machine Learning Preprocessing
# Exo: 1
# Name: Mohammed Alaa Eddine Mekibes
# Grade: L3 SI G1
# =============================================================

import pandas as pd
import matplotlib.pyplot as plt
from sklearn.datasets import load_iris

# ─── Helper: plot helper to keep code short ───────────────────
def show(title):
    plt.suptitle(title, fontsize=13, fontweight='bold')
    plt.tight_layout()
    plt.show()


# ── 1A: IRIS ─────────────────────────────────────────────────
# load_iris() returns a sklearn Bunch object, not a DataFrame.
# We convert it to a DataFrame manually.
iris_raw = load_iris()
iris = pd.DataFrame(iris_raw.data, columns=iris_raw.feature_names)
iris['species'] = iris_raw.target          # 0=setosa 1=versicolor 2=virginica

print("=== IRIS ===")
print(iris.head())          # first 5 rows
print(iris.tail())          # last 5 rows
print(iris.info())          # column types + non-null counts
print(iris.describe())      # count, mean, std, min, quartiles, max

# Plot: distribution of each numeric column
iris.drop('species', axis=1).hist(bins=20, figsize=(10, 6), color='steelblue')
show("Iris - Feature Distributions")

# ── 1B: TITANIC ───────────────────────────────────────────────
titanic = pd.read_csv('datasets/titanic/train.csv')

print("\n=== TITANIC ===")
print(titanic.head())
print(titanic.tail())
print(titanic.info())
print(titanic.describe())

# Plot: survival count + age distribution
fig, axes = plt.subplots(1, 2, figsize=(12, 4))
titanic['Survived'].value_counts().plot(kind='bar', ax=axes[0], color=['salmon','steelblue'])
axes[0].set_title('Survived (0=No, 1=Yes)')
titanic['Age'].hist(bins=30, ax=axes[1], color='steelblue')
axes[1].set_title('Age Distribution')
show("Titanic - Overview")

# ── 1C: MOVIELENS USERS ───────────────────────────────────────
# The file uses '::' as separator and has no header row.
users = pd.read_csv(
    'datasets/movielens/users.dat',
    sep='::',
    engine='python',
    names=['UserID', 'Gender', 'Age', 'Occupation', 'Zip-code']
)

print("\n=== MOVIELENS USERS ===")
print(users.head())
print(users.tail())
print(users.info())
print(users.describe())

# Plot: gender and age distribution
fig, axes = plt.subplots(1, 2, figsize=(12, 4))
users['Gender'].value_counts().plot(kind='bar', ax=axes[0], color=['steelblue','salmon'])
axes[0].set_title('Gender Count')
users['Age'].hist(bins=15, ax=axes[1], color='steelblue')
axes[1].set_title('Age Distribution')
show("MovieLens Users - Overview")
